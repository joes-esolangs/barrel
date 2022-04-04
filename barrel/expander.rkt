#lang br/quicklang
(require racket/dict)
(require racket/block)
(require "core.rkt")
(provide (all-from-out "core.rkt"))

(define definitions (make-hash))

(define-macro (barrel-module-begin PARSE-TREE) 
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [barrel-module-begin #%module-begin]))
(provide #%top-interaction)

(define (apply-stack stack atoms)
   (foldl (lambda (f prev) (f prev)) stack atoms))

(define-macro (words WORDS ...)
  #'(last (list WORDS ...)))
(provide words)

(define-macro (main ATOMS ...)
  #'(block
      (define stack empty)
      (void (apply-stack stack (flatten (rest (list ATOMS ...)))))))
(provide main)

(define-macro (word ATOMS ...)
  #'(dict-set! definitions (first (list ATOMS ...)) (rest (list ATOMS ...))))
(provide word)

(define-macro (const CONST)
  #'((curry push) CONST))
(provide const)

(define-macro-cases id
  [(id "$") #'pop]
  [(id ":") #'dup]
  [(id "+") #'((curry math-op) +)]
  [(id "*") #'((curry math-op) *)]
  [(id "-") #'((curry math-op) -)]
  [(id "/") #'((curry math-op) /)]
  [(id "!") #'neg]
  [(id ".") #'print]
  [(id ".n") #'println]
  [(id ".!") #'print-stack]
  [(id "~") #'swap]
  [(id ":@") #'copy]
  [(id "+s") #'concat]
  [(id "<>") #'n-rev]
  [(id "()") #'((curry push) null)]
  [(id "λ") #'(begin
                (displayln "revenge of the lambda")
                (exit))]
  [(id ID) #'(with-handlers ([exn:fail?
                              (lambda (e) (begin
                                            (displayln (format "unknown id: ~a" ID))
                                            (exit)))])
               (dict-ref definitions ID))])
(provide id)