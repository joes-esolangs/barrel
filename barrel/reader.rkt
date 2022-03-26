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
       [(:+ numeric) (token 'INT (string->number lexeme))]
       [(:+ (union alphabetic symbolic punctuation)) (token 'ID lexeme)]
       [(concatenation "\"" (:+ alphabetic) "\"") (token 'STR (string-trim lexeme "\""))]
       [any-char (next-token)]))
    (brl-lexer port))
  next-token)
