# Sieves of Eratosthenes in Many Languages

Implementing the sieve of Eratosthenes in various languages to demonstrate power of GraalVM and Truffle. Please download [GraalVM](http://www.oracle.com/technetwork/oracle-labs/program-languages/overview/index.html) before proceeding with experiments.

# Ruby Speed

Use following commands to find out that GraalVM Ruby is ten time faster than any other one. The program computes first few thousands of prime numbers using the [Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) algorithm. It repeats the computation in an endless loop to simulate long running process and give GraalVM Ruby time to warm up and optimize.

```bash
$ ruby ruby/sieve.rb
$ graalvm/bin/ruby ruby/sieve.rb
```

MRI Ruby starts fast and then gets slow. GraalVM has long initialization period, but once it is running, it is faster. After few iterations it gets about 10x faster than regular Ruby installed on my Ubuntu. Regular Ruby needs 16s to compute 5000 primes. GraalVM Ruby at the end needs 1600ms.
