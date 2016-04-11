natural <- seq(2,999999);

sieve <- function(numbers, at, primeAt) {
  if (sqrt(primeAt) < at) {
    result <- numbers[primeAt];
    cat("Result", result, "\n");
  } else {
    diff <- setdiff(numbers, numbers[at] * natural);
    result <- sieve(diff, at + 1, primeAt);
  }
  result;
};

s <- function(x) system.time(x)
for (i in 1:1000) {
    t <- s(sieve(natural, 1, 5000));
    cat("Took", round(t[1] * 1000), "ms\n");
}
