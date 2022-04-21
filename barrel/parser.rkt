#lang brag
words : (word | const | id | quote~)*
quote~ : "[" (const | id)* "]"
word : "{" (const | id)* "}" 
const : CONST
id : ID