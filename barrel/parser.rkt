#lang brag
words : (word | const | id | quote~)*
quote~ : "[" (const | id | "_")* "]"
word : "{" (const | id)* "}" 
const : CONST
id : ID