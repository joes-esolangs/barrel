#lang info

(define collection "barrel")

(define deps
  '("base"
    "beautiful-racket"
    "brag-lib"
    "threading-lib"
    "br-parser-tools"
    "control"))

(define module-suffixes '(#".brl"))

(define scribblings '(("scribblings/barrel.scrbl" (multi-page))))

(define racket-launcher-names '("barrel" "brl"))