#include "lib.h"

unsigned long long fibonacci(unsigned int n) {
    if (n <= 1) {
        return n;
    }

    unsigned long long a = 0;
    unsigned long long b = 1;
    unsigned long long fib = 0;

    for (unsigned int i = 2; i <= n; ++i) {
        fib = a + b;
        a = b;
        b = fib;
    }

    return fib;
}
