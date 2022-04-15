#lang br/quicklang
(require "parser.rkt" "tokenizer.rkt")
(require threading racket/contract)

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port)))
  (define module-datum `(module barrel-module barrel/expander
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide (contract-out
          [read-syntax (any/c input-port? . -> . syntax?)]))

