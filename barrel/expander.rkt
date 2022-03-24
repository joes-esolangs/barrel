#lang br/quicklang

(require "std.rkt")

(define-macro (barrel-module-begin HANDLE-ARGS-EXPR) 
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [barrel-module-begin #%module-begin]))

(provide (all-from-out "std.rkt"))