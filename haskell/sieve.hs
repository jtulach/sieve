import Filter (FingerTree, emptyTree, acceptAndAdd)

natural :: [Int]
natural = [2..]

primes :: FingerTree Int -> [Int] -> [Int]
primes t (n : r) = if found then (n : primes nt r) else primes t r
    where
        (found, nt) = acceptAndAdd n t
primes _ [] = []

main = print $ length (take 10000 (primes emptyTree natural))

