#lang br/quicklang
(require racket/dict racket/block threading)
(require "core.rkt" "util.rkt")
(provide (all-from-out "core.rkt"))

;(define definitions (make-hash))
(define definitions empty)

(define count 0)

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define (apply-stack stack words)
   (foldl (lambda (f prev) (f prev)) stack words))

(define (apply-word words stack)
  (apply-stack stack (words)))

(define-macro (words WORDS ...)
  #'(block
      (define stack empty)
      (void (apply-stack stack (list WORDS ...)))))
(provide words)

(define-macro (word "{" WORDS ... "}")
  #'(block
      (define code (list WORDS ...))
      (if (> count 52)
          (raise "reached max definition limit")
          (set! definitions (cons code definitions)))
      (set! count (+ count 1))))
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
                                   (define decoded (b52-decode ID))
                                   (if (<= decoded 52)
                                       (list-ref definitions (- 1 decoded))
                                       (raise (format "word ~a not availible" ID)))))])
(provide id)