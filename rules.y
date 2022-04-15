%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symboles.h"
#include "instructions.h"
int varchar[16];
void yyerror(char *s);
int yylex(); //fix warning

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
    ajouter_instruction(ti, "PRI", get_addr(ts, $3), "_", "_");
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
    supprimer_symbole(ts);
    dec_depth();
    // On a décrémenté la profondeur et supprimé les variables crées lors du if
    // Ainsi, le premier symbole tmp correspond au symbole qui contient l'adresse
    // de l'instruction jump à modifier
    int jmp_index = depiler_symbole(ts).declare;
    
    // on met à jour le jump
    // on lui assigne la ligne en cours
    char * ti_addr = malloc(3);
    sprintf(ti_addr, "%d", get_taille_ti()-1);
    strcpy(ti[jmp_index].arg2, ti_addr);
    
    // On ne supprimer pas le symbole associé à la condition
    // il permet de vérifier qu'il n'y a pas de code entre le if et le else
    // et il permet de retrouver la condition pour les else if et else
    };

Declaration: VarType tID {
    char vartype[5];
    sprintf(vartype, "%d", $1);
    ajouter_symbole(ts, $2, vartype, 1);
};

RightOperand: FunCall ;
RightOperand: Operations;
RightOperand: tNB {
    char * nb_char = malloc(3);
    sprintf(nb_char, "%d", $1);
    ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "tmp", "tmp", 0), nb_char, "_");

};
RightOperand: tID {
    ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "tmp", "tmp", 0), get_addr(ts, $1), "_");
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
    ajouter_instruction(ti, "COP", get_addr(ts, $1), depiler_addr(ts), "_");
};


Condition: tWHILE ArgCondition | tFOR ForCondition ;

Condition: tIF ArgCondition {

    char * condition = depiler_addr(ts); 
    // on dépile et remet juste après car besoin ensuite pour les elif/else
    // contient même adresse donc rien ne s'est passé du point de vue instruction
    ajouter_symbole(ts, "result_condition", "tmp", 0);
    
    // taille_ti correspond à l'index du Jump du if dans la table d'instruction
    // ajouter_symbole incrémente taille_ti et l'indice correspond à taille_ti-1
    ajouter_symbole(ts, "tmp_if", "tmp", get_taille_ti());
    
    // on stocke l'emplacement dans ti de cette instruction pour pouvoir
    // modifier l'adresse de ligne de retour -> dans le symbole tmp_if
    ajouter_instruction(ti, "JMF", condition, "-1", "_");
};

Condition: tELIF ArgCondition {

    // Opération : !cond_if && cond_elif
    
    char * cond_addr_elif = depiler_addr(ts); // condition du else if
    char * cond_addr = depiler_addr(ts); // condition du if
    
    char * result_egal = ajouter_symbole(ts, "tmp", "result_egal", 0);
    
    ajouter_instruction(ti, "EQU", result_egal, "0", cond_addr); // @0 contient 0
    depiler_addr(ts); // on dépile le result_egal 
    
    // On a besoin d'un tmp_if pour mettre à jour le pointeur
    // et on a besoin d'un result condition pour les prochains elif/else
    // Dès qu'on sort du else if on s'attend à avoir tmp_if donc c'est la dernière tmp à push
    char * result_condition = ajouter_symbole(ts, "result_condition", "tmp", 0);
    
    // 1 = true, 0 = false ==>  1x1=true, reste=false comme &&
    ajouter_instruction(ti, "MUL", result_condition, result_egal, cond_addr_elif);
    
    ajouter_symbole(ts, "tmp_if", "tmp", get_taille_ti());
    
    // result_condition = !cond_addr_if && cond_addr_elif
    ajouter_instruction(ti, "JMF", result_condition, "-1", "_");
    
};
Condition: tELSE {
    // on supprime la variable temporaire qui correspond à la condition
    char * cond_addr = depiler_addr(ts);
    
    char * result_egal = ajouter_symbole(ts, "tmp", "result_egal", 0);
    
    // évaluer x == 0
    // si cond_addr == 0 résultat est 1 (true)
    // si cond_addr == 1 résultat est 0 (false)
    // donc resultat contient !cond_addr
    ajouter_instruction(ti, "EQU", result_egal, "0", cond_addr);
    depiler_addr(ts); // on dépile le result_egal
    
    ajouter_symbole(ts, "tmp_if", "tmp", get_taille_ti());
    ajouter_instruction(ti, "JMF", result_egal, "-1", "_");
    
    // on ne créé pas de result_condition car c'est un else
};
ArgCondition: tPO Bool tPF;
ForCondition: tPO DeclarationIndice tPVIRG Bool tPVIRG Affectation tPF;
DeclarationIndice: Affectation | tID;

Bool: Comparaison;
Bool: tID {
    ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "tmp", "tmp", 0), get_addr(ts, $1), "_");
};
/*
Comparaison: RightOperand tINF RightOperand {
    int arg2 = get_addr(ts, $1);
    int arg3 = get_addr(ts, $3);
    int arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "INF", arg1, arg2, arg3);
};
Comparaison: RightOperand tSUP RightOperand {
    int arg2 = get_addr(ts, $1);
    int arg3 = get_addr(ts, $3);
    int arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "SUP", arg1, arg2, arg3);
};
*/

Comparaison: RightOperand tEGALEGAL RightOperand {
    char * op1 = depiler_addr(ts);
    char * op2 = depiler_addr(ts);
    
    char * result_egal = ajouter_symbole(ts, "tmp", "result_condition", 0);
    ajouter_instruction(ti, "EQU", result_egal, op1, op2);
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
    int result_or = ajouter_symbole(ts, "tmp", "tmp", 0);
    
    ajouter_instruction(ti, "OR", result_or, result_egal, result_inf); 
    // A ou B = Non [ (Non A) et (Non B)]
    
    
    int next = ajouter_symbole(ts, "next", "tmp_if", 0);

    ajouter_instruction(ti, "JMF", result_or, next, 0);
};
*/
// pk il reste des tmp à la fin ?
// traduire les comparaisons

%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Compilateur\n");
  //yydebug=1;
  ts = init_ts();
  ti = init_ti();
  // On fait des comparaisons logiques ensuite (else if par ex.)
  // Il est pratique d'avoir un 0 pré existant plutôt que de créer une variable = 0
  // à chaque comparaison logique : EQU 14 14 0 -> @14 = (@14 == @0) où @0 contient 0
  // De même pour 1
  ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "zero", "int", 1), "0", "_");
  ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "one", "int", 1), "1", "_");
  yyparse();
  //print_ts(ts);
  //print_ti(ti);
  write_from_table(ti);
  return 0;
}
