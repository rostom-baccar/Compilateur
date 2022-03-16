%{
#include <stdlib.h>
#include <stdio.h>
int string[16]; //Taille max du nom de variable
void yyerror(char *s);

%}

%union {int nb; char string[16];} //associer une étiquette à chaque entier
%token 
tMain tConst tPrint
tIF tWhile tElse
tAO tAF tPO tPF tV tPV
tEqual
tVoid 
tInt tString
tSUB tADD tMUL tDIV
tINF tSUP

%token <nb> tNB //Etiquette entier
%token <string> tID //Etiquette nom variable/fonction
%start Program

%left tADD tSUB //Priorité à gauche
%left tMUL tDIV //Priorité à gauche

%%

Program: Functions;

Functions: Function | Function Functions;
DecArgs: Type tID NextDecArg |;
NextDecArg: tV DecArgs |;
Function: FunType FunName tPO DecArgs tPF tAO Body tAF;
FunCall: FunName tPO CallArgs tPF ;

FunType: tVoid | Type;
FunName: tMain | tID; 

Type0: tConst |;
Type: tInt | tString;



CallArgs: Operand CallArgNext |;
CallArgNext: tV CallArgs |;

Body: Instructions;
Instructions: Instruction Instructions |;
Instruction: FunCall tPV | VarDeclaration tPV | VarAssign tPV | Condition tAO Body tAF;

VarDeclaration : Type0 Type tID ;

Operand:  FunCall | Operations | tNB | tID;
Operator: tSUB | tADD | tDIV | tMUL;

Operations: Operand Operator Operand;
VarAssign : tID tEqual Operand;

Condition: tIF ArgCondition | tWhile ArgCondition;
ArgCondition: tPO BoolExpression tPF;

BoolExpression: Comparaison | tID;
Comparator: tINF | tSUP;
Comparaison: Operand Comparator Operand;

%%
void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Compilateur\n");
  yydebug=1;
  yyparse();
  return 0;
}
