#include <stdlib.h>
#include "primes.h"

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
        if (self->filter == NULL) {
            self->filter = newFilter(n);
            return n;
        }
        if (acceptAndAdd(self->filter, n)) {
            return n;
        }
    }
}
