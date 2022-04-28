#lang br/quicklang
(require racket/cmdline
         barrel/reader)
(command-line
  #:args (filename)
  ;; parse file
  (define module-syntax
    (call-with-input-file* filename
      (lambda (in)
        (read-syntax filename in))))
  ;; eval module form in a namespace with racket/base
  (define ns (make-base-namespace))
  (eval module-syntax ns)
  ;; require the module in the namespace to run it
  (eval `(require ',(second (syntax->datum module-syntax))) ns))