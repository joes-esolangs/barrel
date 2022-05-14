#lang br/quicklang
(require brag/support "util.rkt")

;; TODO: ERROR HANDLING IN FUNCTIONS

;; Evaluation

(define (print-stack-nice stack)
  (for-each (lambda (a) (if (quotation? a) (print-quote #t a) (displayln a))) (filter (or (negate void?) (negate procedure?)) stack)))
(provide print-stack-nice)

;; quotation definition

(define-struct quotation (words))
(provide make-quotation quotation? quotation-words)

;; helper function for applying words and functions

(define (apply-stack stack words)
   (foldl (lambda (f prev) (f prev)) stack words))
(provide apply-stack)

(define (apply-word words stack)
  (apply-stack stack (quotation-words words)))
(provide apply-word)

(define (bin-op op stack)
  (cons (op (second stack) (first stack)) (drop stack 2)))
(provide bin-op)

(define (bool-bin-op op stack)
  (cons (bool->number (op (second stack) (first stack))) (drop stack 2)))

(define (f-at-top f stack)
  (cons (f (first stack)) (rest stack)))

(define-unhygienic-macro (mk-temp-stack F Q)
  #'(define temp-stack (map (lambda (F) (F '())) (quotation-words Q))))

;; IO

(define (print-quote ln? in-quote)
  (define stringed (string-append "[" (string-join
                                       (map (lambda (f)
                                              (if (equal? (object-name f) 'curried:push)
                                                  (~a (list-ref (f empty) 0))
                                                  (func-to-str f)))
                                            (quotation-words in-quote)) " ")
                                  "]"))
  (if ln?
      (displayln stringed)
      (display stringed)))

(define (print stack)
  (if (quotation? (first stack))
      (print-quote #f (first stack))
      (display (first stack)))
  (rest stack))
(provide print)

(define (println stack)
  (if (quotation? (first stack))
      (print-quote #t (first stack))
      (displayln (first stack)))
  (rest stack))
(provide println)

(define (read stack)
  (define input (read-line))
  (cons input stack))
(provide read)

(define (print-stack stack)
  (displayln (string-append
              (format "{~a} " (length stack))
              (trim-ends "(" (~a (reverse stack)) ")")))
  stack)
(provide print-stack)

;; Stack

(define (push atom stack)
  (cons atom stack))
(provide push)

(define (pop stack)
  (rest stack))
(provide pop)

(define (dup stack)
  (cons (first stack) stack))
(provide dup)

(define (copy stack)
  (cons (list-ref stack (add1 (first stack))) (rest stack)))
(provide copy)

(define (swap stack)
  (define x (first stack))
  (define y (second stack))
  (cons y (cons x (drop stack 2))))
(provide swap)

(define (rotate stack)
  (define x (first stack))
  (define y (second stack))
  (define z (third stack))
  (cons y (cons z (cons x (drop stack 3)))))
(provide rotate)

(define (clear stack)
  empty)
(provide clear)

;; Combinators

(define (eval stack)
  (apply-stack (rest stack) (quotation-words (first stack))))
(provide eval)

(define (cat stack)
  (define q1 (first stack))
  (define q2 (second stack))
  (cons (make-quotation (append (quotation-words q2) (quotation-words q1))) (drop stack 2)))
(provide cat)

(define (dip stack)
  '())
(provide dip)

(define (if stack)
  '())
(provide if) 

;; Lists

(define (brl-map stack)
  (define f (first stack))
  (define ls (second stack))
  (mk-temp-stack f ls)
  (define applied (map (lambda (l) ((curry push) l)) (flatten (map (lambda (a) (apply-word f a)) temp-stack))))
  (cons (make-quotation applied) (drop stack 2)))
(provide (rename-out [brl-map map]))

;; Math

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

(define (mult stack)
  (bin-op * stack))
(provide mult)

(define (sub stack)
  (bin-op - stack))
(provide sub)

(define (div stack)
  (bin-op / stack))
(provide div)

(define (exp stack)
  (bin-op expt stack))
(provide exp)

(define (rem stack)
  (bin-op remainder stack))
(provide rem)

(define (gcd stack)
  (bin-op gcd stack))
(provide gcd)

(define (lcm stack)
  (bin-op lcm stack))
(provide lcm)

;; Comparison

(define (lt stack)
  (bool-bin-op < stack))
(provide lt)

(define (gt stack)
  (bool-bin-op > stack))
(provide gt)

(define (leq stack)
  (bool-bin-op <= stack))
(provide leq)

(define (geq stack)
  (bool-bin-op >= stack))
(provide geq)

(define (eq stack)
  (bool-bin-op equal? stack))
(provide eq)

(define (neq stack)
  (bool-bin-op (negate equal?) stack))
(provide neq)