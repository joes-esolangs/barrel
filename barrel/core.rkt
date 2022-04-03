#lang br/quicklang

(define (bin-op op stack)
  (cons (op (first stack) (second stack)) (drop stack 2)))

(define (f-at-top f stack)
  (cons (f (first stack)) (rest stack)))

(define (print stack)
  (write (first stack))
  (rest stack))
(provide print)

(define (println stack)
  (writeln (first stack))
  (rest stack))
(provide println)

(define (push atom stack)
  (cons atom stack))
(provide push)

(define (pop stack)
  (rest stack))
(provide pop)

(define (dup stack)
  (cons (first stack) stack))
(provide dup)

(define (math-op op stack)
  (match op
    [(== +) (bin-op op stack)]
    [(== *) (bin-op op stack)]
    [(== -) (bin-op op stack)]
    [(== /) (bin-op op stack)]))
(provide math-op)

(define (swap stack)
  (define x (first stack))
  (define y (second stack))
  (cons y (cons x (drop stack 2))))
(provide swap)

(define (neg stack)
  (f-at-top (lambda (x) (- x)) stack))
(provide neg)

(define (copy stack)
  (cons (list-ref stack (add1 (first stack))) stack))
(provide copy)