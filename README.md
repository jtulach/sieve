# Sieves of Eratosthenes in Many Languages

Implementing the sieve of Eratosthenes in various languages to demonstrate power of GraalVM and Truffle. Please download [GraalVM](http://www.oracle.com/technetwork/oracle-labs/program-languages/overview/index.html) before proceeding with experiments.

# Ruby Speed

Use following commands to find out that GraalVM Ruby is ten times faster than any other one. The program computes first few thousands of prime numbers using the [Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) algorithm. It repeats the computation in an endless loop to simulate long running process and give GraalVM Ruby time to warm up and optimize.

```bash
$ ruby ruby/sieve.rb
$ graalvm/bin/ruby ruby/sieve.rb
```

MRI Ruby starts fast and then gets slow. GraalVM has long initialization period, but once it is running, it is faster. After few iterations it gets about 10x faster than regular Ruby installed on my Ubuntu. Regular Ruby needs 16s to compute 5000 primes. GraalVM Ruby at the end needs 1600ms.

# JavaScript

Of course, these days the most optimized dynamic language runtimes are for JavaScript, so shouldn't we rewrite our code to be faster? Yes, we can try that:

```bash
$ node js/sieve.js
$ graalvm/bin/node js/sieve.js
```

We can see that after few warm-up iterations both systems achieve similar peek performance. On my computer one iteration takes around 500ms. That is still faster than GraalVM Ruby, but only three times (compared to more than 30x to MRI). Whether that justifies rewriting whole application from one language to another depends on the actual need for speed. Moreover there are better options...

# Spice Ruby with JavaScript

Rather than rewriting whole application into a new language, why not rewrite
just the critical parts? Let's keep the computation of natural numbers in Ruby
and do the sieve operations in JavaScript:

```bash
$ graalvm/bin/graalvm ruby+js/sieve.rb ruby+js/sieve.js
```

A combination of languages is hard to compare, as there is no other system that
could combine 100% language complete Ruby with 100% language complete JavaScript.
There are some transpilers of Ruby to JavaScript, but they are far from complete
and clearly they are obsolete - GraalVM can run the mixture of Ruby and JavaScript
as fast as optimized JavaScript only version.

