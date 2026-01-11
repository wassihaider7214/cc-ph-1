%{
#include "parser.tab.h"   
#include <stdio.h>
int line_no = 1;

%}

%option noyywrap

DIGIT      [0-9]
ID         [a-zA-Z_][a-zA-Z0-9_]*

%%
"jaytay"        { return JAYTAY; }
"fair"          { return FAIR; }
"nahito"        { return NAHITO; }
"jadtak"        { return JADTAK; }
"harik"         { return HARIK; }
"banoa"         { return BANOA; }
"vapis"         { return VAPIS; }

"sach"          { return SACH; }
"jhot"          { return JHOT; }

"adad"          { return ADAD; }
"ashariya"      { return ASHARIYA; }
"harf"          { return HARF; }

"likho"         { return LIKHO; }
"lo"            { return LO; }

"roko"          { return ROKO; }


"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }

"<"             { return LT; }
">"             { return GT; }
"=="            { return EQ; }
"="             { return ASSIGN; }



";"             { return SEMI; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }


{DIGIT}+        { return NUMBER; }


{ID}            { return ID; }


\n              { line_no++; }
[ \t\r]+        { /* ignore whitespace */ }

. {
    printf("Invalid token '%s' at line %d\n", yytext, line_no);
}

%%