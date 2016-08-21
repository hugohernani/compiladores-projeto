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
%token OPEN_ANGLE
%token CLOSE_ANGLE
%token FUNCTION
%token IDENTIFIER
%token STRING_LITERAL
%token FUNCTION
%token VAR
%token NUMERIC_LITERAL
%token END_STATEMENT
%token COMMA_SEP
%token ASSIGNMENT
%token NEW

%token BLOCK
%token ENDBLOCK


%start algorithm
%%

algorithm:
	OPEN_ANGLE FUNCTION OPEN_ANGLE CLOSE_ANGLE BLOCK { print("Iniciando o código. \n") }
	inicio
	ENDBLOCK { print("\nFim do código") }
	;
%%

inicio:
	/* empty */
	| inicio
	| declaracao_variaveis
	| funcao
	;

declaracao_variaves:
	declaracao_global_de_variavel
	 | declaracao_local_de_variavel
	;

declaracao_global_de_variavel:
	VAR IDENTIFIER ASSIGNMENT inicio_expressao
	 | VAR IDENTIFIER ASSIGNMENT funcao_instanciamento
	;
	
declaracao_local_de_variavel:
	IDENTIFIER ASSIGNMENT inicio_expressao
	 | IDENTIFIER ASSIGNMENT funcao_instanciamento
	;

// Acredito que falta algo aqui... O que será? :/
inicio_expressao:
	tipo END_STATEMENT
	;

tipo:
	NUMERIC_LITERAL	{ printf("\n\tInteiro"); }
	 | STRING_LITERAL { printf("\n\tString"); } 
	;

funcao:
	funcao_declaracao
	| funcao_nao_anonima
	;

// Exemplo: Student(name, age) { TODO Precisa adicionar o recebimento de mais que um identificador
funcao_declaracao:
	FUNCTION IDENTIFIER OPEN_ANGLE IDENTIFIER COMMA_SEP IDENTIFIER CLOSE_ANGLE BLOCK
	inicio
	ENDBLOCK
	;

funcao_nao_anonima:
	VAR IDENTIFIER ASSIGNMENT funcao_declaracao
	| IDENTIFIER ASSIGNMENT funcao_declaracao
	;
	
funcao_instanciamento:
	NEW chamada_funcao
	;

// Exemplo: Student(name, age); TODO Precisa adicionar o recebimento de mais que um identificador
chamada_funcao:
	IDENTIFIER OPEN_ANGLE IDENTIFIER COMMA_SEP IDENTIFIER CLOSE_ANGLE END_STATEMENT
	;

int yyerror(char *s) {
  printf("yyerror : %s\n",s);
}

int main(void) {
  yyparse();
}
