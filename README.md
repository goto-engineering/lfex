# Lisp Flavored Elixir

*Warning: super alpha status, only basic function calls work.*

Inspired by Lispex and LFE, LFEX parses S-expressions into the Elixir AST format and runs them.

`(IO.puts "Hi")` turns into `IO.puts("Hi")`. Data structure syntax same as Elixir, but no commas are necessary between elements/arguments.

Example:

```
lfex> (+ 2 2)
4

lfex> (+ 1 (/ 3 (* 2 3)))
1.5

lfex> (IO.puts "Hello")
Hello
:ok

lfex> (Enum.join ["A" "B" "C"] "_")
"A_B_C"

lfex> (Map.put %{:user "Bob"} :user "Billy")
%{:user "Billy"}
```

## Start the REPL

Run `mix repl` to try out the REPL. Like any Elixir process, end it by pressing Ctrl-C twice.

If `rlwrap` is installed, you can get free REPL niceties like previous commands and parens matching:
`rlwrap mix repl`.

## Todo

1. Use macros - defmodule, defn
1. Function references
1. Compile source files to .beam bytecode
1. Pattern matching - let?
1. Anonymous fn syntax? Elixir syntax, Clojure syntax, ES6 syntax?
1. Dashes in fn names?
1. Cool REPL functions like call count
1. Structs
1. How does threading work? |>? Clojure style ->? Implement as macro?
1. Define user macros?
