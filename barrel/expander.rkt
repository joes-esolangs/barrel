#lang br/quicklang
(require racket/dict)
(require "core.rkt")
(provide (all-from-out "core.rkt"))

(define definitions '())

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     'PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define (apply-stack stack atoms)
   (foldl (lambda (f prev) (f prev)) stack atoms))

(define-macro (main ATOMS ...)
  #'(begin
      (define stack empty)
      (void (apply-stack stack (list ATOMS ...)))))

(define-macro (word ATOMS ...)
  #'(dict-set! definitions (first (list ATOMS ...)) #'(rest (list ATOMS ...))))

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
  [(id ":@") #'copy]
  [(id "λ") #'(error "revenge of the lambda")]
  [(id ID) #'(with-handlers ([exn:fail?
                              (lambda (e) (begin
                                            (displayln (format "unknown id: ~a" ID))
                                            (exit)))])
               (dict-ref definitions ID))])
(provide id)

