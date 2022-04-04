#lang br/quicklang
(require "parser.rkt")
(require threading)

(require racket/string)

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port)))
  (define module-datum `(module brl-mod barrel/expander
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)

(require brag/support)
(define (make-tokenizer port)
  (define (next-token)
    (define brl-lexer
      (lexer
       [(concatenation "main" (:* whitespace) "::") (token 'MAIN)]
       [(concatenation (:+ (union alphabetic symbolic punctuation)) (:* whitespace) "::") (token 'NAME
                                                                                                 (~>
                                                                                                  lexeme
                                                                                                  (string-trim "::")
                                                                                                  (string-trim)))]
       [(union (concatenation (union "-" "") (concatenation (:+ numeric) (union (concatenation "." (:+ numeric)) "")))) (token 'CONST (string->number lexeme))]
       [(concatenation "\"" (:+ (union alphabetic symbolic whitespace)) "\"") (token 'CONST (string-trim lexeme "\""))]
       [(:+ (union alphabetic symbolic punctuation numeric)) (token 'ID lexeme)]
       [(concatenation ";" (:+ (union alphabetic symbolic punctuation whitespace)) ";") (next-token)]
       [any-char (next-token)]))
    (brl-lexer port))
  next-token)
(provide make-tokenizer)