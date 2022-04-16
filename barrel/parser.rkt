#lang brag
words : (word | const | id)*
;word : "{" (const | id)+ "}" NAME
word : "{" (const | id)+ "}" 
const : CONST
id : ID