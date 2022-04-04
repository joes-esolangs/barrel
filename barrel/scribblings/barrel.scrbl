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

@tabular[#:sep @hspace[3]
         (list (list @tt["$"] @italic["pops the first item off the stack"])
               (list @tt[":"] @italic["duplicates the first item on the stack"])
               (list @tt["+"] @italic["sums the top two items on the stack"])
               (list @tt["*"] @italic["subtracts the top two items on the stack"])
               (list @tt["-"] @italic["multiples the top two items on the stack"])
               (list @tt["/"] @italic["divides the top two items on the stack"])
               (list @tt["!"] @italic["negates the first item"])
               (list @tt["."] @italic["prints the first item without a newline and pops it"])
               (list @tt[".\\"] @italic["prints the first item with a newline and pops it"])
               (list @tt["~"] @italic["swaps the top two items on the stack"])
               (list @tt[":@"] @italic["copies an item from a given index to the top of the stack"])
               (list @tt["+s"] @italic["concats the top two items on the stack (meant for strings)"])
               (list @tt["<>"] @italic["reverses the top n elements on the stack"])
               (list @tt["λ"] @bold["undocumented"]))]