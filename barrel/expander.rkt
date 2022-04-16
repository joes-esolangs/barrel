#lang br/quicklang
(require racket/dict racket/block threading)
(require "core.rkt" "util.rkt")
(provide (all-from-out "core.rkt"))

(provide definitions)
(define definitions (make-hash))

(define count 0)

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     'PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define (apply-stack stack words)
   (foldl (lambda (f prev) (f prev)) stack words))

(define (apply-word words stack)
  (apply-stack stack (words)))

(define-macro (words WORDS ...)
  #'(block
      (define stack empty)
      (void (apply-stack stack (rest (list WORDS ...))))))
(provide words)

(define-macro (word "{" WORDS ... "}")
  #'(block
      (define name (base52-encoder count))
      (define code (list WORDS ...))
      (dict-set! definitions name code)
      ))
(provide word)

(define-macro (const CONST)
  #'((curry push) CONST))
(provide const)

(define-macro-cases id
  [(id "$") #'pop]
  [(id ":") #'dup]
  [(id "+") #'plus]
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
  [(id ".<") #'read]
  [(id "λ") #'(begin
                (displayln "revenge of the lambda")
                (error 'lambda))]
  [(id ID) #'((curry apply-word) (lambda ()
                                   (with-handlers ([exn:fail?
                                                    (lambda (e) (begin
                                                                  (displayln (format "unknown id: ~a" ID))
                                                                  (error 'unknown-id)))])
                (dict-ref definitions ID))))])
(provide id)