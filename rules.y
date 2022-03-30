%{
#include <stdlib.h>
#include <stdio.h>
#include "symboles.h"
#include "instructions.h"
int varchar[16];
void yyerror(char *s);
int yylex(); //fix warning

symbole * ts;
instruction * ti;
%}

%union {int nb; char varchar[16];}
%token tEGAL tPO tPF tAO tAF tSOUS tADD tDIV tMUL tERR tPRINTF tMAIN tINT tSTR tCONST tVIRG tPVIRG tIF tWHILE tFOR tINF tSUP tINFEG tSUPEG tEGALEGAL
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
    ti[jmp_index].arg2 = get_taille_ti()-1;
    
    // --------------- TODO ---------------
    // Garder la condition ou pas ? Comment gérer le fait de savoir si on est
    // dans une chaîne de conditions ?
    // if (machin) {truc;} bonjour(); else {autre_truc;} <--- erreur !
    depiler_symbole(ts); // on supprime la variable temporaire qui correspond à la condition
    
    };

Declaration: VarType tID {
  char vartype[5];
  sprintf(vartype, "%d", $1);
  ajouter_symbole(ts, $2, vartype, 1);
};

RightOperand: FunCall ;
RightOperand: Operations;
RightOperand: tNB {
    ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "tmp", "tmp", 0), $1, 0);

};
RightOperand: tID {
    ajouter_instruction(ti, "AFC", ajouter_symbole(ts, "tmp", "tmp", 0), get_addr(ts, $1), 0);
};


Operations: RightOperand tSOUS RightOperand {
    int arg3 = depiler_addr(ts);
    int arg2 = depiler_addr(ts);
    int arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "SOU", arg1, arg2, arg3);

};
Operations: RightOperand tADD RightOperand {
    int arg3 = depiler_addr(ts);
    int arg2 = depiler_addr(ts);
    int arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "ADD", arg1, arg2, arg3);

};
Operations: RightOperand tDIV RightOperand {
    int arg3 = depiler_addr(ts);
    int arg2 = depiler_addr(ts);
    int arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "DIV", arg1, arg2, arg3);

};
Operations: RightOperand tMUL RightOperand {
    int arg3 = depiler_addr(ts);
    int arg2 = depiler_addr(ts);
    int arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "MUL", arg1, arg2, arg3);

};

Affectation : tID tEGAL RightOperand {
    ajouter_instruction(ti, "COP", get_addr(ts, $1), depiler_addr(ts), 0);
};

Condition: tIF ArgCondition | tWHILE ArgCondition | tFOR ForCondition ;
ArgCondition: tPO Bool tPF;
ForCondition: tPO DeclarationIndice tPVIRG Bool tPVIRG Affectation tPF;
DeclarationIndice: Affectation | tID;

Bool: Comparaison | tID;
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
    int op1 = depiler_addr(ts);
    int op2 = depiler_addr(ts);
    
    int result_egal = ajouter_symbole(ts, "tmp", "result_condition", 0);
    ajouter_instruction(ti, "EQU", result_egal, op1, op2);
    
    // taille_ti correspond à l'index du Jump du if dans la table d'instruction
    // ajouter_symbole incrémente taille_ti et l'indice correspond à taille_ti-1
    ajouter_symbole(ts, "next", "tmp_if", get_taille_ti());
    
    // on stocke l'emplacement dans ti de cette instruction pour pouvoir
    // modifier l'adresse de ligne de retour -> dans le symbole tmp_if
    ajouter_instruction(ti, "JMF", result_egal, -1, 0);
    
};


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
    ajouter_instruction(ti, "OR", result_or, result_egal, result_inf); // le nom c'est OR ou OU ?
    
    
    int next = ajouter_symbole(ts, "next", "tmp_if", 0);

    ajouter_instruction(ti, "JMF", result_or, next, 0);
};

// pk il reste des tmp à la fin ?
// traduire les comparaisons

%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Compilateur\n");
  yydebug=1;
  ts = init_ts();
  ti = init_ti();
  yyparse();
  print_ts(ts);
  print_ti(ti);
  return 0;
}
