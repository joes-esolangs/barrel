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

(define-macro (id ID)
  #'(match ID
      ;; Stack 
      ["$" pop]
      [":" dup]
      ["~" swap]
      ["@" copy]
      ["#" rotate]
      ["_" clear]
      ;; Comparison
      ["<" lt]
      [">" gt]
      ["≤" leq]
      ["≥" geq]
      ["=" eq]
      ["≠" neq]
      ;; Combinators
      ["η" eval]
      ["χ" cat]
      ["Δ" dip]
      ["?" if]
      ;; IO
      ["." print]
      ["·" println]
      ["§" print-stack]
      ["," read]
      ;; Math
      ["+" plus]
      ["*" mult]
      ["-" sub]
      ["/" div]
      ["^" exp]
      ["%" rem]
      ["`" gcd]
      ["&" lcm]
      ;; List 
      ["↦" map]
      ;; MISC
      ["λ" (begin
                    (displayln "revenge of the lambda")
                    (error 'lambda))]
      [ID ((curry apply-word) 
                  (block
                   (define decoded (b52-decode ID))
                   (if (or (<= decoded (length (unbox definitions))) (not (< decoded 0)))
                       (list-ref (unbox definitions) (- decoded 1))
                       (raise (format "word \"~a\" not availible" ID)))))]))
(provide id)