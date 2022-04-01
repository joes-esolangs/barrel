#lang brag
;brl-program : word+
word : NAME (const | id)+
main : MAIN (const | id)+
const : CONST
id : ID