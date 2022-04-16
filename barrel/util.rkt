#lang br
(require threading control)

(define (base52-encoder-aux lit str n)
  (define str "")
  (until (= n 0)
    (set! str (string-append str (list-ref lit (remainder n 52))))
    (set! n (quotient n 52)))
  (~> str string->list reverse list->string))
      
(define (base52-encoder n)
  (define lit (list "a" "b" "c" "d" "e" "f"
                    "g" "h" "i" "j" "k" "l"
                    "m" "n" "o" "p" "q" "r"
                    "s" "t" "u" "v" "w" "x"
                    "y" "z" "A" "B" "C" "D"
                    "E" "F" "G" "H" "I" "J"
                    "K" "L" "M" "N" "O" "P"
                    "Q" "R" "S" "T" "U" "V"
                    "W" "X" "Y" "Z"))
  (base52-encoder-aux lit "" n))

(provide base52-encoder)