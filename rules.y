%{
#include <stdlib.h>
#include <stdio.h>
int varchar[16];
void yyerror(char *s);

%}

%union {int nb; char varchar[16];}
%token tEGAL tPO tPF tAO tAF tSOUS tADD tDIV tMUL tERR tPRINTF tMAIN tINT tSTR tCONST tVIRG tPVIRG
%token <nb> tNB
%token <varchar> tID
%start Programme

%left tADD tSOUS
%left tMUL tDIV

%%

Programme: Funs;

Funs: Fun | Fun Funs;
Fun: FunType FunName tPO DeclArgs tPF tAO Body tAF;
FunCall: FunName tPO CallArgs tPF tPVIRG;

DeclArgs: VarType tID DeclArgNext |;
DeclArgNext: tVIRG DeclArgs |;

CallArgs: RightOperand DeclArgNext |;
CallArgNext: tVIRG DeclArgs |;

PreType: tCONST |;
Type: tINT | tSTR;
FunType: Type;
VarType: PreType Type;

FunName: tMAIN | tID; 

Body: | Lignes;
Lignes: Ligne tVIRG Lignes;
Ligne: FunCall | VarType tID | Operations;

RightOperand: tNB | tID | Operations | FunCall | Affectations;
Operateur: tSOUS | tADD | tDIV | tMUL;

Operations: RightOperand Operateur RightOperand;
Affectations: tID tEGAL RightOperand;

%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Compilateur\n");
  yydebug=1;
  yyparse();
  return 0;
}
