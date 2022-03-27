#lang br/quicklang

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define (apply-stack stack atoms)
  (for/fold ([current-stack stack])
            ([atom (in-list atoms)])
    (atom current-stack)))
  
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
  [(id "+") #'add]
  [(id "*") #'mul]
  [(id ".") #'print]
  [(id "%") #'swap]
  [(id "λ") (raise "revenge of the lambda")]
  [_ (raise "unknown id" #t)])
(provide id)

(define (push atom stack)
  (cons atom stack))

(define (pop stack)
  (rest stack))

(define (dup stack)
  (cons (first stack) stack))

(define (add stack)
  (cons (+ (first stack) (second stack)) (drop stack 2)))

(define (mul stack)
  (cons (* (first stack) (second stack)) (drop stack 2)))

(define (print stack)
  (writeln (first stack)))

(define (swap stack)
  (define x (first stack))
  (define y (second stack))
  (cons y (cons x (drop stack 2))))