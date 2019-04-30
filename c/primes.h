#include "natural.h"
#include "filter.h"

typedef struct Primes {
    NaturalType* natural;
    FilterType* filter;
} PrimesType;

void initPrimes(PrimesType* self, NaturalType* natural);
void releasePrimes(PrimesType* self);
int nextPrime(PrimesType* self);
