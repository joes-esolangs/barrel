#lang br/quicklang
(require brag/support
         racket/contract)

(define (make-tokenizer port)
  (define (next-token)
    (define brl-lexer
      (lexer [(union (char-set "{}[]") "_") lexeme]
             [(union (concatenation
                      (union "-" "")
                      (concatenation
                       (:+ numeric)
                       (union (concatenation "." (:+ numeric)) ""))))
              (token 'CONST (string->number lexeme))]
             [(from/to "\"" "\"") (token 'CONST (string-trim lexeme "\""))]
             [(union symbolic punctuation alphabetic) (token 'ID lexeme)]
             [any-char (next-token)]))
    (brl-lexer port))
  next-token)
(provide (contract-out [make-tokenizer (input-port? . -> . procedure?)]))