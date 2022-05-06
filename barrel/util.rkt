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
      ['add "+"]
      ;; Stack 
      ['pop "$"]
      ['dup ":"]
      ['swap "~"]
      ['copy "@"]
      ['rotate "#"]
      ;; Combinators
      ['eval "η"]
      ['cat "χ"]
      ['dip "δ"]
      ;; IO
      ['print "."]
      ['println "·"]
      ['print-stack "§"]
      ['read ","]
      ;; Math
      ['plus "+"]
      ['((curry math-op) *) "*"]
      ['((curry math-op) -) "-"]
      ['((curry math-op) /) "/"]
      ;; List 
      ['map "↦"]
      [else (error 'unkown-id)]))
(provide func-to-str)
