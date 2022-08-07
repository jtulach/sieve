module Filter (
    FingerTree,
    emptyTree,
    acceptAndAdd,
) where

data FingerTree a =
    Empty |
    Single a |
    Deep (Digit a) (FingerTree (Node a)) (Digit a)
    deriving (Show)

data Digit a =
    One a |
    Two a a |
    Three a a a |
    Four a a a a
    deriving (Show)

fromdigit :: Digit a -> [a]
fromdigit (One x) = [x]
fromdigit (Two x y) = [x, y]
fromdigit (Three x y z) = [x, y, z]
fromdigit (Four x y z v) = [x, y, z, v]

data Node a =
    Node2 a a |
    Node3 a a a
    deriving (Show)

fromnode :: Node a -> [a]
fromnode (Node2 x y) = [x, y]
fromnode (Node3 x y z) = [x, y, z]

emptyTree :: FingerTree a
emptyTree = Empty

append :: a -> FingerTree a -> FingerTree a
append x Empty = Single x
append x (Single e) = Deep (One e) Empty (One x)
append x (Deep p t a) = case a of
    One e -> Deep p t (Two e x)
    Two e1 e2 -> Deep p t (Three e1 e2 x)
    Three e1 e2 e3 -> Deep p t (Four e1 e2 e3 x)
    Four e1 e2 e3 e4 -> Deep p (append (Node3 e1 e2 e3) t) (Two e4 x)

aslist :: FingerTree a -> [a]
aslist Empty = []
aslist (Single e) = [e]
aslist (Deep p t a) = (fromdigit p) ++ (listofa t) ++ (fromdigit a)
    where
        listofnodes :: FingerTree (Node a) -> [Node a]
        listofnodes t = aslist t

        listoflista :: FingerTree (Node a) -> [[a]]
        listoflista t = map fromnode (listofnodes t)

        listofa :: FingerTree (Node a) -> [a]
        listofa t = foldr (++) [] (listoflista t)


acceptAndAdd :: Int -> FingerTree Int -> (Bool, FingerTree Int)
acceptAndAdd n t = checkandadd primesupto
    where
        upto = floor (sqrt (fromIntegral n)) + 1
        allprimes = aslist t
        primesupto = filter (\x -> x < upto) allprimes
        checkandadd :: [Int] -> (Bool, FingerTree Int)
        checkandadd [] = (True, append n t)
        checkandadd (h : r) = if rem n h == 0 then (False, t)
            else checkandadd r

