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
Ligne: Condition tAO {inc_depth();} Body tAF {supprimer_symbole(ts);dec_depth();};

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
Comparaison: RightOperand tEGALEGAL RightOperand {
    int arg2 = get_addr(ts, $1);
    int arg3 = get_addr(ts, $3);
    int arg1 = ajouter_symbole(ts, "tmp", "tmp", 0);
    ajouter_instruction(ti, "EQU", arg1, arg2, arg3);
    int arg4 = ajouter_symbole(ts, "tmp_if", "tmp_if", 0);
    // mettre à jour dans le else
    // Si la condition n'est pas vérifiée, on jump vers le prochain else
    // L'adresse du prochain else est contenue dans une variable temporaire qui
    // est la dernière variable tmp_if ajoutée à cette profondeur
    ajouter_instruction(ti, "JMF", arg1, arg4, 0);
};


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
