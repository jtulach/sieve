package org.apidesign.demo.sieve.eratosthenes;

public open class Primes {
    private val natural: Natural;
    private var filter: Filter? = null;

    constructor() {
        this.natural = Natural();
    }

    fun next(): Int {
        while (true) {
            val n = natural.next();
            val f = filter;
            if (f == null) {
                filter = Filter(n);
                return n;
            }
            if (f.acceptAndAdd(n)) {
                return n;
            }
        }
    }

    protected open fun log(msg : String) {
        System.out.println(msg);
    }

    public final fun compute(): Int {
        var start = System.currentTimeMillis();
        var cnt = 0;
        var prntCnt = 97;
        var res = 0;
        while (true) {
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

}



fun main(args: Array<String>) {
    var cnt = Integer.MAX_VALUE;
    if (args.size == 1) {
        cnt = Integer.parseInt(args[0]);
    }
    while (cnt-- > 0) {
        val p = Primes();
        val start = System.currentTimeMillis();
        val value = p.compute();
        val took = System.currentTimeMillis() - start;
        System.out.println("Hundred thousand primes computed in " + took + " ms");
    }
}
