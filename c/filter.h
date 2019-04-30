
typedef struct Filter {
    int number;
    struct Filter *next;
    struct Filter *last;
} FilterType;

FilterType* newFilter(int n);
void releaseFilter(FilterType* filter);
int acceptAndAdd(FilterType* filter, int n);
