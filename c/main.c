#include <stdio.h>
#include <stdlib.h>
#include<time.h>

typedef struct Natural {
    int x;
} NaturalType;

void initNatural(NaturalType* self) {
    self->x = 2;
}

int nextNatural(NaturalType* self) {
    return self->x++;
}

typedef struct Filter {
    int number;
    struct Filter *filter;
} FilterType;

FilterType* newFilter(int n, FilterType* filter) {
    FilterType* f = malloc(sizeof(FilterType));
    f->number = n;
    f->filter = filter;
    return f;
}

void releaseFilter(FilterType* filter) {
    while (filter != NULL) {
        FilterType* next = filter->filter;
        free(filter);
        filter = next;
    }
}

int accept(FilterType* filter, int n) {
    for (;;) {
        if (n % filter->number == 0) {
            return 0;
        }
        filter = filter->filter;
        if (filter == NULL) {
            return 1;
        }
    }
}

typedef struct Primes {
    NaturalType* natural;
    FilterType* filter;
} PrimesType;

void initPrimes(PrimesType* self, NaturalType* natural) {
    self->natural = natural;
    self->filter = NULL;
}

void releasePrimes(PrimesType* self) {
    releaseFilter(self->filter);
}

int nextPrime(PrimesType* self) {
    for (;;) {
        int n = nextNatural(self->natural);
        if (self->filter == NULL || accept(self->filter, n)) {
            self->filter = newFilter(n, self->filter);
            return n;
        }
    }
}

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
        }
        if (upto && cnt >= upto) {
            break;
        }
    }

    releasePrimes(&primes);

    return currentTimeMillis() - start;
}

int main(int argc, char** argv) {
    for (;;) {
        printf("Five thousand prime numbers in %ld ms\n", measure(1000, 5000));
    }
    return (EXIT_SUCCESS);
}

