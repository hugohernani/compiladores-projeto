%{
#include <stdio.h>
int yylex();
int yyerror();
%}

// Symbols.
%union
{
	char	*sval;
};

// Tokens que vierem do lexer são reconhecidos aqui
%token <sval> IDENTIFIER
%token OPEN_ANGLE
%token CLOSE_ANGLE
%token FUNCTION
%token STRING_LITERAL
%token VAR
%token NUMERIC_LITERAL
%token END_STATEMENT
%token COMMA_SEP
%token ASSIGNMENT
%token NEW
%token BREAK
%token CASE
%token CONTINUE
%token DEFAULT
%token DO
%token ELSE
%token FINALLY
%token FOR
%token IF
%token IN
%token INSTANCEOF
%token RETURN
%token SWITCH
%token THIS
%token THROW
%token TRY
%token TYPEOF
%token VOID
%token WHILE
%token WITH
%token TRUE_STATEMENT
%token FALSE_STATEMENT
%token NULL_STATEMENT
%token CLASS
%token CONST
%token SUPER
%token OPEN_BRACE
%token CLOSE_BRACE
%token OPEN_BRACKET
%token CLOSE_BRACKET
%token PERIOD
%token QUESTION_MARK
%token COLON
%token EQ_VAL_OR_TYPE
%token EQ_VAL
%token DIFF_VAL_OR_TYPE
%token DIFF_VAL
%token NOT
%token LESS_EQUAL
%token LESS
%token GREATER
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token AND
%token B_AND
%token OR
%token B_OR
%token B_XOR
%token B_NOT

%token BLOCK
%token ENDBLOCK


%start algorithm
%%

algorithm:
	OPEN_ANGLE FUNCTION OPEN_ANGLE CLOSE_ANGLE BLOCK { printf("Iniciando o código. \n"); }
	inicio
	ENDBLOCK { printf("\nFim do código"); }
	;

inicio:
	/* empty */
	| declaracao_variaveis
	| funcao
	;

declaracao_variaveis:
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

%%

int yyerror(char *s) {
  printf("yyerror : %s\n",s);
}

int main(void) {
  yyparse();
}
