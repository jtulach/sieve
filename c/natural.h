#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include<time.h>

typedef struct Natural {
    int x;
} NaturalType;

void initNatural(NaturalType* self);
int nextNatural(NaturalType* self);
