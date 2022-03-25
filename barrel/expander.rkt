#lang br/quicklang

(require "std.rkt")

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     'PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))

; (provide (all-from-out "std.rkt"))