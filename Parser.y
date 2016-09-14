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
%token GREATER_EQUAL
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
	ENDBLOCK CLOSE_ANGLE END_STATEMENT { printf("\nFim do código.\n"); }
	;

inicio:
	/* empty */
	| declaracao_variaveis
	| funcao
	| condicao
	;
	
condicao:
	IF OPEN_ANGLE IDENTIFIER token_comparador NUMERIC_LITERAL CLOSE_ANGLE BLOCK { printf("\tInicio de condição"); }
	inicio
	ENDBLOCK { printf("\tFim do IF."); }
	ELSE BLOCK
	inicio
	ENDBLOCK { printf("\tFim do ELSE."); }
	;
	
token_comparador:
	LESS
	| LESS_EQUAL
	| GREATER
	| GREATER_EQUAL
	| EQ_VAL
	| DIFF_VAL
	;

declaracao_variaveis:
	declaracao_global_de_variavel
	 | declaracao_local_de_variavel
	;

declaracao_global_de_variavel:
	VAR IDENTIFIER ASSIGNMENT inicio_expressao
	 | VAR IDENTIFIER ASSIGNMENT funcao_instanciamento
	 | VAR IDENTIFIER ASSIGNMENT IDENTIFIER END_STATEMENT { printf("\n\t\tAtribuição de Variável\n"); } 
	;
	
declaracao_local_de_variavel:
	IDENTIFIER ASSIGNMENT inicio_expressao
	 | IDENTIFIER ASSIGNMENT funcao_instanciamento
	;

inicio_expressao:
	tipo END_STATEMENT { printf(" - Variavel declarada\n"); }
	inicio
	;

tipo:
	NUMERIC_LITERAL	{ printf("\n\tInteiro  "); }
	 | STRING_LITERAL { printf("\n\tString  "); } 
	;

funcao:
	funcao_declaracao
	| funcao_nao_anonima
	;

// Exemplo: Student(name, age) { TODO Precisa adicionar o recebimento de mais que um identificador
funcao_declaracao:
	FUNCTION IDENTIFIER OPEN_ANGLE IDENTIFIER COMMA_SEP IDENTIFIER CLOSE_ANGLE BLOCK { printf("Funcao anonima criada: %s\n", $2); }
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
