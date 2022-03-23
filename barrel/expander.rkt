#lang br/quicklang

(require "std.rkt")

(define-macro (barrel-module-begin HANDLE-EXPR ...) 
  #'(#%module-begin
     HANDLE-EXPR ...
     (display (first stack))))
(provide (rename-out [barrel-module-begin #%module-begin]))

(provide (all-from-out "std.rkt"))