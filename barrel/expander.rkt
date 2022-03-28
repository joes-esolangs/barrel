#lang br/quicklang
(require "core.rkt")
(provide (all-from-out "core.rkt"))

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define (apply-stack stack atoms)
   (foldl (lambda (f prev) (f prev)) stack atoms))
  
(define-macro (brl-program ATOMS ...)
  #'(begin
      (define stack empty)
      (void (apply-stack stack (list ATOMS ...)))))
(provide brl-program)

(define-macro (const CONST)
  #'((curry push) CONST))
(provide const)

(define-macro-cases id
  [(id "$") #'pop]
  [(id ":") #'dup]
  [(id "+") #'((curry math-op) +)]
  [(id "*") #'((curry math-op) *)]
  [(id "-") #'((curry math-op) -)]
  [(id "/") #'((curry math-op) /)]
  [(id "-*") #'neg]
  [(id ".") #'print]
  [(id "~") #'swap]
  [(id "λ") (raise "revenge of the lambda")]
  [_ (raise "unknown id" #t)])
(provide id)

