#lang brag
words : word+ main
main : MAIN (const | id)+
word : NAME (const | id)+
const : CONST
id : ID