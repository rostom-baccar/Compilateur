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
    tMain = 258,
    tConst = 259,
    tPrint = 260,
    tIF = 261,
    tWhile = 262,
    tElse = 263,
    tAO = 264,
    tAF = 265,
    tPO = 266,
    tPF = 267,
    tV = 268,
    tPV = 269,
    tEqual = 270,
    tVoid = 271,
    tInt = 272,
    tString = 273,
    tSUB = 274,
    tADD = 275,
    tMUL = 276,
    tDIV = 277,
    tINF = 278,
    tSUP = 279,
    tNB = 280,
    tID = 281
  };
#endif
/* Tokens.  */
#define tMain 258
#define tConst 259
#define tPrint 260
#define tIF 261
#define tWhile 262
#define tElse 263
#define tAO 264
#define tAF 265
#define tPO 266
#define tPF 267
#define tV 268
#define tPV 269
#define tEqual 270
#define tVoid 271
#define tInt 272
#define tString 273
#define tSUB 274
#define tADD 275
#define tMUL 276
#define tDIV 277
#define tINF 278
#define tSUP 279
#define tNB 280
#define tID 281

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 9 "rules.y"
int nb; char string[16];

#line 112 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
