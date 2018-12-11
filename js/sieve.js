function* natural() {
    var x = 2;
    while (true) {
        yield x++;
    }
}

function Filter(number) {
    this.number = number;
    this.next = null;
    this.last = this;
}
Filter.prototype.acceptAndAdd = function(n) {
  var filter = this;
  var sqrt = Math.sqrt(n);
  for (;;) {
      if (n % filter.number === 0) {
          return false;
      }
      if (filter.number > sqrt) {
          break;
      }
      filter = filter.next;
  }
  var newFilter = new Filter(n);
  this.last.next = newFilter;
  this.last = newFilter;
  return true;
};

function* primesIterator(natural) {
    var filter = null;
    for (var n of natural) {
        if (filter === null) {
            filter = new Filter(n);
            yield n;
        }
        if (filter.acceptAndAdd(n)) {
            yield n;
        }
    }
};

function measure(prntCnt, upto, log) {
    var primes = primesIterator(natural());

    var start = new Date().getTime();
    var cnt = 0;
    var res = -1;
    for (;;) {
        res = primes.next();
        cnt++;
        if (cnt % prntCnt === 0) {
            log("Computed " + cnt + " primes in " + (new Date().getTime() - start) + " ms. Last one is " + res.value);
            prntCnt *= 2;
        }
        if (upto && cnt >= upto) {
            break;
        }
    }
    return new Date().getTime() - start;
}

var log = typeof console !== 'undefined' ? console.log : (
    typeof println !== 'undefined' ? println : print
);
if (typeof count === 'undefined') {
    var count = 256 * 256;
    if (typeof process !== 'undefined' && process.argv.length === 3) {
      count = new Number(process.argv[2]);
    }
}
if (typeof setTimeout === 'undefined') {
    setTimeout = function(r) {
        r();
    };
}

function oneRound() {
    log("Hundred thousand prime numbers in " + measure(97, 100000) + " ms");
    if (count-- > 0) {
        setTimeout(oneRound, 50);
    }
}
setTimeout(oneRound, 50);
