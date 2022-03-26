#lang brag
brl-program : (int | string | id)+
brl-expr : int | string | id
int : ["-"] INT
string : STR
id : ID