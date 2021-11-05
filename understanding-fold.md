The answers according to GHCi

```haskell
foldl (-) [1,2,3,4,5] = -15
foldr (-) [1,2,3,4,5] = 3
```

## Evaluating manually

- Each individual row evaluates to the correct answer
- Step by step evaluation results in the correct answer

**Left fold (`foldl`)**

```haskell
foldl (-) 0 [1,2,3,4,5] = -15
```

| eval                | result |
| ------------------- | ------ |
| ((((0-1)-2)-3)-4)-5 | -15    |
| (((-1-2)-3)-4)-5    | -15    |
| ((-3-3)-4)-5        | -15    |
| (-6-4)-5            | -15    |
| -10-5               | -15    |
| -15                 | -15    |

- The initial value of 0 is combined with the first element of the list

**Right fold (`foldr`)**

```haskell
foldr (-) 0 [1,2,3,4,5] = 3
```

| eval                | result |
| ------------------- | ------ |
| 1-(2-(3-(4-(5-0)))) | 3      |
| 1-(2-(3-(4-5)))     | 3      |
| 1-(2-(3-(-1)))      | 3      |
| 1-(2-4)             | 3      |
| 1-(-2)              | 3      |
| 3                   | 3      |

- The initial value of 0 is used when one reaches the end of the list

## Write you own fold functions

```haskell
foldR f z []     = z
foldR f z (x:xs) = f x (foldR f z xs)
```

- In foldR, x never chnages

```haskell
foldL f z []     = z
foldL f z (x:xs) = foldL f (f z x) xs
```

- In foldL, x is the lates value at each iteration. I.e., it changes

## Properties of `foldl` vs `foldr`

Given all of the above I still didn't feel in my gut I understood how folding worked. My original assumptions was that right & left in 'fold right' & 'fold left' was the direction direction the list was traversed. While questioning that I wondered if it were about the associativity instead. Then questioning if it were both seemed reasonable thing to do. The below experimentation seeks to determine the answer.

```haskell
foldL (-) 0 [1,2,3,4,5] = -15
foldR (-) 0 [1,2,3,4,5] = 3
```

| sequence    | assoc | bracketing          | result |     |
| ----------- | ----- | ------------------- | ------ | --- |
| 1,2,3,4,5,0 | left  | ((((1-2)-3)-4)-5)-0 | -13    |     |
| 1,2,3,4,5,0 | right | 1-(2-(3-(4-(5-0)))) | 3      | ✅  |
| 0,1,2,3,4,5 | left  | ((((0-1)-2)-3)-4)-5 | -15    | ✅  |
| 0,1,2,3,4,5 | right | 0-(1-(2-(3-(4-5)))) | -3     |     |
| 5,4,3,2,1,0 | left  | ((((5-4)-3)-2)-1)-0 | -5     |     |
| 5,4,3,2,1,0 | right | 5-(4-(3-(2-(1-0)))) | 3      | ✅  |
| 0,5,4,3,2,1 | left  | ((((0-5)-4)-3)-2)-1 | -15    | ✅  |
| 0,5,4,3,2,1 | right | 0-(5-(4-(3-(2-1)))) | -3     |     |

Consolidating the correct results makes things a bit clearer

**`foldl`**

| sequence    | assoc | bracketing          | result |
| ----------- | ----- | ------------------- | ------ |
| 0,1,2,3,4,5 | left  | ((((0-1)-2)-3)-4)-5 | -15    |
| 0,5,4,3,2,1 | left  | ((((0-5)-4)-3)-2)-1 | -15    |

**`foldr`**

| sequence    | assoc | bracketing          | result |
| ----------- | ----- | ------------------- | ------ |
| 1,2,3,4,5,0 | right | 1-(2-(3-(4-(5-0)))) | 3      |
| 5,4,3,2,1,0 | right | 5-(4-(3-(2-(1-0)))) | 3      |

From this the following properties can be determined

| fold  | associtivity | of init val  | sequence |
| ----- | ------------ | ------------ | -------- |
| left  | always left  | always left  | either   |
| right | always right | always right | either   |

Or in words, for left fold (`foldl`):

- _associtivity_ is left always
- the _initial value_ is used at the left/begining of the sequence

And for right fold (`foldr`)

- \_associativity is right always
- the _initial value_ is used at the right/end of the sequence

And for both left and right

- the elements of the array can be used from `left to right` or `right to left`

So the answers to the original question is:

- The direction the list was traversed doesn't matter
- Associativity is essential
- And while not in the original question, the placement of the initial value is also essential.

---

## Reference:

- https://wiki.haskell.org/Fold
- https://en.wikipedia.org/wiki/Fold_%28higher-order_function%29
