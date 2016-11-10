-module(sieve).
-export([hundredthousand/0,sieve/2,natural/0,natural/1,filterAndAdd/2]).

natural() -> #{ "n" => 2 }.
natural(#{ "n" := N }) ->
    { N, #{ "n" => N + 1 } }.


filterAndAdd(N, []) ->
    { true, [ N ] };
filterAndAdd(N, [H | T]) when N rem H == 0 ->
    { false, [ H | T ] };
filterAndAdd(N, [H | T]) ->
    { R, L } = filterAndAdd(N, T),
    { R, [ H | L ]}.

sieve(Iterator, Primes) ->
    { N, Next } = natural(Iterator),
    { R, NewPrimes } = filterAndAdd(N, Primes),
    if
        R -> { NewPrimes , Next };
        true -> sieve(Next, Primes)
    end.

hundredthousand() ->
    hundredthousand(100000, natural(), []).

hundredthousand(0, _, Primes) ->
    Primes;
hundredthousand(Count, Iterator, Primes) ->
    {NewPrimes, NewIterator} = sieve(Iterator, Primes),
    hundredthousand(Count - 1, NewIterator, NewPrimes).
