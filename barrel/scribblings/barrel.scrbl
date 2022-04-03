#lang scribble/manual

@title{barrel: A stack language meant for lists}

@defmodulelang[barrel]

This is a stack language that uses reverse polish notation.
It is written in @racketmodname[br/quicklang], a slightly modified version of racket. I plan to translate to @racketmodname[racket/base] in the future.

The goal is to think in a new way with lists, with a forth-like stack language.

Language is still WIP. There isn't even list support yet. For all existing features, read below.

Let's start with the classic "Hello, World!":

@codeblock{
#lang barrel

main :: "hello world" .
}

This results in:

@verbatim{
hello world
}

@section{operators}

Here are all the current operators in barrel:

@tabular[#:sep ":    "
         (list (list "$" "pops the first item off the stack")
               (list ":" "duplicates the first item on the stack")
               (list "+" "sums the top two items on the stack")
               (list "*" "subtracts the top two items on the stack")
               (list "-" "multiples the top two items on the stack")
               (list "/" "divides the top two items on the stack")
               (