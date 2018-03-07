#!/bin/bash

if ! [ -e $1/bin/java ]; then
  echo Usage: $0 "<path_to_graalvm>"
  exit 1
fi

GRAALBIN=$1/bin

$GRAALBIN/ruby ruby/sieve.rb 25
$GRAALBIN/node js/sieve.js 15
$GRAALBIN/graalpython python/sieve.js 15
$GRAALBIN/polyglot --file ruby+js/sieve.rb --eval js:count=15 --file ruby+js/sieve.js

