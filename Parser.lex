%{
#include "Parser.h"
%}

DecimalDigit [0-9]
DecimalDigits [0-9]+
NonZeroDigit [1-9]
OctalDigit [0-7]
HexDigit [0-9a-fA-F]
Identifier		[$_a-zA-Z]+
ExponentIndicator [eE]
SignedInteger [+-]?[0-9]+
DecimalIntegerLiteral [0]|({NonZeroDigit}{DecimalDigits}*)
ExponentPart {ExponentIndicator}{SignedInteger}
OctalIntegerLiteral [0]{OctalDigit}+
HexIntegerLiteral [0][xX]{HexDigit}+
DecimalLiteral ({DecimalIntegerLiteral}\.{DecimalDigits}*{ExponentPart}?)|(\.{DecimalDigits}{ExponentPart}?)|({DecimalIntegerLiteral}{ExponentPart}?)
LineContinuation \\(\r\n|\r|\n)
OctalEscapeSequence (?:[1-7][0-7]{0,2}|[0-7]{2,3})
HexEscapeSequence [x]{HexDigit}{2}
SingleEscapeCharacter [\'\"\\bfnrtv]
NonEscapeCharacter [^\'\"\\bfnrtv0-9xu]
CharacterEscapeSequence {SingleEscapeCharacter}|{NonEscapeCharacter}
EscapeSequence {CharacterEscapeSequence}|{OctalEscapeSequence}|{HexEscapeSequence}|{UnicodeEscapeSequence}
DoubleStringCharacter ([^\"\\\n\r]+)|(\\{EscapeSequence})|{LineContinuation}
SingleStringCharacter ([^\'\\\n\r]+)|(\\{EscapeSequence})|{LineContinuation}
StringLiteral (\"{DoubleStringCharacter}*\")|(\'{SingleStringCharacter}*\')


%%

\s+                                %{
                                        if (yytext.match(/\r|\n/)) {
                                            parser.newLine = true;
                                        }

                                        if (parser.restricted && parser.newLine) {
                                            this.unput(yytext);
                                            parser.restricted = false;
                                            return ";";
                                        }
                                   %}
"/*"(.|\r|\n)*?"*/"                %{
                                        if (yytext.match(/\r|\n/)) {
                                            parser.newLine = true;
                                        }

                                        if (parser.restricted && parser.newLine) {
                                            this.unput(yytext);
                                            parser.restricted = false;
                                            return ";";
                                        }
                                   %}
"//".*($|\r\n|\r|\n)               %{
                                        if (yytext.match(/\r|\n/)) {
                                            parser.newLine = true;
                                        }

                                        if (parser.restricted && parser.newLine) {
                                            this.unput(yytext);
                                            parser.restricted = false;
                                            return ";";
                                        }
                                   %}

{blanks}        { /* ignore */ }

{StringLiteral}                    return {STRING_LITERAL};
"break"                            return {BREAK};
"case"                             return {CASE};
"continue"                         return {CONTINUE};
"default"                          return {DEFAULT};
"do"                               return {DO};
"else"                             return {ELSE};
"finally"                          return {FINALLY};
"for"                              return {FOR};
"function"                         return {FUNCTION};
"if"                               return {IF};
"in"                               return {IN};
"instanceof"                       return {INSTANCEOF};
"new"                              return {NEW};
"return"                           return {RETURN};
"switch"                           return {SWITCH};
"this"                             return {THIS};
"throw"                            return {THROW};
"try"                              return {TRY};
"typeof"                           return {TYPEOF};
"var"                              return {VAR};
"void"                             return {VOID};
"while"                            return {WHILE};
"with"                             return {WITH};
"true"                             return {TRUE_STATEMENT};
"false"                            return {FALSE_STATEMENT};
"null"                             return {NULL_STATEMENT};
"class"                            return {CLASS};
"const"                            return {CONST};
"super"                            return {SUPER};
{Identifier}                       return {IDENTIFIER};
{DecimalLiteral}                   return {NUMERIC_LITERAL};
{HexIntegerLiteral}                return {NUMERIC_LITERAL};
{OctalIntegerLiteral}              return {NUMERIC_LITERAL};
"{"                                return {OPEN_BRACE};
"}"                                return {CLOSE_BRACE};
"("                                return {OPEN_ANGLE};
")"                                return {CLOSE_ANGLE};
"["                                return {OPEN_BRACKET};
"]"                                return {CLOSE_BRACKET};
"."                                return ".";
";"                                return {END_STATEMENT};
","                                return {COMMA_SEP};
"?"                                return "?";
":"                                return ":";
"==="                              return "===";
"=="                               return "==";
"="                                return {ASSIGNMENT};
"!=="                              return "!==";
"!="                               return "!=";
"!"                                return "!";
"<="                               return "<=";
"<"                                return "<";
">"                                return ">";
"+"                                return "+";
"-"                                return "-";
"*"                                return "*";
"/"                                return "/";
"&&"                               return "&&";
"&"                                return "&";
"||"                               return "||";
"|"                                return "|";
"^"                                return "^";
"~"                                return "~";
<<EOF>>                            return "EOF";
.                                  return "ERROR";

%%
