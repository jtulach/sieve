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

echo -en 'travis_fold:start:c\\r'
make -C c
./c/sieve 25

(cd c; clang -c -emit-llvm *.c)
$GRAALBIN/lli --lib c/natural.bc --lib c/filter.bc --lib c/primes.bc c/main.bc 25
echo -en 'travis_fold:end:c\\r'

echo -en 'travis_fold:start:java\\r'
mvn -q -f java/pom.xml clean install
mvn -q -f java/algorithm/pom.xml exec:java -Drepeat=25
JAVA_HOME=$1 mvn -q -f java/algorithm/pom.xml exec:java -Drepeat=25
if [ "x" != "x$DISPLAY" ]; then
    mvn -q -f java/client/pom.xml exec:exec -Drepeat=5
fi
echo -en 'travis_fold:end:java\\r'

echo -en 'travis_fold:start:R\\r'
ginstall R
$GRAALBIN/polyglot --jvm --eval "js:count=25" --file R+js/sieve.R --file R+js/sieve.js
echo -en 'travis_fold:end:R\\r'

echo -en 'travis_fold:start:ruby\\r'
ginstall ruby
JAVA_HOME=$1 mvn -q clean package exec:exec -f ruby+js/fromjava/pom.xml -Drepeat=25
$GRAALBIN/ruby ruby/sieve.rb 25
echo -en 'travis_fold:end:ruby\\r'

echo -en 'travis_fold:start:js\\r'
$GRAALBIN/node js/sieve.js 15
mvn -q -f js/fromjava/pom.xml package exec:exec -Drepeat=15
JAVA_HOME=$1 mvn -q -f js/fromjava/pom.xml package exec:exec -Drepeat=15
echo -en 'travis_fold:end:js\\r'

echo -en 'travis_fold:start:python\\r'
ginstall python
$GRAALBIN/graalpython python/sieve.py 15
echo -en 'travis_fold:end:python\\r'

echo -en 'travis_fold:start:polyglot\\r'
$GRAALBIN/polyglot --jvm --file ruby+js/sieve.rb --eval js:count=15 --file ruby+js/sieve.js
if [ -n "$REBUILD" ]; then
  ginstall native-image
  $GRAALBIN/gu rebuild-images polyglot
fi
if $GRAALBIN/polyglot --version:graalvm | grep -i Ruby; then
  $GRAALBIN/polyglot --file ruby+js/sieve.rb --eval js:count=15 --file ruby+js/sieve.js
fi
echo -en 'travis_fold:end:polyglot\\r'
