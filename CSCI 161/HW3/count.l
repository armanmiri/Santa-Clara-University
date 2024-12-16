%{
#include <stdio.h>
#include <string.h>
int int_count = 0, float_count = 0;
%}

digit    [0-9]
integer  [-+]?{digit}+
float    [-+]?{digit}*[.]{digit}+

%%

{float}    { float_count++; }
{integer}  { int_count++; }
\n         { }
.          { }

%%

int main() {
    yylex();  
    printf("%d %d\n", int_count, float_count);  
    return 0;
}

int yywrap() { 
    return 1; 
}
