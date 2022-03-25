#lang br/quicklang
(require "parser.rkt")

(require racket/string)

(define (src-line? ln) (not (or (equal? ln "") (string-prefix? ln ";"))))

(define (read-syntax path port)
  (define parse-tree (parse path (tokenize port)))
  (define module-datum `(module brl-mod barrel/expander
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)

(require brag/support)
(define (tokenize port)
  (define (next-token)
    (define brl-lexer
      (lexer
       [(char-set "+*$!%/&:~λ") lexeme]
       [(:+ numeric) (token 'NUMBER (string->number lexeme))]
       [(:+ alphabetic) (token 'STRING lexeme)]
       [any-char (next-token)]))
    (brl-lexer port))
  next-token)
