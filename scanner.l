%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

FILE *tokens_file;
FILE *error_log_file;

void write_token(const char* type, const char* value);
void write_error(const char* message, int line);
int line_num = 1;
%}

%option noyywrap

DELIM       [ \t]
WS          {DELIM}+
NEWLINE     \n
DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT}|_)*
NUMBER      {DIGIT}+(\.{DIGIT}+)?([eE][-+]?{DIGIT}+)?
INTEGER     {DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
RELOP       [<>]=?|==|!=
ASSIGN      =
SEMICOLON   ;
COMMA       ,
LPAREN      \(
RPAREN      \)
LBRACE      \{
RBRACE      \}
QUOTE       ['\"]
INCREMENT   \+\+
DECREMENT   --

%%

"jaytay"        { write_token("KEYWORD_IF", yytext); }
"fair"          { write_token("KEYWORD_ELSE", yytext); }
"jadtak"        { write_token("KEYWORD_WHILE", yytext); }
"harik"         { write_token("KEYWORD_FOR", yytext); }
"banoa"         { write_token("KEYWORD_FUNCTION", yytext); }
"vapis"         { write_token("KEYWORD_RETURN", yytext); }
"sach"          { write_token("KEYWORD_TRUE", yytext); }
"jhoot"         { write_token("KEYWORD_FALSE", yytext); }
"adad"          { write_token("TYPE_INTEGER", yytext); }
"ashariya"      { write_token("TYPE_FLOAT", yytext); }
"likho"         { write_token("KEYWORD_COUT", yytext); }
"lo"            { write_token("KEYWORD_CIN", yytext); }
"harf"          { write_token("TYPE_CHAR", yytext); }
"nahito"        { write_token("KEYWORD_ELSE_IF", yytext); }
"roko"          { write_token("KEYWORD_BREAK", yytext); }

{RELOP}         { write_token("RELATIONAL_OP", yytext); }
{ASSIGN}        { write_token("ASSIGNMENT_OP", yytext); }
{SEMICOLON}     { write_token("SEMICOLON", yytext); }
{COMMA}         { write_token("COMMA", yytext); }
{LPAREN}        { write_token("LEFT_PAREN", yytext); }
{RPAREN}        { write_token("RIGHT_PAREN", yytext); }
{LBRACE}        { write_token("LEFT_BRACE", yytext); }
{RBRACE}        { write_token("RIGHT_BRACE", yytext); }
{INCREMENT}     { write_token("INCREMENT_OP", yytext); }
{DECREMENT}     { write_token("DECREMENT_OP", yytext); }

"+"             { write_token("PLUS_OP", yytext); }
"-"             { write_token("MINUS_OP", yytext); }
"*"             { write_token("MULTIPLY_OP", yytext); }
"/"             { write_token("DIVIDE_OP", yytext); }
"%"             { write_token("MODULUS_OP", yytext); }

{INTEGER}       { write_token("INTEGER_LITERAL", yytext); }
{FLOAT}         { write_token("FLOAT_LITERAL", yytext); }
{ID}            { write_token("IDENTIFIER", yytext); }

{QUOTE}([^\"\']|\\{QUOTE})*{QUOTE} { write_token("STRING_LITERAL", yytext); }
\'.\'           { write_token("CHAR_LITERAL", yytext); }

{WS}            /* Skip whitespace */
{NEWLINE}       { line_num++; }

"//".*          /* Skip single-line comments */
"/*"([^*]|"*"[^/])*"*/" /* Skip multi-line comments */

.               { 
                  char error_msg[100];
                  snprintf(error_msg, sizeof(error_msg), "Invalid character: '%s'", yytext);
                  write_error(error_msg, line_num);
                }

%%

void write_token(const char* type, const char* value) {
    fprintf(tokens_file, "Line %d: %s -> %s\n", line_num, type, value);
}

void write_error(const char* message, int line) {
    fprintf(error_log_file, "Line %d: ERROR - %s\n", line, message);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Error: Cannot open input file %s\n", argv[1]);
        return 1;
    }
    
    tokens_file = fopen("tokens.txt", "w");
    error_log_file = fopen("error_log.txt", "w");
    
    if (!tokens_file || !error_log_file) {
        printf("Error: Cannot open output files\n");
        return 1;
    }
    
    fprintf(tokens_file, "=== TOKENS FOUND ===\n");
    fprintf(error_log_file, "=== ERROR LOG ===\n");
    
    yylex();
    
    fclose(yyin);
    fclose(tokens_file);
    fclose(error_log_file);
    
    printf("Lexical analysis completed.\n");
    printf("Tokens saved to: tokens.txt\n");
    printf("Errors saved to: error_log.txt\n");
    
    return 0;
}