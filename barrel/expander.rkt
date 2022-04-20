#lang br/quicklang
(require racket/dict racket/block threading)
(require "core.rkt" "util.rkt")
(provide (all-from-out "core.rkt"))

(provide definitions)
(define definitions (box empty))

(define count (box 0))

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define (apply-stack stack words)
   (foldl (lambda (f prev) (f prev)) stack words))

(define (apply-word words stack)
  (apply-stack stack (words)))

;; TODO: add implicit printing
(define-macro (words WORDS ...)
  #'(block
      (define stack empty)
      (filter void? (list WORDS ...))
      (define code (filter (negate void?) (list WORDS ...)))
      (void (apply-stack stack code))))
(provide words)

(define-macro (word "{" WORDS ... "}")
  #'(block
      (define code (list WORDS ...))
      (if (> (unbox count) 52)
          (raise "reached max definition limit")
          (set-box! definitions (cons code (unbox definitions))))
      (set-box! count (+ (unbox count) 1))))
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
                                   (if (<= decoded (length (unbox definitions)))
                                       (list-ref (unbox definitions) (- decoded 1))
                                       (raise (format "word ~a not availible" ID)))))])
(provide id)