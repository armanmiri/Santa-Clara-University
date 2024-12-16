%option noyywrap

%{
#include <stdio.h>
#include "y.tab.h"
#define YYSTYPE long
%}

%%

[-+]?[0-9]+ { yylval=atol(yytext); return I; } 
[-+/*\n] { return yytext[0];}
[ \t] ;


%%
