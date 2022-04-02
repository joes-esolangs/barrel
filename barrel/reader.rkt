#lang br/quicklang
(require "parser.rkt")

(require racket/string)

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
       [(concatenation "main" (:* whitespace) "::") (token 'MAIN)]
       [(concatenation (:+ (union alphabetic symbolic punctuation)) (:* whitespace) "::") (token 'NAME (string-trim (string-trim lexeme "::")))]
       [(union (concatenation (union "-" "") (concatenation (:+ numeric) (union (concatenation "." (:+ numeric)) "")))) (token 'CONST (string->number lexeme))]
       [(concatenation "\"" (:+ (union alphabetic punctuation symbolic whitespace)) "\"") (token 'CONST (string-trim lexeme "\""))]
       [(:+ (union alphabetic symbolic punctuation)) (token 'ID lexeme)]
       [(concatenation ";" (:+ (union alphabetic symbolic punctuation whitespace)) ";") (next-token)]
       [any-char (next-token)]))
    (brl-lexer port))
  next-token)
