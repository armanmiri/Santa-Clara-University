%{
#include <stdio.h>
#define YYSTYPE long
extern int yylex(void);
extern int yyerror(char *);
%}

%token I

%%

input:
    E '\n' { printf("Result: %ld\n", $$); return 0;};

E:
    I              { $$ = $1; }
  | E E '+' { $$ = $1 + $2; }
  | E E '-' { $$ = $1 - $2; }
  | E E '*' { $$ = $1 * $2; }
  | E E '/' { $$ = $1 / $2; }
  

%%

int yyerror(char *s) {
  printf(stderr, "%s\n", s);
  return 0;
}

int main() {
  printf("Enter a postfix expression: ");
  yyparse();
  return 0;
}
