#lang br/quicklang
(require racket/dict racket/block)
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

(define-macro (words WORDS ...)
  #'(block
      (define stack empty)
      (filter void? (list WORDS ...))
      (define code (filter (negate void?) (list WORDS ...)))
      (void (print-stack-nice (apply-stack stack code)))))
(provide words)

(define-macro (word "{" WORDS ... "}")
  #'(block
      (define code (list WORDS ...))
      (if (> (unbox count) 52)
          (raise "reached max definition limit")
          (set-box! definitions (append (unbox definitions) (list (make-quotation code)))))
      (set-box! count (+ (unbox count) 1))))
(provide word)

(define-macro (quote~ "[" WORDS ... "]")
  #'((curry push) (make-quotation (list WORDS ...))))
(provide quote~)

(define-macro (const CONST)
  #'((curry push) CONST))
(provide const)

(define-macro-cases id
  ;; Stack 
  [(id "$") #'pop]
  [(id ":") #'dup]
  [(id "~") #'swap]
  [(id "@") #'copy]
  [(id "#") #'rotate]
  [(id "_") #'clear]
  ;; Comparison
  
  ;; Combinators
  [(id "η") #'eval]
  [(id "χ") #'cat]
  [(id "Δ") #'dip]
  ;; IO
  [(id ".") #'print]
  [(id "·") #'println]
  [(id "§") #'print-stack]
  [(id ",") #'read]
  ;; Math
  [(id "+") #'plus]
  [(id "*") #'((curry bin-op) *)]
  [(id "-") #'((curry bin-op) -)]
  [(id "/") #'((curry bin-op) /)]
  [(id "^") #'((curry bin-op) expt)]
  ;; List 
  [(id "↦") #'map]
  ;; MISC
  [(id "λ") #'(begin
                (displayln "revenge of the lambda")
                (error 'lambda))]
  [(id ID) #'((curry apply-word) 
              (block
               (define decoded (b52-decode ID))
               (if (or (<= decoded (length (unbox definitions))) (not (< decoded 0)))
                   (list-ref (unbox definitions) (- decoded 1))
                   (raise (format "word \"~a\" not availible" ID)))))])
(provide id)