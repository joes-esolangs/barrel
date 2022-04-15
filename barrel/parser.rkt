#lang brag
words : (word | const | id)*
main : MAIN (const | id)+
word : "{" (const | id)+ "}" NAME
const : CONST
id : ID