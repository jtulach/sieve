import math
import time

class Natural:
    n = 2

    def next(self):
        r = self.n
        self.n = self.n + 1
        return r

class Filter:
    def __init__(self, n):
        self.number = n
        self.next = None
        self.last = self

    def acceptAndAdd(self, n):
        filter = self
        sqrt = math.sqrt(n)
        while True:
            if n % filter.number == 0:
                return False
            if filter.number > sqrt:
                break
            filter = filter.next

        newFilter = Filter(n)
        self.last.next = newFilter
        self.last = newFilter
        return True

class Primes:
    def __init__(self, natural):
        self.natural = natural
        self.filter = None

    def next(self):
        while True:
            n = self.natural.next()
            if (self.filter == None):
                self.filter = Filter(n)
                return n
            if (self.filter.acceptAndAdd(n)):
                return n

def ms(s):
    ms = math.floor(s * 1000)
    return str(ms / 1000)

def measure(prntCnt, upto):
    primes = Primes(Natural())
    start = time.time()
    cnt = 0
    res = -1
    while cnt < upto:
        res = primes.next()
        cnt = cnt + 1
        if (cnt % prntCnt == 0):
            took = time.time() - start
            print("Computed " + str(cnt) + " primes in " + ms(took) + "s. Last one is " + str(res))
            prntCnt = prntCnt * 2

    return time.time() - start

while True:
    took= measure(97, 100000)
    print("Hundred thousand prime numbers in " + ms(took) + "s")

