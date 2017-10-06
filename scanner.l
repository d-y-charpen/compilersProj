%{
/**********************************************************************
 *
 *  Daniel Charpentier, 1000354859
 *
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/


#include "common.h"
#include "parser.tab.h"
#include "string.h"


#define YY_USER_INIT { yyin = inputFile; }
#define	yyinput      input
#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }

int CheckInt(void);
int yyline = 1;

%}
%option noyywrap

WS          [ \t]
DIGIT       [0-9]
LETTER      [a-zA-Z]

integer     [1-9]{DIGIT}*
float       {DIGIT}*\.{DIGIT}*
ident       {LETTER}({LETTER}|{DIGIT}|_)*

type        [bool|int|float]
vectype     [b|i]?vec[2-4]

funcName    [dp3|lit|rsq]
varName     {ident}

%%

"{"         {printf("found {\n"); return TOK_LB;}
"}"         {printf("found }\n"); return TOK_RB;}
"("         {printf("found (\n"); return TOK_LP;}
")"         {printf("found )\n"); return TOK_RP;}
"["         {printf("found [\n"); return TOK_LSQ;}
"]"         {printf("found ]\n"); return TOK_RSQ;}
";"         {printf("found ;\n"); return TOK_SC;}
"="         {printf("found =\n"); return TOK_ASS;}
"-"         {printf("found -\n"); return TOK_MIN;}
"+"         {printf("found +\n"); return TOK_PLS;}
"*"         {printf("found *\n"); return TOK_MULT;}
"/"         {printf("found /\n"); return TOK_DIV;}
"^"         {printf("found ^\n"); return TOK_POW;}
"true"      {printf("found boolTrue\n"); return TOK_TRU;}
"false"     {printf("found boolFalse\n"); return TOK_FLS;}
"const"     {printf("found const\n"); return TOK_CNST;}
"if"        {printf("found if\n"); return TOK_IF;}
"while"     {printf("found while\n"); return TOK_WHILE;}
"!"         {printf("found !\n"); return TOK_NOT;}
"&&"        {printf("found &&\n"); return TOK_AND;}
"||"        {printf("found ||\n"); return TOK_OR;}
"=="        {printf("found ==\n"); return TOK_EQ;}
"!="        {printf("found !=\n"); return TOK_NEQ;}
"<"         {printf("found <\n"); return TOK_LES;}
"<="        {printf("found <=\n"); return TOK_LEQ;}
">"         {printf("found >\n"); return TOK_MOR;}
">="        {printf("found >=\n"); return TOK_MEQ;}
","         {printf("found ,\n"); return TOK_COMM;}

{type}      {printf("found type %s\n", yytext); return TOK_TYPE;}
{vectype}   {printf("found vector %s\n", yytext); return TOK_VEC;}
{funcName}  {printf("found function name %s\n", yytext); return TOK_FNC;}

{integer}   {printf("found integer %s\n", yytext); return TOK_INT;}
{float}     {printf("found float %s\n", yytext); return TOK_FLT;}
{varName}   {printf("found variable name %s\n", yytext); return TOK_VAR;}



"/*"        {
              int c1      = 0;
              int c2      = yyinput();
              int curline = yyline;
              for(;;) {
                if (c2 == EOF) {
                  fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: Unmatched /*\n", curline);
                  errorOccurred = TRUE;
                  yyterminate();
                }
                if (c1 == '*' && c2 == '/')
                  break;
                c1 = c2;
                c2 = yyinput();
                if (c1 == '\n' && c2 != EOF)
                  yyline++;
              }
            }



.           { yERROR("Unknown token"); }

%%
