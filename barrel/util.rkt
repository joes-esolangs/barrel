#lang br/quicklang
(require racket/contract)

(define (b52-decode str)
  (for/fold ([n 0])
            ([c str])
    (+ (* n 52) (* 58 (if (char<=? c #\Z) 1 0)) (- (char->integer c) (char->integer #\a)) 1)))
(provide (contract-out
          [b52-decode (string? . -> . integer?)]))

(define (print-stack-nice stack)
  (for-each (lambda (a) (displayln a)) (filter (negate void?) stack)))
(provide print-stack-nice)