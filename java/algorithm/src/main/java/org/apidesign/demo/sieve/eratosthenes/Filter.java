package org.apidesign.demo.sieve.eratosthenes;

final class Filter {
    private final int number;
    private Filter next;
    private Filter last;

    public Filter(int number) {
        this.number = number;
        this.last = this;
    }

    public boolean acceptAndAdd(int n) {
        Filter filter = this;
        double upto = Math.sqrt(n);
        for (;;) {
            if (n % filter.number == 0) {
                return false;
            }
            if (filter.number > upto) {
                final Filter newFilter = new Filter(n);
                last.next = newFilter;
                last = newFilter;
                return true;
            }
            filter = filter.next;
        }
    }
}
