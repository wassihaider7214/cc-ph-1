%{
#include <stdio.h>

FILE *tokens_file;
FILE *error_file;
int line_num = 1;

void add_token(const char *type, const char *value) {
    fprintf(tokens_file, "Line %d: %s -> %s\n", line_num, type, value);
}

void add_error(const char *value) {
    fprintf(error_file, "Line %d: ERROR - Invalid token '%s'\n", line_num, value);
}
%}

%option noyywrap

DIGIT      [0-9]
LETTER     [a-zA-Z]
ID         {LETTER}({LETTER}|{DIGIT}|_)*
INT        {DIGIT}+
FLOAT      {DIGIT}+"."{DIGIT}+
WS         [ \t]+
NEWLINE    \n
QUOTE      ['\"]



%%

"jaytay"    { add_token("IF", yytext); }
"fair"      { add_token("ELSE", yytext); }
"jadtak"    { add_token("WHILE", yytext); }
"harik"     { add_token("FOR", yytext); }
"banao"     { add_token("FUNCTION", yytext); }
"vapis"     { add_token("RETURN", yytext); }
"sach"      { add_token("TRUE", yytext); }
"jhoot"     { add_token("FALSE", yytext); }
"adad"      { add_token("TYPE_INT", yytext); }
"harf"      { add_token("TYPE_CHAR", yytext); }
"likho"     { add_token("COUT", yytext); }
"lo"        { add_token("CIN", yytext); }
"ashariya"  { add_token("FLOAT", yytext); }
"roko"      { add_token("BREAK", yytext); }
"nahito"    { add_token("ELSE IF", yytext); }

"=="|">="|"<="|"<"|">"|"!="   { add_token("RELOP", yytext); }
"="         { add_token("ASSIGN", yytext); }
";"         { add_token("SEMICOLON", yytext); }
","         { add_token("COMMA", yytext); }
"("         { add_token("LPAREN", yytext); }
")"         { add_token("RPAREN", yytext); }
"{"         { add_token("LBRACE", yytext); }
"}"         { add_token("RBRACE", yytext); }
"++"        { add_token("INCREMENT", yytext); }
"--"        { add_token("DECREMENT", yytext); }


"+"         { add_token("PLUS", yytext); }
"-"         { add_token("MINUS", yytext); }
"*"         { add_token("MULT", yytext); }
"/"         { add_token("DIV", yytext); }
"%"         { add_token("MOD", yytext); }

{FLOAT}     { add_token("FLOAT_LITERAL", yytext); }
{INT}       { add_token("INT_LITERAL", yytext); }
{ID}        { add_token("IDENTIFIER", yytext); }

{WS}        /* skip */
{NEWLINE}   { line_num++; }

{QUOTE}([^\"\']|\\{QUOTE})*{QUOTE} { add_token("STRING_LITERAL", yytext); }
\'.\'           { add_token("CHAR_LITERAL", yytext); }

"//".*       /* skip single-line comment */
"/*"([^*]|"*"[^/])*"*/"   /* skip multi-line comment */

.           { add_error(yytext); }

%%

int main(int argc, char *argv[]) {

    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Cannot open file %s\n", argv[1]);
        return 1;
    }

   tokens_file = fopen("tokens.txt", "w");
    error_file = fopen("error_log.txt", "w");

   if (!tokens_file || !error_file) {
    printf("Error: Cannot open output files\n");
    return 1;
         }


    fprintf(tokens_file, "=== TOKENS ===\n");
    fprintf(error_file, "=== ERRORS ===\n");

    yylex();

    fclose(tokens_file);
    fclose(error_file);

    printf("Done! Tokens → tokens.txt | Errors → error_log.txt\n");

    return 0;
}
