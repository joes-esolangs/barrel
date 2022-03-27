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
      (display (first (apply-stack stack (list ATOMS ...))))))
(provide brl-program)

(define-macro (int INT)
  #'((curry push) INT))
(provide int)

(define-macro-cases id
  [(id "$") #'pop]
  [(id "λ") #'lambda]
  [(id ":") #'dup]
  [(id "+") #'add]
  [(id "*") #'mul]
  [_ (raise "unknown id" #t)])
(provide id)

(define (push atom stack)
  (cons atom stack))

(define (pop stack)
  (rest stack))

(define (dup stack)
  (cons (first stack) stack))

(define (add stack)
  (push (+ (first stack) (second stack)) (drop stack 2)))

(define (mul stack)
  (push (* (first stack) (second stack)) (drop stack 2)))