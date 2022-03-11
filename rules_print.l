%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%

[ \t]+  {printf(" ");}
","  {printf(",");}
[\n] {printf("\n");}
[0-9]+.[0-9]+ {printf("nb");}
"const" {printf("const int");}
"int"   {printf("int");}
"main"  {printf("main");}
"printf" {printf("printf");}
"{"     {printf("{");}
"}"     {printf("}");}
"("     {printf("(");}
")"     {printf(")");}
";" {printf(";");}
"="	{printf("=");}
"-"	{printf("-");}
"+"	{printf("+");}
"*"	{printf("*");}
"/"	{printf("/");}
[a-zA-Z]+[a-zA-Z0-9|_]* {printf("variable");}

. {printf("?");}

%%
int main()
{   
    // The function that starts the analysis
    yylex();
  
    return 0;
}
