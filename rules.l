%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%

[ \t\n]+  {}; //les espaces et les tabs sont ignorés
	
"main"  {return tMain;}	
"int"   {return tInt;}
"const" {return tConst;}
"printf" {return tPrint;}
"if"    {return tIF;}
"while"    {return tWhile;}
"else"    {return tElse;}
"void" {return tVoid;}
"string" {return tString;}

"{"     {return tAO;}
"}"     {return tAF;}
"("     {return tPO;}
")"     {return tPF;}
"," {return tV;}
";" {return tPV;}
"="	{return tEqual;}
"-"	{return tSUB;}
"+"	{return tADD;}
"*"	{return tMUL;}
"/"	{return tDIV;}
"<"	{return tINF;}
">"	{return tSUP;}

[A-ZA-Z]+[A-Za-z0-9|_]* {strcpy(yylval.string, yytext);return tID;}
[0-9]+(e[0-9]+)? {yylval.nb = (int) strtold(yytext, NULL);return tNB;}


%%

