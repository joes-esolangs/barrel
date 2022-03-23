# barrel
 RPN but better, or worse. Who knows?

# Examples

Here is hello world:

```racket
#lang barrel

; this is hello world in barrel
"hello world"
; pushes () onto the stack
~
; outputs:
; hello world
; ()
```

# Use

You need to have `racket` and `raco` installed on your system, also preferably `DrRacket`.

Terminal + Package Server:
1. Open your terminal.
2. Since `barrel` is on the package server, you can just run `raco pkg install barrel`.
3. Once it finishes, make a file called `helloworld.brl` (`.brl` is the file extension for barrel code).
4. There you go, now you have `barrel` installed!

DrRacket:
1. Open DrRacket, and under `File`, click `Install Package`.
2. A text window will pop up. Type in `barrel` and then press `Install`. 
3. There you go, now you have `barrel` installed!

Building from Source:
1. Open your terminal.
2. In your terminal type in these two commands:
```
$ git clone https://github.com/crabbo-rave/barrel.git
$ cd barrel\barrel
$ raco pkg install
```
4. There you go, now you have `barrel` installed!

# Getting Started

3. Create a file called `helloworld.brl` (`.brl` is the file extension for barrel code).
4. In the file, add `#lang barrel` to the top, and then paste this code below:
```racket
"hello world"
~
```
5. Now you can run it by pressing the `Run` button in DrRacket, or by running `racket helloworld.brl` in the terminal. 
