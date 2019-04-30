#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "primes.h"

long currentTimeMillis() {
    clock_t t1;

    t1 = clock();
    return t1 / 1000;
}

long measure(int prntCnt, int upto) {
    NaturalType n;
    initNatural(&n);

    PrimesType primes;
    initPrimes(&primes, &n);

    long start = currentTimeMillis();
    int cnt = 0;
    int res = -1;
    for (;;) {
        res = nextPrime(&primes);
        cnt++;
        if (cnt % prntCnt == 0) {
            printf("Computed %d primes in %ld ms. Last one is %d\n", cnt, (currentTimeMillis() - start), res);
            prntCnt *= 2;
        }
        if (upto && cnt >= upto) {
            break;
        }
    }

    releasePrimes(&primes);

    return currentTimeMillis() - start;
}

int main(int argc, char** argv) {
    int count = -1;
    if (argc == 2) {
        count = atoi(argv[1]);
    }
    for (;;) {
        printf("Hundred thousand prime numbers in %ld ms\n", measure(97, 100000));
        if (count != -1) {
            if (--count == 0) {
                break;
            }
        }
    }
    return (EXIT_SUCCESS);
}

