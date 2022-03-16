%{
#include <stdlib.h>
#include <stdio.h>
int varchar[16];
void yyerror(char *s);

%}

%union {int nb; char varchar[16];}
%token tEGAL tPO tPF tAO tAF tSOUS tADD tDIV tMUL tERR tPRINTF tMAIN tINT tSTR tCONST tVIRG tPVIRG tIF tWHILE tFOR tINF tSUP tINFEG tSUPEG
%token <nb> tNB
%token <varchar> tID
%start Programme

%left tADD tSOUS
%left tMUL tDIV

%%

Programme: Funs;

Funs: Fun | Fun Funs;
Fun: FunType FunName tPO DeclArgs tPF tAO Body tAF;
FunCall: FunName tPO CallArgs tPF ;

DeclArgs: VarType tID DeclArgNext |;
DeclArgNext: tVIRG DeclArgs |;

CallArgs: RightOperand CallArgNext |;
CallArgNext: tVIRG CallArgs |;

PreType: tCONST |;
Type: tINT | tSTR;
FunType: Type;
VarType: PreType Type;

FunName: tMAIN | tID; 

Body: Lignes;
Lignes: Ligne Lignes |;
Ligne: FunCall tPVIRG | Declaration tPVIRG | Affectation tPVIRG | Condition tAO Body tAF;

Declaration : VarType tID ;

RightOperand:  FunCall | Operations | tNB | tID;
Operateur: tSOUS | tADD | tDIV | tMUL;

Operations: RightOperand Operateur RightOperand;
Affectation : tID tEGAL RightOperand;

Condition: tIF ArgCondition | tWHILE ArgCondition | tFOR ForCondition;
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
  yyparse();
  return 0;
}
