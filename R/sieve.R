isprime <- function(num, primes, primes.length) {
  for (i in 1:primes.length) {
    if (num %% primes[i] == 0) return(FALSE);
  }
  TRUE
};

findfirst <- function(fun, start) {
  i <- start
  while (TRUE) {
    if (fun(i)) return(i)
    i <- i + 1
  }
};

sieve <- function(primeAt) {
  primes <- rep(2L, primeAt)
  for (at in 2:primeAt) {
    num <- primes[[at-1]]+1
    primes[[at]] <- findfirst(function(x) isprime(x, primes, at-1L), num+1L);
  }
  cat("Result", primes[[primeAt]], "\n");
  primes[[primeAt]]
};

s <- function(x) system.time(x)
for (i in 1:1000) {
    t <- s(sieve(5000L));
    cat("Took", round(t[1] * 1000), "ms\n");
}
