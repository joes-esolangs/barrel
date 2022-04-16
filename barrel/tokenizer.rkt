#lang br/quicklang
(require brag/support racket/block threading racket/contract)

(define (make-tokenizer port)
  (define (next-token)
    (define brl-lexer
      (lexer
       [(from/to "`" "\n") (next-token)]
       [(char-set "{}[]()") (token lexeme)]
;       [(concatenation (:+ (union alphabetic "_")) (:* whitespace) ";") (block
;                                                                         (define name
;                                                                           (~>
;                                                                            lexeme
;                                                                            (string-trim ";")
;                                                                            (string-trim)))
;                                                                         (token 'NAME name))]
       [(union (concatenation (union "-" "") (concatenation (:+ numeric) (union (concatenation "." (:+ numeric)) "")))) (token 'CONST (string->number lexeme))]
       [(concatenation "\"" (:+ (union alphabetic symbolic whitespace)) "\"") (token 'CONST (string-trim lexeme "\""))]
       [(union symbolic punctuation alphabetic) (token 'ID lexeme)]
       [any-char (next-token)]))
    (brl-lexer port))
  next-token)
(provide (contract-out
          [make-tokenizer (input-port? . -> . procedure?)]))