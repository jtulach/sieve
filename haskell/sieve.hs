primes :: [Int]
primes = 2 : filter (prime primes) [3,5..] where
  prime (p:ps) n = p*p > n || rem n p /= 0 && prime ps n

main = do
    print "One hundred thousand prime number is"
    print $ last $ take 100000 primes
