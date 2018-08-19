%{
#include "y.tab.h"
 #include<stdio.h>

%}

%%
"$".*   {return COMMENTS;}
"\""(.*(\n)*)*"\"" {return STRING;}
"\'"."\'" {return CHARACTER;}
"import" {return IMPORT;}
"loop" {return LOOP;}
"break" {return BREAK;}
"breakAll" {return BREAK_ALL;}
"continue" {return CONTINUE;}
"if" {return IF;}
"else" {return ELSE;}
"else if" {return ELSE_IF;}
"case" {return CASE;}
"switch" {return SWITCH;}
"default" { return DEFAULT ;}
"True" {return TRUE;}
"False" {return FALSE;}
"return" {return RETURN;}
[a-zA-Z]+ {return LETTER;}
[0-9] {return DIGIT;}
. ;
%%

int yywrap()
{
	return 1;
}

int main(int argc , char **argv)
{
    yyin = fopen(argv[1],"r");

    if(!yyparse())
    {
    printf("parsing completed");
    }
    else
    printf("parsing failed");

    fclose(yyin);
    return 0;
}