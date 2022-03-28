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
%token tEGAL tPO tPF tAO tAF tSOUS tADD tDIV tMUL tERR tPRINTF tMAIN tINT tSTR tCONST tVIRG tPVIRG tIF tWHILE tFOR tINF tSUP tINFEG tSUPEG
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
    ajouter_instruction(ti, "SUB", arg1, arg2, arg3);

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
Comparateur: tINF | tSUP | tINFEG | tSUPEG;
Comparaison: RightOperand Comparateur RightOperand;

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
