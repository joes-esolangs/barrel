#lang br
(require syntax/parse/define)

(define-simple-macro (string-define NAME EXPR)
  #:with ID (format-id #'NAME "~a" (syntax-e #'NAME))
  (define ID EXPR))
(provide string-define)

