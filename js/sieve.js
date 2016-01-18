function Natural() {
    x = 2;
    return {
        'next' : function() { return x++; }
    };
};

function Filter(number, filter) {
    var self = this;
    this.number = number;
    this.filter = filter;
    this.accept = function(n) {
      var filter = self;
      for (;;) {
          if (n % filter.number === 0) {
              return false;
          }
          filter = filter.filter;
          if (filter === null) {
              break;
          }
      }
      return true;
    };
    return this;
}

function Primes(natural) {
    var self = this;
    this.natural = natural;
    this.filter = null;

    this.next = function() {
        for (;;) {
            var n = self.natural.next();
            if (self.filter === null || self.filter.accept(n)) {
                self.filter = new Filter(n, self.filter);
                return n;
            }
        }
    };
}

function measure(prntCnt, upto) {
    var primes = new Primes(Natural());

    var log = typeof console !== 'undefined' ? console.log : print;
    var start = new Date().getTime();
    var cnt = 0;
    var res = -1;
    for (;;) {
        res = primes.next();
        cnt++;
        if (cnt % prntCnt === 0) {
            log("Computed " + cnt + " primes in " + (new Date().getTime() - start) + " ms. Last one is " + res);
        }
        if (upto && cnt >= upto) {
            break;
        }
    }
    return new Date().getTime() - start;
}

for (;;) {
    var log = typeof console !== 'undefined' ? console.log : print;
    log("Five thousand prime numbers in " + measure(1000, 5000) + " ms");
}
