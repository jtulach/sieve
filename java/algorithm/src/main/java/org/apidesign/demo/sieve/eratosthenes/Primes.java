package org.apidesign.demo.sieve.eratosthenes;

public abstract class Primes {
    private static final Primes INITIAL;
    static {
        class BuildTimePrimes extends Primes {
            @Override
            protected void log(String msg) {
            }
        }
        Primes p = new BuildTimePrimes();
        int last = ensureEnoughPrimes(40000, p);
        INITIAL = p;
        System.err.println("Prime numbers up to " + last + " are ready");
    }

    private static int ensureEnoughPrimes(double min, Primes p) {
        int last = 0;
        while (min > last) {
            last = p.next();
            System.err.println("  found next prime " + last);
        }
        return last;
    }

    private final Natural natural;
    private Filter filter;

    protected Primes() {
        this.natural = new Natural();
    }

    int next() {
        for (;;) {
            int n = natural.next();
            if (filter == null) {
                filter = new Filter(n);
                return n;
            }
            if (filter.acceptAndAdd(n)) {
                return n;
            }
        }
    }

    protected abstract void log(String msg);

    public final int compute() {
        long start = System.currentTimeMillis();
        int cnt = 0;
        int prntCnt = 97;
        int res;
        for (;;) {
            res = next();
            cnt += 1;
            if (cnt % prntCnt == 0) {
                log("Computed " + cnt + " primes in " + (System.currentTimeMillis() - start) + " ms. Last one is " + res);
                prntCnt *= 2;
            }
            if (cnt >= 100000) {
                break;
            }
        }
        return res;
    }

    public static void main(String... args) {
        int cnt = Integer.parseInt(args[0]);
        double maxTest = Math.sqrt(cnt);
        ensureEnoughPrimes(maxTest, INITIAL);

        if (INITIAL.filter.acceptAndAdd(cnt)) {
            System.out.println(cnt + " is prime");
        } else {
            System.out.println(cnt + " is not prime");
        }
    }
}
