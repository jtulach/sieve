-module(sieve).
-export([mainLoop/0]).

natural() -> #{ "n" => 2 }.
natural(#{ "n" := N }) ->
    { N, #{ "n" => N + 1 } }.


filterAndAdd(N, []) ->
    { true, [ N ] };
filterAndAdd(N, [ [H | T1 ] | T2]) ->
    SortedPrimes = movePrimes([H | T1], [], T2),
    filterAndAdd(N, SortedPrimes);
filterAndAdd(N, [H | T]) when N rem H == 0 ->
    { false, [ H | T ] };
filterAndAdd(N, [H | T]) when N < H * H ->
    { true, [H | insertPrimes(N, T) ]};
filterAndAdd(N, [H | T]) ->
    { R, L } = filterAndAdd(N, T),
    { R, [ H | L ]}.

insertPrimes(N, []) -> [ N ];
insertPrimes(N, [ [ H | T1] | T2 ]) -> [ [ N, H | T1 ] | T2 ];
insertPrimes(N, [ H | T2 ]) -> [ [ N ], H | T2 ].

movePrimes([], Reversed, []) -> Reversed;
movePrimes(Primes, Reversed, [H | T]) -> [H | movePrimes(Primes, Reversed, T)];
movePrimes([H | T], Reversed, []) -> movePrimes(T, [ H | Reversed ], []).

sieve(Iterator, Primes) ->
    { N, Next } = natural(Iterator),
    { R, NewPrimes } = filterAndAdd(N, Primes),
    if
        R -> { NewPrimes , Next };
        true -> sieve(Next, Primes)
    end.

hundredthousand() ->
    last(hundredthousand(100000, natural(), [])).

last([ H ]) -> H;
last([ [ H | T1 ] | T2 ]) ->
    SortedPrimes = movePrimes([H | T1], [], T2),
    last(SortedPrimes);
last([ _ | T ]) -> last(T).

hundredthousand(0, _, Primes) ->
    Primes;
hundredthousand(Count, Iterator, Primes) ->
    {NewPrimes, NewIterator} = sieve(Iterator, Primes),
    hundredthousand(Count - 1, NewIterator, NewPrimes).

mainLoop() ->
    Then = erlang:system_time(),
    Result = hundredthousand(),
    Now = erlang:system_time(),
    io:fwrite("Computed ~w in ~w ms~n", [Result, round((Now - Then) / 1000000) ]),
    mainLoop().
