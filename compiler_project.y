%{

#include<stdio.h>
int yylex();
void yyerror(char *s);
int yylineno = 1;

%}

%token IMPORT COMMENTS STRING LETTER DIGIT CHARACTER LOOP BREAK CONTINUE BREAK_ALL IF ELSE ELSE_IF RETURN SWITCH CASE TRUE FALSE DEFAULT
%define api.pure full

%%

program  :   import_stmts statement 
	     | import_stmts func_def
	     | function_definition func_def
	     | function_definition statement
	     | statement {printf("program to statement\n");}
	     | statement func_def
	     |; 


import_stmts  :  import_stmts import_stmt 
		 | import_stmt ; 


import_stmt    :   IMPORT inbuilt_function;


inbuilt_function  :  inbuilt_function ',' identify 
		    | identify  ;
		    

statements  :  function_call {printf("stmts to func_call\n");}
	       | assignment_stmts {printf("stmts to assignment\n");}
	       | iterative_stmts 
               | control_stmts
	       | conditional_stmts
	       | return_stmts
	       | COMMENTS {printf("statements to COMMENTS\n");}
	       | switch_stmts ;


statement   :   statements statement
		  |statements ;
		 

function_call  :  identify '-' '>' actual {printf("func_call to iden & actual");} 
   
actual  :  actual ',' parameter 
	   | parameter {printf("actual to parameter");};

parameter  :  STRING {printf("parameter to string");} 
	      | num 
	      | identifier
	      | ;


identify   :   LETTER optionNew {printf("identify to letter OptionNew\n");} 

optionNew     :   DIGIT optionNew  |  LETTER optionNew |  '_' optionNew | LETTER {printf("optionNew toLETTER\n");}|  DIGIT |  '_' |
		  {printf("optionNew to null");};

identifier    :    identify {printf("identifier to identify\n");}  |  identify'[' index ']' ;


index   :   num 
	    | identifier 
	    | for_arithmetic ;
     

function_definition    :   identify '(' formal ')' '{' statements '}' ; 

func_def   :   function_definition func_def 
	       | function_definition ;

formal   :   formal ',' identify 
	     | identify 
	     | ;


assignment_stmts  :  identifier  ':'  value {printf("assignment to iden & value\n");}


value   :   arithmetic_exp 
	    | boolean_exp
	    | num {printf("value to num\n");}
	    | identifier
	    | CHARACTER {printf("value to CHARACRTER\n");}
	    | list
	    | STRING ;
                                          

iterative_stmts   :   LOOP '(' for_assignment ';' boolean_exp ';' for_assignment ')' '{' statements '}'
		      | LOOP '(' boolean_exp ')' '{' statements '}' ;

                                               
for_assignment   :   identifier ':'  for_value ;

for_value   :   num 
		| identifier 
		| CHARACTER
		| for_arithmetic ;

for_arithmetic   :   for_A 
		     | '(' for_arithmetic ')' ;


for_A    :   for_A '+' for_B 
	     | for_A '–' for_B 
	     | for_B 
	     | '(' for_A ')' ;


for_B   :   for_B '*' for_C 
	    | for_B '/' for_C 
	    | for_B '%' for_C 
	    | for_C 
	    | '(' for_B ')' ;


for_C   :   for_D '*' '*' for_C 
	    | for_D 
	    | '(' for_C ')' ;


for_D   :   num 
	    | identifier ;


control_stmts    :    BREAK 
		      | CONTINUE 
		      | BREAK_ALL ;


conditional_stmts   :   IF boolean_exp '{' statements '}' optional ;

optional   :   ELSE_IF boolean_exp  '{' statements '}' optional  optional2 
	       | optional2 
	       | ;
	       
optional2    :    ELSE '{' statements '}' 
		  | ;


boolean_exp   :   boolean_exp  '|' '|'  literal  
		  | literal ;
			    

literal   :   literal  '&' '&'  word  
	      | word ;


word   :   number '<' Z 
	   | number '<' '=' Z
	   | number '>' Z
	   | number '>' '=' Z 
	   | number '=' Z
	   | number '!' '=' Z
	   | TRUE
	   | FALSE
	   | '!' word ;

    
number   :   identifier 
	     | num 
	     | arithmetic_exp 
	     | CHARACTER ;

Z   :   identifier 
	| num 
	| arithmetic_exp 
	| CHARACTER ;

arithmetic_exp   :   arithmetic_exp '|' term 
		     | term 
		     | '(' arithmetic_exp ')' ; 


term    :   term '^' X 
	    | X 
	    | '(' term ')' ;


X    :    X '&' Y 
	  | Y 
	  | '(' X ')' ;


Y    :   Y '+' A 
	 | Y '-' A 
	 | A 
	 | '(' Y ')' ;


A   :   A '*' B 
	| A '/' B 
	| A '%' B 
	| B 
	| '(' A ')' ;


B    :    C '*' '*' B 
	  | C 
	  | '(' B ')' ;


C    :   '~' num 
	 | '(' C ')' 
	 | num 
	 | identifier ;
 

return_stmts    :   RETURN result  
		    | RETURN result ',' result ;


result   :   identifier 
	     | num 
	     | CHARACTER
	     | STRING ;

switch_stmts    :    SWITCH identifier '{' case_stmts '}' ;

case_stmts    :    CASE identifier '{' statements '}' case_stmts 
                   | DEFAULT  identifier '{' statements '}' ;

list   :   '[' phrase ']' ;


phrase    :   name ',' phrase  
	      | name 
	      | ;

name   :   num  
	   | CHARACTER  
	   |  identifier ;

num   :   digit1 {printf("num to digit\n");}
	  | digit1 '.' digit2 ;

digit1   :   DIGIT digit1
	     | DIGIT {printf("digit1 to DIGIT\n");}

digit2   :   DIGIT digit2 
	     |  DIGIT ;
	  

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}