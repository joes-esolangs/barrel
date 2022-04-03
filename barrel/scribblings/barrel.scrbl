#lang scribble/manual

@title{barrel: A stack language meant for lists}

@defmodulelang[barrel]

@section{intro}

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