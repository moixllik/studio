module main

#flag -I @VMODROOT/c
#flag windows @VMODROOT/c/libwin.a
#flag linux @VMODROOT/c/libunix.a

#include "lib.h"

fn C.fibonacci(n int) int

fn main() {
  fib := C.fibonacci(33)
  println('Fibonacci #33: ' + fib.str())
}
