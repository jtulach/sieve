#!/bin/bash

if ! [ -e $1/bin/java ]; then
  echo Usage: $0 "<path_to_graalvm>"
  exit 1
fi

GRAALBIN=$1/bin

$GRAALBIN/ruby ruby/sieve.rb 25

