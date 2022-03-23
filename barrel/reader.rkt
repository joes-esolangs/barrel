#lang br/quicklang

(require "std.rkt")

(require racket/string)

(define (src-line? ln) (not (or (equal? ln "")
                                (string-prefix? ln ";"))))

(define (read-syntax path port)
  (define src-lines (filter (curry src-line?) (port->lines port)))
  (define src-datums (format-datums '(handle ~a) src-lines))
  (define module-datum `(module barrel-mod barrel/expander
                          ,@src-datums))
  (datum->syntax #f module-datum))
(provide read-syntax)

(provide + * ^ $ % ! +! λ / roll : *! handle)