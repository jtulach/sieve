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
        int cnt = Integer.MAX_VALUE;
        if (args.length == 1) {
            cnt = Integer.parseInt(args[0]);
        }
        while (cnt-- > 0) {
            Primes p = new Primes() {
                @Override
                protected void log(String msg) {
                    System.out.println(msg);
                }
            };
            long start = System.currentTimeMillis();
            int value = p.compute();
            long took = System.currentTimeMillis() - start;
            System.out.println("Hundred thousand primes computed in " + took + " ms");
        }
    }
}
