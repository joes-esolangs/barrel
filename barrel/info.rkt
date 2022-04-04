#lang info

(define collection "barrel")

(define deps
  '("base"
    "beautiful-racket"
    "brag-lib"
    "threading-lib"))

(define module-suffixes '(#".brl"))

(define scribblings '(("scribblings/barrel.scrbl" (multi-page))))