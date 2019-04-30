#include <stdlib.h>
#include <math.h>
#include "filter.h"

FilterType* newFilter(int n) {
    FilterType* f = malloc(sizeof(FilterType));
    f->number = n;
    f->next = NULL;
    f->last = f;
    return f;
}

void releaseFilter(FilterType* filter) {
    while (filter != NULL) {
        FilterType* next = filter->next;
        free(filter);
        filter = next;
    }
}

int acceptAndAdd(FilterType* filter, int n) {
    FilterType* first = filter;
    int upto = (int)sqrt(n);
    for (;;) {
        if (n % filter->number == 0) {
            return 0;
        }
        if (filter->number > upto) {
            break;
        }
        filter = filter->next;
    }
    FilterType* f = newFilter(n);
    first->last->next = f;
    first->last = f;
    return 1;
}

