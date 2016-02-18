package org.apidesign.demo.sieve.eratosthenes;

public abstract class Primes {
    private final Natural natural;
    private Filter filter;

    protected Primes() {
        this.natural = new Natural();
    }

    int next() {
        for (;;) {
            int n = natural.next();
            if (filter == null || filter.accept(n)) {
                filter = new Filter(n, filter);
                return n;
            }
        }
    }

    protected abstract void log(String msg);

    public final int compute() {
        long start = System.currentTimeMillis();
        int cnt = 0;
        int res;
        for (;;) {
            res = next();
            cnt += 1;
            if (cnt % 1000 == 0) {
                log("Computed " + cnt + " primes in " + (System.currentTimeMillis() - start) + " ms. Last one is " + res);
            }
            if (cnt >= 5000) {
                break;
            }
        }
        return res;
    }

    public static void main(String... args) {
        for (;;) {
            Primes p = new Primes() {
                @Override
                protected void log(String msg) {
                    System.out.println(msg);
                }
            };
            long start = System.currentTimeMillis();
            int value = p.compute();
            long took = System.currentTimeMillis() - start;
            System.out.println("Five thousands primes computed in " + took + " ms");
        }
    }
}
