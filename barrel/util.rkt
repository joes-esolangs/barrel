#lang br/quicklang
(require racket/contract)

(define (b52-decode str)
  (for/fold ([n 0])
            ([c str])
    (+ (* n 52) (* 58 (if (char<=? c #\Z) 1 0)) (- (char->integer c) (char->integer #\a)) 1)))
(provide (contract-out
          [b52-decode (string? . -> . integer?)]))

(define (lfy e)
  (lambda () e))
(provide lfy)

(define-macro (func-to-str F)
  #'(match (object-name F)
      ;; Stack 
      ['pop "$"]
      ['dup ":"]
      ['swap "~"]
      ['copy "@"]
      ['rotate "#"]
      [clear "!"]
      [move "&"]
      ;; Combinators
      ['eval "η"]
      ['cat "χ"]`
      ['dip "Δ"]
      ['brl-if "?"]
      ;; IO
      ['print "."]
      ['println "·"]
      ['print-stack "§"]
      ['read ","]
      ;; Math
      ['plus "+"]
      ['mult "*"]
      ['div "/"]
      ['exp "^"]
      ['rem "%"]
      ['gcd "`"]
      ['lcm "&"]
      ;; List 
      ['map "↦"]
      ;; Comparison
      [lt "<"]
      [gt ">"]
      [leq "≤"]
      [geq "≥"]
      [eq "="]
      [neq "≠"]
      
      [else (error 'unknown-id)]))
(provide func-to-str)

(define (bool->number b)
  (if b 1 0))
(provide bool->number)

(define (remove+ lst n)
  (let-values (((front back) (split-at lst n)))
    (append front (cdr back))))
(provide remove+)