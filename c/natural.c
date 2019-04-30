#include "natural.h"

void initNatural(NaturalType* self) {
    self->x = 2;
}

int nextNatural(NaturalType* self) {
    return self->x++;
}
