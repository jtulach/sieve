# Sieves of Eratosthenes in Many Languages

Implementing the sieve of Eratosthenes in various languages to demonstrate
power of GraalVM and Truffle. Please download
[GraalVM](http://www.oracle.com/technetwork/oracle-labs/program-languages/overview/index.html)
before proceeding with experiments. The [code in this repository](https://github.com/jtulach/sieve/)
has been tested to work with [GraalVM](http://graalvm.org)
version `1.0.0-rc2`.

[![Build Status](https://travis-ci.org/jtulach/sieve.svg?branch=master)](https://travis-ci.org/jtulach/sieve)

## Ruby Speed

Use following commands to find out that GraalVM Ruby is ten times faster than any other one.
The program computes first one hundred thousands of prime numbers using the
[Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) algorithm.
It repeats the computation in an endless loop to simulate long running process
and give **GraalVM Ruby** time to warm up and optimize.

```bash
$ ruby ruby/sieve.rb
$ graalvm/bin/ruby ruby/sieve.rb
```

MRI Ruby starts fast and then gets slow. GraalVM has long initialization period,
but once it is running, it is faster. After few iterations it gets about 10x faster
than regular Ruby installed on my Ubuntu. Regular Ruby needs more than 2s to
compute the primes. **GraalVM Ruby** at the end needs less than 150ms on my laptop.

## JavaScript

Of course, these days the most optimized dynamic language runtimes are for JavaScript, so shouldn't we rewrite our code to be faster? Yes, we can try that:

```bash
$ node js/sieve.js
$ graalvm/bin/node js/sieve.js
```

We can see that after few warm-up iterations both systems achieve similar
peek performance. On my computer one iteration takes around 130ms.
That is still faster than GraalVM Ruby, but only a bit (compared to
more than 20x to MRI - the standard Ruby implementation). Whether that justifies
rewriting whole application from one language to another depends on the actual
need for speed. Moreover there are better options...

## Spice Ruby with JavaScript

Rather than rewriting whole application into a new language, why not rewrite
just the critical parts? Let's keep the computation of natural numbers in Ruby
and do the sieve operations in JavaScript:

```bash
$ graalvm/bin/polyglot --file ruby+js/sieve.rb --file ruby+js/sieve.js
```

A combination of languages is hard to compare, as there is no other system that
could combine 100% language complete Ruby with 100% language complete JavaScript.
There are some transpilers of Ruby to JavaScript, but they are far from complete
and clearly they are obsolete - **GraalVM** can run the mixture of **Ruby** and **JavaScript**
as fast as optimized JavaScript only version.

## Can I add Java?

Those coming from a JavaScript or Ruby camp, interested only in the scripting
languages may stop reading now. The rest of us, who write or maintain application
in Java maybe asking: Should I rewrite my Java app to get this kind of interop?

No, there is no need! GraalVM is full featured Java VM compatible with the
most recent release of Java (you need [Maven](http://maven.apache.org) to proceed),
just try:

```bash
JAVA_HOME=graalvm mvn -q clean package exec:exec -f ruby+js/fromjava/pom.xml
```

Again, after few iterations the peak performance of the code is reached, but
this time it is embedded into a Java program. You can get all the speed of
Truffle from your Java applications, if you execute on top of GraalVM!

## Can I use Java Scripting API?

Of course, it is fair to ask whether, in order to use
[GraalVM](http://www.oracle.com/technetwork/oracle-labs/program-languages/overview/index.html)
one has to learn the special [Polyglot API](http://www.graalvm.org/truffle/javadoc/org/graalvm/polyglot/package-summary.html)?

If you are only interested in interop between Java and JavaScript, then you
don't have to! You can use the standard `ScriptEngineManager` search for
an engine named `Graal.js` and use it as you are used to. Here is an example:
```bash
mvn -f js/fromjava/pom.xml package exec:exec
```
The command can use regular HotSpot virtual machine and executes the `sieve.js`
script via its integrated `JavaScript` engine. Btw. the JDK's Nashorn can
compute the hundred thousand of prime numbers in 240ms on my computer.

Now run the same script with GraalVM:
```bash
JAVA_HOME=graalvm mvn -f js/fromjava/pom.xml package exec:exec
```
The same Java code, the same JavaScript file - and the performance? Less than
90ms on my computer!

## Is R slower than Ruby?

Now imagine you have even slower language than Ruby. Is it possible? Yes,
it is. Language like [R](https://en.wikipedia.org/wiki/R_%28programming_language%29) is even slower and yet very popular
(among statisticians). Nice thing is that it works primarily on vectors, so
we can generate the list of natural numbers as a simple ***[2:999999999]***
expression. Can Graal make that fast?

```bash
$ graalvm/bin/polyglot --jvm --file R+js/sieve.R --file R+js/sieve.js
```

JavaScript is accessing enormously huge vector from R (which is never really
created) and the speed is? Great! Within 10-20% of the fastest solution we have seen so far.

## Aren't These Scripting Languages Slower than Java?

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

## But Java cannot Run in a Browser!

That is not entirely true. The Apache
[HTML+Java API](http://bits.netbeans.org/html+java/) and
related projects gives us an easy way to run Java in a browser. Try it:

```bash
$ mvn -f java/pom.xml install
$ mvn -f java/client/pom.xml exec:exec -Drepeat=5
```

The same algorithm written in Java is executed and the result is displayed in an opened browser window.
Well, it is not really a browser, it is just an WebView component. But even that can be fixed! Try:

```bash
$ mvn -f java/pom.xml install
$ mvn -f java/client-web/pom.xml bck2brwsr:show
```

and now your *Java*(!) code runs in real browser.
Visit [DukeScript](https://dukescript.com/) project to learn more
about using Java in a browser.

And the speed? Amazing, code written in *Java* and transpilled to
*JavaScript* runs at most 50% slower than Java on classical JVM.

## Nothing Compares to C!

A friend of mine once asked: *"Nice, but if I write the code in C, then ..., right?"*
That forced me to sit down and write a
[C version of the sieve](c/main.c).
Indeed it is fast, but it is not really polyglot. Can we fix that?

GraalVM offers a way to *interpret* the **C** code with a
Truffle interpreter. Interpret **C**?
Isn't that going to be slow? No, not really,
if you use [Sulong](https://github.com/graalvm/sulong/) - an
[LLVM](http://llvm.org/) interpreter that is part of GraalVM.


Let's try to compare statically compiled C and Sulong speed:
```bash
$ make -C c
$ ./c/sieve
Hundred thousand prime numbers in 103 ms
```
it starts fast and runs fast. Now it's the Sulong's turn! We need an LLVM bitcode.
Get it from `clang` and then pass it to `lli` of GraalVM:
```bash
$ clang -c -emit-llvm -o c/sieve.bc c/main.c
$ graalvm/bin/lli c/sieve.bc
Hundred thousand prime numbers in 114 ms
```
The interpreted code isn't as fast as the native one, but it is not slow either.
Moreover there is a huge benefit - it can be easily mixed with other languages
without any slowdown common when crossing the language boundaries.

## Go with a Single File!

The are some good properties of the C solution. No need for virtual machine
overhead being one of them. Ability to generate single `sieve` file that
carries all the implementation being another. On the other hand, C isn't 
really type safe language and also doesn't offer any automatic memory 
management. Maybe we should try the Go language!? Or:

Can we generate a single, virtual machine less, self-contained file
with GraalVM? Yes, we can. There is a `native-image` command that
allows us to compile the `java/algorithm` project into a self contained binary:
```bash
$ JAVA_HOME=graalvm mvn -f java/algorithm -Psvm install
/sieve/java/algorithm/target/sieve:8297]      [total]:  36,794.95 ms
$ ls -lh java/algorithm/target/sieve
6,5M java/algorithm/target/sieve
$ java/algorithm/target/sieve
Hundred thousand primes computed in 95 ms
```
Not only one gets a self contained `sieve` executable of a reasonable (e.g. 7M)
size, but it is also fast and most of all, it doesn't need any warm up. It
is consistently fast since begining!

## Going Docker!

With a single self contained file created by `native-image` in previous
section, it is easy to join the cloud life style. A simple docker file
```docker
FROM alpine:3.6
COPY ./target/sieve /bin/sieve
CMD /bin/sieve
```
will create small (10MB) docker image with your sieve application.
The following commands do it on an Ubuntu Linux AMD64 box:
```bash
$ JAVA_HOME=graalvm mvn -f java/algorithm -Psvm install
$ docker build java/algorithm/
Step 1/3 : FROM alpine:3.6
Step 2/3 : COPY ./target/sieve /bin/sieve
Step 3/3 : CMD /bin/sieve
Successfully built a06b45ee7d68
$ docker run a06b45ee7d68
$ docker ps
$ docker kill d6ca88781a31
```
Your effective Java application has just gone to the cloud!

# Real Polyglot

Learn to use [GraalVM](http://www.oracle.com/technetwork/oracle-labs/program-languages/overview/index.html)
as then you become real polyglot: You'll be able to code in any dynamic language,
mix them together and even use Java whenever you want.
