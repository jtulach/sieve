function Primes(natural) {
    this.natural = natural;
    this.filter = null;
}
Primes.prototype.next = function() {
    for (;;) {
        var n = this.natural.next();
        if (this.filter === null) {
            var filterFactory = Polyglot.import("Filter");
            this.filter = filterFactory(n);
            return n;
        }
        if (this.filter.acceptAndAdd(n)) {
            return n;
        }
    }
};

function measure(prntCnt, upto) {
    var natural = Polyglot.import('Natural');
    var primes = new Primes(natural());

    var log = typeof console !== 'undefined' ? console.log : print;
    var start = new Date().getTime();
    var cnt = 0;
    var res = -1;
    for (;;) {
        res = primes.next();
        cnt++;
        if (cnt % prntCnt === 0) {
            log("Computed " + cnt + " primes in " + (new Date().getTime() - start) + " ms. Last one is " + res);
            prntCnt *= 2;
        }
        if (upto && cnt >= upto) {
            break;
        }
    }
    return new Date().getTime() - start;
}

for (;;) {
    var log = typeof console !== 'undefined' ? console.log : print;
    log("Hundred thousand prime numbers in " + measure(97, 100000) + " ms");
    if (typeof count !== 'undefined') {
        if (--count) {
            continue;
        }
        break;
    }
}
