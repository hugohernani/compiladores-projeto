%{
#include <stdio.h>
%}

// Symbols.
%union
{
	char	*sval;
};

// Tokens que vierem do lexer serão reconhecidos aqui

%token <sval> IDENTIFIER

%start function
%%

// As funções serão declarados aqui

%%

int yyerror(char *s) {
  printf("yyerror : %s\n",s);
}

int main(void) {
  yyparse();
}
