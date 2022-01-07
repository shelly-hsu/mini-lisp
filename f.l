%option noyywrap
%{
    #include <iostream>
    #include <string>
    #include <string.h>
    #include "y.tab.h"
    using namespace std;
%}

digit [0-9]
letter [a-z]
number 0|[1-9]{digit}*|-[1-9]{digit}*
id {letter}({letter}|{digit}|\-)*

%%
{number} {yylval.num = atoi(yytext); return NUMBER;}
(\#t) {yylval.boolVal = 1; return BOOL_VAL; }
(\#f) {yylval.boolVal = 0; return BOOL_VAL; }
"print-num" {return PRINT_NUM;}
"print-bool" {return PRINT_BOOL;}
[\+\-\*\/\(\)\>\<\=]  {return yytext[0];}
"mod" {return MOD;}
"and" {return AND;}
"or" {return OR;}
"not" {return NOT;}
"define" {return DEF;}
"lambda" {return FUN;}
"fun" {return FUN;}
"if" {return IF;}
{id} {  yylval.str = strdup(yytext);
        return ID;
    }
[\t\n\r ] {;}
. {cout << "Unexpected Character! " << yytext << "\n"; exit(1);}

%%