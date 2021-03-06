package main



import (
  "fmt"
  "math"
  "time"
)

func natural() func() int {
  i := 1
  return func() int {
    i++
    return i
  }
}

type Filter struct {
  number int
  next* Filter
  last* Filter
}

func (this *Filter) acceptAndAdd(n int) bool {
  filter := this;
  sqrt := int(math.Sqrt(float64(n)));
  for {
      if n % filter.number == 0 {
          return false;
      }
      if filter.number > sqrt {
          break;
      }
      filter = filter.next;
  }
  newFilter := &Filter{ n, nil, nil }
  this.last.next = newFilter
  this.last = newFilter
  return true
}

type Primes struct {
  natural func() int
  filter *Filter
}

func primes(natural func() int) Primes {
    return Primes{ natural, nil }
}

func (this *Primes) next() int {
    for {
        n := this.natural();
        if (this.filter == nil) {
            this.filter = &Filter{ n, nil, nil }
            this.filter.last = this.filter
            return n;
        }
        if (this.filter.acceptAndAdd(n)) {
            return n;
        }
    }
};


func measure(prntCnt int, upto int) int64 {
    primes := primes(natural());

    start := time.Now().UnixNano() / int64(time.Millisecond)
    cnt := 0;
    for {
        res := primes.next();
        cnt++;
        if (cnt % prntCnt == 0) {
            now := time.Now().UnixNano() / int64(time.Millisecond)
            took := now - start
            fmt.Printf("Computed %d primes in %d ms. Last one is %d\n", cnt, took, res)
            prntCnt *= 2
        }
        if (cnt >= upto) {
            break
        }
    }
    now := time.Now().UnixNano() / int64(time.Millisecond)
    return now - start
}


func main() {
    for {
      fmt.Printf("Hundred thousand prime numbers in %d ms\n", measure(97, 100000))
    }
}

