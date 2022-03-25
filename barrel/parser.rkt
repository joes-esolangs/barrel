#lang brag
brl-program : (number | string | brl-op)+
brl-expr : number | string | brl-op
number : ["-"] NUMBER+
string : STRING
brl-op : "+" | "*" | "$" | "!" | "%" | "+!"
         "λ" | "/" | "&" | ":" | "~" | "*!"