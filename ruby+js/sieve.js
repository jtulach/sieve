function Filter(number, filter) {
    this.number = number;
    this.filter = filter;
}
Filter.prototype.accept = function(n) {
  var filter = this;
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

function Primes(natural) {
    this.natural = natural;
    this.filter = null;
}
Primes.prototype.next = function() {
    for (;;) {
        var n = this.natural.next();
        if (this.filter === null || this.filter.accept(n)) {
            this.filter = new Filter(n, this.filter);
            return n;
        }
    }
};

function measure(prntCnt, upto) {
    var natural = Interop.import('Natural');
    var primes = new Primes(Interop.execute(natural));
    
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
