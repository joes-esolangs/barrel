#lang br/quicklang
(require racket/dict)
(require racket/block)
(require "core.rkt")
(provide (all-from-out "core.rkt"))

(define definitions (make-hash))
(provide definitions)

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define (apply-stack stack words)
   (foldl (lambda (f prev) (f prev)) stack words))

(define (apply-word words stack)
  (apply-stack stack words))

(define-macro (words WORDS ...)
  #'(last (list WORDS ...)))
(provide words)

(define-macro (main WORDS ...)
  #'(block
      (define stack empty)
      (void (apply-stack stack (rest (list WORDS ...))))))
(provide main)

(define-macro (word WORDS ...)
  #'(dict-set! definitions (first (list WORDS ...)) (rest (list WORDS ...))))
(provide word)

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
  [(id "!") #'neg]
  [(id ".") #'print]
  [(id ".n") #'println]
  [(id ".!") #'print-stack]
  [(id "~") #'swap]
  [(id ":@") #'copy]
  [(id "+s") #'concat]
  [(id "<>") #'n-rev]
  [(id "()") #'((curry push) null)]
  [(id "λ") #'(begin
                (displayln "revenge of the lambda")
                (error 'lambda))]
  [(id ID) #'(with-handlers ([exn:fail?
                              (lambda (e) (begin
                                            (displayln (format "unknown id: ~a" ID))
                                            (error 'unknown-id)))])
                ((curry apply-word) (dict-ref definitions ID)))])
(provide id)