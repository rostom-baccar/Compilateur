/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tEGAL = 258,
    tPO = 259,
    tPF = 260,
    tAO = 261,
    tAF = 262,
    tSOUS = 263,
    tADD = 264,
    tDIV = 265,
    tMUL = 266,
    tERR = 267,
    tPRINTF = 268,
    tMAIN = 269,
    tINT = 270,
    tSTR = 271,
    tCONST = 272,
    tVIRG = 273,
    tPVIRG = 274,
    tIF = 275,
    tWHILE = 276,
    tFOR = 277,
    tINF = 278,
    tSUP = 279,
    tINFEG = 280,
    tSUPEG = 281,
    tNB = 282,
    tID = 283
  };
#endif
/* Tokens.  */
#define tEGAL 258
#define tPO 259
#define tPF 260
#define tAO 261
#define tAF 262
#define tSOUS 263
#define tADD 264
#define tDIV 265
#define tMUL 266
#define tERR 267
#define tPRINTF 268
#define tMAIN 269
#define tINT 270
#define tSTR 271
#define tCONST 272
#define tVIRG 273
#define tPVIRG 274
#define tIF 275
#define tWHILE 276
#define tFOR 277
#define tINF 278
#define tSUP 279
#define tINFEG 280
#define tSUPEG 281
#define tNB 282
#define tID 283

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 13 "rules.y"
int nb; char varchar[16];

#line 116 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
