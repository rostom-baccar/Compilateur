%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
//int lineno = 1;
%}

%option noyywrap
%option nounput noinput
%option yylineno

%%


[ \t\n]+  {}

\/\/.*\n?   {} // pour ce type de commentaire


\/\*([^\*]|\*[^\/])*\*\/ {} /* Pour ce type de commentaire  avant : \/\*(.|[\r\n])*?\*\/  {}*/



","  {return tVIRG;}
[0-9]+(e[0-9]+)? {
	  yylval.nb = (int) strtold(yytext, NULL);
	  return tNB;
	}
"const" {return tCONST;}
"int"   {return tINT;}
"string" {return tSTR;}
"main"  {return tMAIN;}
"printf" {return tPRINTF;}
"if"    {return tIF;}
"while"    {return tWHILE;}
"else if"    {return tELIF;}
"else"    {return tELSE;}
"for"    {return tFOR;}
"{"     {return tAO;}
"}"     {return tAF;}
"("     {return tPO;}
")"     {return tPF;}
";" {return tPVIRG;}
"=="	{return tEGALEGAL;}
"="	{return tEGAL;}
"-"	{return tSOUS;}
"+"	{return tADD;}
"*"	{return tMUL;}
"/"	{return tDIV;}
"<"	{return tINF;}
">"	{return tSUP;}
"&&" {return tAND;}
"||" {return tOR;}
"<="	{return tINFEG;}
">="	{return tSUPEG;}
[a-zA-Z]+[a-zA-Z0-9|_]* {
	  strcpy(yylval.varchar, yytext);
	  return tID;
	}

. {return tERR;}

%%
/*
int main()
{   
    // The function that starts the analysis
    yylex();
  
    return 0;
}
*/
