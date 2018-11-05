#!/bin/bash -x

set -e

if ! [ -e $1/bin/java ]; then
  echo Usage: $0 "<path_to_graalvm>"
  exit 1
fi

GRAALBIN=$1/bin

function ginstall() {
  if [ -e $GRAALBIN/gu ]; then
    if $GRAALBIN/gu list | grep "^$1 "; then
      echo $1 is installed
    else
      $GRAALBIN/gu install $1
      REBUILD=true
    fi
  fi
}

make -C c
./c/sieve 25

clang -c -emit-llvm -o c/sieve.bc c/main.c
$GRAALBIN/lli c/sieve.bc 25

mvn -q -f java/pom.xml clean install
mvn -q -f java/algorithm/pom.xml exec:java -Drepeat=25
JAVA_HOME=$1 mvn -q -f java/algorithm/pom.xml exec:java -Drepeat=25
if [ "x" != "x$DISPLAY" ]; then
    mvn -q -f java/client/pom.xml exec:exec -Drepeat=5
fi

ginstall R

$GRAALBIN/polyglot --jvm --eval "js:count=25" --file R+js/sieve.R --file R+js/sieve.js

ginstall ruby

JAVA_HOME=$1 mvn -q clean package exec:exec -f ruby+js/fromjava/pom.xml -Drepeat=25
$GRAALBIN/ruby ruby/sieve.rb 25

$GRAALBIN/node js/sieve.js 15
mvn -q -f js/fromjava/pom.xml package exec:exec -Drepeat=15
JAVA_HOME=$1 mvn -q -f js/fromjava/pom.xml package exec:exec -Drepeat=15

ginstall python

$GRAALBIN/graalpython python/sieve.py 15

if [ -n "$REBUILD" ]; then
  $GRAALBIN/gu rebuild-images polyglot
fi

$GRAALBIN/polyglot --file ruby+js/sieve.rb --eval js:count=15 --file ruby+js/sieve.js

