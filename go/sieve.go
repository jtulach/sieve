package main



import (
  "fmt"
  "math"
  "time"
)

func natural(numbers chan int) {
  i := 2;
  for {
    numbers <- i
    i++
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

func primes(naturalNumbers chan int, primeNumbers chan int) {
    var filter *Filter
    filter = nil
    for {
        n := <- naturalNumbers;
        if (filter == nil) {
            filter = &Filter{ n, nil, nil }
            filter.last = filter
            primeNumbers <- n;
        }
        if (filter.acceptAndAdd(n)) {
            primeNumbers <- n;
        }
    }
};


func measure(prntCnt int, upto int) int64 {
    naturalNumbers := make(chan int)

    go natural(naturalNumbers)

    primeNumbers := make(chan int)

    go primes(naturalNumbers, primeNumbers)

    start := time.Now().UnixNano() / int64(time.Millisecond)
    cnt := 0;
    for {
        res := <- primeNumbers;
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

