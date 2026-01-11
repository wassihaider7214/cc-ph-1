%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
extern int line_no;
extern char *yytext;
void yyerror(const char *s);


int error_count = 0;
int last_error_line = -1;


void show_error(const char *type, const char *msg) {
    error_count++;
    printf("\n=== ERROR in %d ===\n", error_count);
    printf("Line: %d\n", line_no);
    printf("Type: %s\n", type);
    printf("Message: %s\n", msg);
    last_error_line = line_no;
}
%}

%token JAYTAY FAIR NAHITO JADTAK HARIK
%token BANOA VAPIS
%token SACH JHOT
%token ADAD ASHARIYA HARF
%token LIKHO LO ROKO
%token ID NUMBER
%token ASSIGN SEMI COMMA
%token LPAREN RPAREN LBRACE RBRACE
%token PLUS MINUS MUL DIV
%token LT GT EQ

%nonassoc LOWER_THAN_ELSE
%nonassoc FAIR NAHITO

%%

program
    : stmt_list
      {
        printf(error_count == 0
            ? "\n Syntax analysis successful\n"
            : "\n Syntax analysis finished with errors\n");
      }
    ;

stmt_list
    : stmt_list stmt
    | stmt
    | error { yyerrok; }
    ;

stmt
    : declaration
    | assignment
    | if_stmt
    | while_stmt
    | for_stmt
    | io_stmt
    | break_stmt
    | block
    ;

declaration
    : ADAD ID SEMI
    | ASHARIYA ID SEMI
    | HARF ID SEMI
    ;

assignment
    : ID ASSIGN expr SEMI
    ;

if_stmt
    : JAYTAY LPAREN condition RPAREN stmt %prec LOWER_THAN_ELSE
    | JAYTAY LPAREN condition RPAREN stmt FAIR stmt
    | JAYTAY LPAREN condition RPAREN stmt NAHITO LPAREN condition RPAREN stmt %prec LOWER_THAN_ELSE
    | JAYTAY LPAREN condition RPAREN stmt NAHITO LPAREN condition RPAREN stmt FAIR stmt
    ;

while_stmt
    : JADTAK LPAREN condition RPAREN stmt
    ;

for_stmt
    : HARIK LPAREN for_init SEMI condition SEMI for_update RPAREN stmt
    ;

for_init
    : ID ASSIGN expr
    ;

for_update
    : ID ASSIGN expr
    ;

io_stmt
    : LIKHO expr SEMI
    | LO ID SEMI
    ;

break_stmt
    : ROKO SEMI
    ;

block
    : LBRACE stmt_list RBRACE
    | LBRACE RBRACE
    ;

expr
    : expr PLUS term
    | expr MINUS term
    | term
    ;

term
    : term MUL factor
    | term DIV factor
    | factor
    ;

factor
    : NUMBER
    | ID
    | LPAREN expr RPAREN
    ;

condition
    : expr LT expr
    | expr GT expr
    | expr EQ expr
    | SACH
    | JHOT
    ;

%%

void yyerror(const char *s)
{
    if (line_no == last_error_line) return;

    if (strstr(s, "SEMI"))
        show_error("Missing Token", "Semicolon (;) expected");
    else if (strstr(s, "RPAREN"))
        show_error("Missing Token", "Closing parenthesis ')' expected");
    else if (strstr(s, "RBRACE"))
        show_error("Missing Token", "Closing brace '}' expected");
    else
        show_error("Syntax Error", yytext);
}

int main()
{
    printf("===== CUSTOM LANGUAGE PARSER =====\n\n");

    yyparse();

    printf("\nTotal Errors: %d\n", error_count);
    printf("Result: %s\n", error_count == 0 ? "PASS" : "FAIL");

    return error_count ? 1 : 0;
}
