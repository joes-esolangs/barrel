#lang scribble/manual

@title{barrel: RPN but worse with more features}

@defmodulelang[barrel]

@section{intro}

This is a stack language that uses reverse polish notation, written as my first programming language.
It is written in @racketmodname[br/quicklang].

Its beginner friendly, and golf-free, since every eexpression must be written on a new line.

Let's start with the classic "Hello, World!":

@examples[
#lang barrel

; the line below prints the string to console
"hello world"
; the / clears the stack
/
; at the end, the first item on the stack gets returned
]

This results in:

@verbatim{
hello world
()
}