package org.apidesign.demo.sieve.js;

final class Filter {
    private final Integer number;
    private final Filter next;

    public Filter(int number, Filter next) {
        this.number = number;
        this.next = next;
    }

    public boolean accept(int n) {
        Filter filter = this;
        for (;;) {
            if (n % filter.number == 0) {
                return false;
            }
            filter = filter.next;
            if (filter == null) {
                return true;
            }
        }
    }
}
