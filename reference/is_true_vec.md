# Vectorized `isTRUE()`

Vectorized [`isTRUE()`](https://rdrr.io/r/base/Logic.html)

## Usage

``` r
is_true_vec(x)
```

## Arguments

- x:

  Logical vector

## Value

Logical vector that's TRUE if `x == TRUE` and `FALSE` if
`x == FALSE or NA`.

## Examples

``` r
is_true_vec(c(NA, TRUE, FALSE))
#> [1] FALSE  TRUE FALSE
```
