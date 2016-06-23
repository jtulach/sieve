# Sieves of Eratosthenes in Many Languages

Implementing the sieve of Eratosthenes in various languages to demonstrate power of GraalVM and Truffle. Please download [GraalVM](http://www.oracle.com/technetwork/oracle-labs/program-languages/overview/index.html) before proceeding with experiments. The [code in this repository](https://github.com/jtulach/sieve/) has been tested to work with [GraalVM](http://www.oracle.com/technetwork/oracle-labs/program-languages/overview/index.html) version 0.12.

# Ruby Speed

Use following commands to find out that GraalVM Ruby is ten times faster than any other one. The program computes first one hundred thousands of prime numbers using the [Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) algorithm. It repeats the computation in an endless loop to simulate long running process and give **GraalVM Ruby** time to warm up and optimize.

```bash
$ ruby ruby/sieve.rb
$ graalvm/bin/ruby ruby/sieve.rb
```

MRI Ruby starts fast and then gets slow. GraalVM has long initialization period, but once it is running, it is faster. After few iterations it gets about 10x faster than regular Ruby installed on my Ubuntu. Regular Ruby needs more than 2s to compute the primes. **GraalVM Ruby** at the end needs less than 150ms on my laptop.

# JavaScript

Of course, these days the most optimized dynamic language runtimes are for JavaScript, so shouldn't we rewrite our code to be faster? Yes, we can try that:

```bash
$ node js/sieve.js
$ graalvm/bin/node js/sieve.js
```

We can see that after few warm-up iterations both systems achieve similar peek performance. On my computer one iteration takes around 130ms. That is still faster than GraalVM Ruby, but only a bit (compared to more than 20x to MRI - the standard Ruby implementation). Whether that justifies rewriting whole application from one language to another depends on the actual need for speed. Moreover there are better options...

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
and clearly they are obsolete - **GraalVM** can run the mixture of **Ruby** and **JavaScript**
as fast as optimized JavaScript only version.

# Can I add Java?

Those coming from a JavaScript or Ruby camp, interested only in the scripting
languages may stop reading now. The rest of us, who write or maintain application
in Java maybe asking: Should I rewrite my Java app to get this kind of interop?

No, there is no need! GraalVM is full featured Java VM compatible with the
most recent release of Java (you need [Maven](http://maven.apache.org) to proceed),
just try:

```bash
JAVA_HOME=graalvm mvn -f ruby+js/fromjava/pom.xml package exec:exec
```

Again, after few iterations the peak performance of the code is reached, but
this time it is embedded into a Java program. You can get all the speed of
Truffle from your Java applications, if you execute on top of GraalVM!

# Is R slower than Ruby?

Now imagine you have even slower language than Ruby. Is it possible? Yes,
it is. Language like [R](https://en.wikipedia.org/wiki/R_%28programming_language%29) is even slower and yet very popular
(among statisticians). Nice thing is that it works primarily on vectors, so
we can generate the list of natural numbers as a simple ***[2:999999999]***
expression. Can Graal make that fast?

```bash
$ graalvm/bin/graalvm R+js/sieve.R R+js/sieve.js
```

JavaScript is accessing enormously huge vector from R (which is never really
created) and the speed is? Great! Within 10-20% of the fastest solution we have seen so far.

# Aren't These Scripting Languages Slower than Java?

We have seen that with **Truffle** almost any language is almost as fast as the fastest
implementation of *JavaScript*. But what about *Java*? Isn't it supposed to be
faster? Yes, it is. Try:

```bash
$ mvn -f java/pom.xml install
$ mvn -f java/algorithm/pom.xml exec:java
```

and you can see that *Java* is really fast. On my computer it takes something
like 100ms to finish one iteration. However we can be even faster! How?
Let's just switch to the **GraalVM** and use it instead of the regular one:

```bash
$ mvn -f java/pom.xml install
$ JAVA_HOME=graalvm mvn -f java/algorithm/pom.xml exec:java
```

One iteration of the sieve of Eratosthenes algorithm now runs in less than
90ms on my computer. **GraalVM** rules!
