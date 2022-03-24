#lang br/quicklang
(require racket/block)
(require racket/string)

(define (newline str) (string-append str "\n"))

(define (+!-helper op acc)
    (if (equal? stack empty)
        acc
        (block
          (define a (pop-stack!))
          (+!-helper (op a acc)))))

(define stack empty)

(define (pop-stack!)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (push-stack! arg)
  (set! stack (cons arg stack)))

(define (^ stack) (display (newline (~v (first stack)))))
(define $ pop-stack!)
(define (% stack) (display (newline (~v stack))))
(define (! stack) (display (newline (~v (length stack)))))
(define (/) (set! stack empty))
(define λ null)
(define (~) (push-stack! null))
(define (roll) (set! stack (reverse stack)))
(define (:) (push-stack! (first stack)))
(define (+!)
  (push-stack! (+!-helper + 0)))
(define (*!)
  (push-stack! (+!-helper * 0)))

(define (handle [arg #f])
  (match arg
    [(? number? arg) (push-stack! arg)]
    [(? string? arg) (display (newline arg))]
    [(or (== $) (== +!) (== /) (== *!) (== roll) (== :) (== ~))
     (arg)]
    [(or (== %) (== !) (== ^))
     (arg stack)]
    [(or (== +) (== *))
     (define op-result (arg (pop-stack!) (pop-stack!)))
     (push-stack! op-result)]
    [(== λ)
     (raise "revenge of the lambda" #t)]))
(provide handle)

(provide + * ^ $ % ! +! λ / roll : *! ~)

(provide stack)