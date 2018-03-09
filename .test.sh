#!/bin/bash -x

set -e

if ! [ -e $1/bin/java ]; then
  echo Usage: $0 "<path_to_graalvm>"
  exit 1
fi

GRAALBIN=$1/bin

$GRAALBIN/polyglot --jvm --eval "js:count=25" --file R+js/sieve.R --file R+js/sieve.js

JAVA_HOME=$1 mvn -q clean package exec:exec -f ruby+js/fromjava/pom.xml -Drepeat=25
$GRAALBIN/ruby ruby/sieve.rb 25

$GRAALBIN/node js/sieve.js 15
mvn -q -f js/fromjava/pom.xml package exec:exec -Drepeat=15
JAVA_HOME=$1 mvn -q -f js/fromjava/pom.xml package exec:exec -Drepeat=15

$GRAALBIN/graalpython python/sieve.js 15

$GRAALBIN/polyglot --file ruby+js/sieve.rb --eval js:count=15 --file ruby+js/sieve.js

