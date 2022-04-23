%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symboles.h"
#include "instructions.h"

int varchar[16];
int yylex(); //fix warning
void yywarning(char *s);
extern int lineno; // count the lines

symbole * ts;
instruction * ti;
%}

%union {int nb; char varchar[16];}
%token tEGAL tPO tPF tAO tAF tSOUS tADD tDIV tMUL tERR tPRINTF tMAIN tINT tSTR tCONST tVIRG tPVIRG tIF tWHILE tFOR tINF tSUP tINFEG tSUPEG tEGALEGAL tELIF tELSE
%token <nb> tNB
%token <varchar> tID
%type <nb> VarType
%type <nb> PreType
%type <nb> Type
%start Programme

%left tADD tSOUS
%left tMUL tDIV

%%

Programme: Funs;

Funs: Fun | Fun Funs ;
Fun: FunType FunName tPO DeclArgs tPF tAO Body tAF;

FunCall: tPRINTF tPO tID tPF {
    ajouter_instruction(ti, "PRI", get_addr(ts, $3, 0), "_", "_");
};

FunCall: FunName tPO CallArgs tPF;

DeclArgs: VarType tID DeclArgNext |;
DeclArgNext: tVIRG DeclArgs |;

CallArgs: RightOperand CallArgNext |;
CallArgNext: tVIRG CallArgs |;

PreType: tCONST { $$ = 1; } | { $$ = 0; } ;
Type: tINT { $$ = 10; } | tSTR { $$ = 20; };
FunType: Type;
VarType: PreType Type { $$ = $1 + $2; } ;

FunName: tMAIN | tID; 

Body: Lignes;
Lignes: Ligne Lignes |;
Ligne: FunCall tPVIRG;
Ligne: Declaration tPVIRG;
Ligne: Affectation tPVIRG;
Ligne: Condition tAO {inc_depth();} Body tAF {

    // En sortie d'une condition if, else if et else, la pile de symboles est comme ça :
    // 1:tmp_if (initialise contient la position de l'instruction à modifier)
    // 3:result_end (important pour la suite des conditions, n'existe pas pour les else)

    supprimer_symbole(ts);
    dec_depth();
    // On a décrémenté la profondeur et supprimé les variables crées lors du if
    // Ainsi, le premier symbole tmp correspond au symbole qui contient l'adresse
    // de l'instruction jump à modifier
    
    symbole tmp_condition = depiler_symbole(ts);
    
    int jmp_index = tmp_condition.initialise;
    
    
    // La valeur du JMF  dépend de si c'est un if ou un while
    char * ti_addr = malloc(3);
    
    
    // Si c'est un while, il faut aussi ajouter une instruction jump
    // jmp_index c'est l'adresse du JMF donc c'est aussi le début du while
    if (strcmp(tmp_condition.nomVariable, "tmp_while") == 0) {
    
    
        // Si c'est un while, l'adresse de fin est augmentée de 1 car on ajoute
        // un jump qui fait partie du while.
        sprintf(ti_addr, "%d", get_taille_ti());
    
        char * jmp = malloc(3);
        sprintf(jmp, "%d", depiler_symbole(ts).initialise-1); // on dépile le tmp_while2
        ajouter_instruction(ti, "JMP", jmp, "_", "_");
    }
    // cas if
    else {
        sprintf(ti_addr, "%d", get_taille_ti()-1);
    }
    
    strcpy(ti[jmp_index].arg2, ti_addr); // on met à jour le JMF
    };

Declaration: VarType tID {
    char vartype[5];
    sprintf(vartype, "%d", $1);
    
    // Si symbole existe déjà, lève warning
    raise_redefinition_error(ts, $2);
    
    ajouter_symbole(ts, $2, vartype, 0);
};

// C'est techniquement VarType Affectation mais c'est plus simple comme ça
// pour ajouter la variable.
Declaration: VarType tID tEGAL RightOperand {

    char * ro = depiler_addr(ts); 
    char vartype[5];
    sprintf(vartype, "%d", $1);
    
    // Si symbole existe déjà, lève warning
    raise_redefinition_error(ts, $2);
    
    ajouter_symbole(ts, $2, vartype, 1);
    ajouter_instruction(ti, "COP", get_addr(ts, $2, 0), ro, "_");
};

RightOperand: FunCall ;
RightOperand: Operations;
RightOperand: tNB {
    char * nb_char = malloc(3);
    sprintf(nb_char, "%d", $1);
    ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "tmp", "tmp", 0), nb_char, "_");

};
RightOperand: tID {
    
    symbole s = get_symbole(ts, $1);
    
    if (s.initialise == 0) {
        char * error = malloc(100);
        sprintf(error, "[%d] ERROR: Variable <%s> has not been initialized.\n", lineno, s.nomVariable);
        yyerror(error);
    }
    
    char * addr = malloc(3);
    sprintf(addr, "%d", get_taille_ts());
    
    ajouter_instruction(ti, "COP", ajouter_symbole(ts, "tmp", "tmp", 0), addr, "_");
};

// Nombre négatif
Operations: tSOUS RightOperand {
    char * arg2 = depiler_addr(ts);
    char * arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "SOU", arg1, "0", arg2);

};

Operations: RightOperand tSOUS RightOperand {
    char * arg3 = depiler_addr(ts);
    char * arg2 = depiler_addr(ts);
    char * arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "SOU", arg1, arg2, arg3);

};
Operations: RightOperand tADD RightOperand {
    char * arg3 = depiler_addr(ts);
    char * arg2 = depiler_addr(ts);
    char * arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "ADD", arg1, arg2, arg3);

};
Operations: RightOperand tDIV RightOperand {
    char * arg3 = depiler_addr(ts);
    char * arg2 = depiler_addr(ts);
    char * arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "DIV", arg1, arg2, arg3);

};
Operations: RightOperand tMUL RightOperand {
    char * arg3 = depiler_addr(ts);
    char * arg2 = depiler_addr(ts);
    char * arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "MUL", arg1, arg2, arg3);

};

Affectation : tID tEGAL RightOperand {
    char * addr = get_addr(ts, $1, 0);
    ajouter_instruction(ti, "COP", addr, depiler_addr(ts), "_");
    ts[strtol(addr, NULL, 10)].initialise = 1;
};

Condition: tFOR ForCondition;
Condition: tWHILE {
    ajouter_symbole(ts, "tmp_while2", "tmp", get_taille_ti());
} ArgCondition {
    char * condition = depiler_addr(ts);
    
    // On l'appelle tmp_while pour pouvoir le différencier des tmp_if
    // Un tmp_while est suivi d'un autre tmp_while (ya une boucle donc deux jump)
    ajouter_symbole(ts, "tmp_while", "tmp", get_taille_ti());
    
    ajouter_instruction(ti, "JMF", condition, "-1", "_");
};

Condition: tIF ArgCondition {

    char * condition = depiler_addr(ts);
    
    // on dépile et remet juste après car besoin ensuite pour les elif/else
    // contient même adresse donc rien ne s'est passé du point de vue instruction
    char * result_end = ajouter_symbole(ts, "result_end", "tmp", 0);

    ajouter_instruction(ti, "COP", result_end, condition, "_");
    
    
    // taille_ti correspond à l'index du Jump du if dans la table d'instruction
    // ajouter_symbole incrémente taille_ti et l'indice correspond à taille_ti-1
    ajouter_symbole(ts, "tmp_if", "tmp", get_taille_ti());
    
    // on stocke l'emplacement dans ti de cette instruction pour pouvoir
    // modifier l'adresse de ligne de retour -> dans le symbole tmp_if
    ajouter_instruction(ti, "JMF", condition, "-1", "_");
};

Condition: tELIF ArgCondition {

    // Opération : !end && cond_elif
    // end = end || cond_elif
    
    // Pour un else if, on a besoin de savoir si une condition précédente
    // était vérifiée (si un if = true, aucun else accepté).
    // End correspond à la variable "une condition précédente est vraie"
    
    char * cond_addr_elif = depiler_addr(ts); // condition du else if
    
    // On dépile end pour voir si la chaine est finie
    char * end_addr;
    end_addr = depiler_verifier_symbole(ts, 0);
    
    
    
    // On a besoin d'un tmp_if pour mettre à jour le pointeur
    // et on a besoin d'un end pour les prochains elif/else
    // Dès qu'on sort du else if on s'attend à avoir tmp_if donc c'est la dernière tmp à push
    // Il restera en haut de la pile le result_end qui est lui important par la suite
    char * result_end = ajouter_symbole(ts, "result_end", "tmp", 0);
    char * result_condition = ajouter_symbole(ts, "result_condition", "tmp", 0);
    
    char * result_not = ajouter_symbole(ts, "tmp", "result_not", 0);
    
    ajouter_instruction(ti, "NOT", result_not, end_addr, "_");
    depiler_addr(ts); // on dépile le result_not
    
    // On a pas besoin de savoir si le else if précédent est vrai ou faux, juste de si
    // un des else if précédent est vrai. Donc on a pas besoin de result_condition dans le futur
    depiler_addr(ts); // On dépile result_condition
    
    // on entre dans le if si (!end && elif) <-> (result_not && cond_addr_elif)
    ajouter_instruction(ti, "AND", result_condition, result_not, cond_addr_elif);
    
    
    
    ajouter_instruction(ti, "OR", result_end, result_condition, end_addr);
    
    ajouter_symbole(ts, "tmp_if", "tmp", get_taille_ti()); //pointe vers l'instruction JMF
    
    // result_condition = !cond_addr_if && cond_addr_elif
    ajouter_instruction(ti, "JMF", result_condition, "-1", "_");
    
    
    
};
Condition: tELSE {

    // on supprime la variable temporaire qui correspond à la condition

    char * end_addr;
    end_addr = depiler_verifier_symbole(ts, 0);
    
    
    char * result_not = ajouter_symbole(ts, "tmp", "result_not", 0);
    
    ajouter_instruction(ti, "NOT", result_not, end_addr, "_");
    depiler_addr(ts); //On dépile le result_not
    
    // result_condition = !end
    // si aucun if précédent n'est vrai, else passe
    // donc pas besoin de AND ce coup-ci
    
    ajouter_symbole(ts, "tmp_if", "tmp", get_taille_ti());
    
    
    ajouter_instruction(ti, "JMF", result_not, "-1", "_");
    
    
};
ArgCondition: tPO Bool tPF;
ForCondition: tPO DeclarationIndice tPVIRG Bool tPVIRG Affectation tPF;
DeclarationIndice: Affectation | tID;

Bool: Comparaison;
Bool: tID {
    ajouter_instruction(ti, "COP", ajouter_symbole(ts, "tmp", "tmp", 0), get_addr(ts, $1, 0), "_");
};

Comparaison: RightOperand tEGALEGAL RightOperand {
    char * op1 = depiler_addr(ts);
    char * op2 = depiler_addr(ts);
    
    char * result_egal = ajouter_symbole(ts, "tmp", "result_condition", 0);
    ajouter_instruction(ti, "EQU", result_egal, op1, op2);
};

Comparaison: RightOperand tINF RightOperand {
    char * op1 = depiler_addr(ts);
    char * op2 = depiler_addr(ts);
    
    char * result_egal = ajouter_symbole(ts, "tmp", "result_condition", 0);
    ajouter_instruction(ti, "INF", result_egal, op2, op1);
};

Comparaison: RightOperand tSUP RightOperand {
    char * op1 = depiler_addr(ts);
    char * op2 = depiler_addr(ts);
    
    char * result_egal = ajouter_symbole(ts, "tmp", "result_condition", 0);
    ajouter_instruction(ti, "SUP", result_egal, op2, op1);
};


/*
Comparaison: RightOperand tINFEG RightOperand {
    int op1 = depiler_addr(ts);
    int op2 = depiler_addr(ts);
    // EGAL
    int result_egal = ajouter_symbole(ts, "tmp", "result_egal", 0);
    ajouter_instruction(ti, "EQU", result_egal, op1, op2);
    // INF
    int result_inf = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "INF", result_inf, op1, op2);
    // Ils sont dans la pile car temporaire mais on a déjà leur adresse
    // donc on ignore le retour
    depiler_addr(ts); // c'est result_egal
    depiler_addr(ts); // c'est result_inf
    int result_or = ajouter_symbole(ts, "tmp", "tmp_condition", 0);
    
    ajouter_instruction(ti, "OR", result_or, result_egal, result_inf); 
    // A ou B = Non [ (Non A) et (Non B)]
    
    
};
*/


%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); free(s); exit(-1); }
void yywarning(char *s) { printf("%s\n", s); }
int main(void) {
  //yydebug=1;
  ts = init_ts();
  ti = init_ti();
  // On fait des comparaisons logiques ensuite (else if par ex.)
  // Il est pratique d'avoir un 0 pré existant plutôt que de créer une variable = 0
  // à chaque comparaison logique : EQU 14 14 0 -> @14 = (@14 == @0) où @0 contient 0
  // De même pour 1
  // UPDATE : ajouté OR, AND et NOT instructions pour enlever ce problème
  // Mais quand même besoin d'un 0 pour les nombres négatifs
  ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "zero", "int", 1), "0", "_");
  //ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "one", "int", 1), "1", "_");
  
  
  yyparse();
  //print_ts(ts);
  //print_ti(ti);
  write_from_table(ti);
  return 0;
}
