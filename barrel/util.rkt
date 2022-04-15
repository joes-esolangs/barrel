#lang br
(require threading)

(define (base52-decoder str)
  (for/fold ([n 0])
            ([c (in-string str)])
    (cond
      [(and (char-ci>=? c #\A) (char-ci<=? c #\Z)) (+ (* n 52) (- (char->integer c) (char->integer #\A)) 26)]
      [(and (char-ci>=? c #\a) (char-ci<=? c #\z)) (- (+ (* n 52) (char->integer c)) (char->integer #\a))])))

(define (base52-encoder-aux lut str n)
  (if (= n 0)
      (~> str string->list reverse list->string)
      (base52-encoder-aux lut (string-append str (list-ref lut (remainder n 52))) (quotient n 52))))

(define (base52-encoder n)
  (define lut (list "a" "b" "c" "d" "e" "f"
                    "g" "h" "i" "j" "k" "l"
                    "m" "n" "o" "p" "q" "r"
                    "s" "t" "u" "v" "w" "x"
                    "y" "z" "A" "B" "C" "D"
                    "E" "F" "G" "H" "I" "J"
                    "K" "L" "M" "N" "O" "P"
                    "Q" "R" "S" "T" "U" "V"
                    "W" "X" "Y" "Z"))
  (base52-encoder-aux lut "" n))
            
(base52-encoder 1676)
(base52-decoder "Fg") 