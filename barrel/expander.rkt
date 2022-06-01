#lang br/quicklang
(require racket/dict
         racket/block)
(require "core.rkt"
         "util.rkt")
(provide (all-from-out "core.rkt"))

(provide definitions)
(define definitions (box empty))

(define count (box 0))

(define-macro (barrel-module-begin PARSE-TREE) #'(#%module-begin PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define-macro (words WORDS ...)
  #'(block (define stack empty)
           (define words (list WORDS ...))
           (filter void? words)
           (define code (filter (negate void?) words))
           (void (print-stack-nice (apply-stack stack code)))))
(provide words)

(define-macro (word "{" WORDS ... "}")
  #'(block (define code (list WORDS ...))
           (if (> (unbox count) 52)
               (raise "reached max definition limit")
               (set-box! definitions
                         (append (unbox definitions)
                                 (list (make-quotation code)))))
           (set-box! count (+ (unbox count) 1))))
(provide word)

(define-macro (quote~ "[" WORDS ... "]")
  #'(block
      ;; TODO: Get the STACKK
      (define words (list WORDS ...))
      ((curry push) (if (member "_" words) (make-quotation (fried-quote words STACKK)) (make-quotation (list WORDS ...))))))
(provide quote~)

(define-macro (fried-quote WORDS STACK)
  #'(1))

(define-macro (const CONST) #'((curry push) CONST))
(provide const)

(define-macro (id ID)
              #'(match ID
                  ;; Stack
                  ["$" pop]
                  [":" dup]
                  ["~" swap]
                  ["@" copy]
                  ["#" rotate]
                  ["!" clear]
                  ["&" move]
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
                  ["?" brl-if]
                  ;; IO
                  ["." brl-print]
                  ["·" brl-println]
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
                  ["↦" brl-map]
                  ;; MISC
                  ["λ" inf]
                  [ID
                   ((curry apply-word)
                    (block (define decoded (b52-decode ID))
                           (with-handlers ([exn:fail?
                                            (λ (e) (raise (format "word \"~a\" not availible"
                                              ID)))])
                               (list-ref (unbox definitions) (- decoded 1)))))]))
(provide id)