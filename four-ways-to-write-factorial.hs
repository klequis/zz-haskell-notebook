-- factorial with if then else

fa :: (Eq a, Num a) => a -> a
fa x = if x == 1 then 1 else x * fa (x - 1)

-- factorial with pattern matching

fa2 :: (Eq a, Num a) => a -> a
fa2 1 = 1
fa2 x = x * fa2 (x - 1)


-- factorial with case of

fa3 :: (Eq a, Num a) => a -> a
fa3 x = case x of
    1 -> 1
    _ -> x * fa3 (x - 1)


-- factorial with guards

fa4 :: (Eq a, Num a) => a -> a
fa4 x
    | x == 1  = 1
    | otherwise = x * fa4 (x - 1)
