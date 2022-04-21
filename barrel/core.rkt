#lang br/quicklang
(require brag/support)

(define-struct quotation (words))
(provide make-quotation quotation? quotation-words)

(define (apply-stack stack words)
   (foldl (lambda (f prev) (f prev)) stack words))
(provide apply-stack)

(define (apply-word words stack)
  (apply-stack stack (words)))
(provide apply-word)

(define (bin-op op stack)
  (cons (op (second stack) (first stack)) (drop stack 2)))

(define (f-at-top f stack)
  (cons (f (first stack)) (rest stack)))

(define (print stack)
  (display (first stack))
  (rest stack))
(provide print)

(define (println stack)
  (displayln (first stack))
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

;; TODO: Fix calling quotations
(define (exclamation stack)
  (cond ;; (apply-word (lambda () (quotation-words (first stack))) stack)
    [(quotation? (first stack)) (apply-word (lambda () (quotation-words (first stack))) (rest stack))]
    [(number? (first stack)) (f-at-top - stack)]
    [(string? (first stack)) (f-at-top string->number stack)]))
(provide exclamation)

(define (swap stack)
  (define x (first stack))
  (define y (second stack))
  (cons y (cons x (drop stack 2))))
(provide swap)

(define (copy stack)
  (cons (list-ref stack (add1 (first stack))) (rest stack)))
(provide copy)

(define (concat stack)
  (cons (string-append (second stack) (first stack)) (drop stack 2)))
(provide concat)

(define (n-rev stack)
  (append (reverse (take (rest stack) (first stack))) (drop (rest stack) (first stack))))
(provide n-rev)

(define (print-stack stack)
  (displayln (string-append
              (format "{~a} " (length stack))
              (trim-ends "(" (~a (reverse stack)) ")")))
  stack)
(provide print-stack)

;; instead of append two quotations, maybe sum one of them
(define (plus stack)
  (define a (first stack))
  (define b (second stack))
  (define rest (drop stack 2))
  (cond
    [(and (number? a) (number? b)) (cons (+ b a) rest)]
    [(and (string? a) (string? b)) (cons (string-append b a) rest)]
    [else (displayln "error: type mismatch") (error 'type-mismatch)]))
(provide plus)

(define (read stack)
  (define input (read-line))
  (cons input stack))
(provide read)