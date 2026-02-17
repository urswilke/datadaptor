# Apply function on the subset of arguments it knows

This function will execute the function `f` on the subset of the names
of `l` which are in the formal arguments of `f`.

## Usage

``` r
use_known_args(f, l)
```

## Arguments

- f:

  function

- l:

  named list of arguments

## Value

f applied on the subset of l

## Examples

``` r
use_known_args(mean, list(x = 2, r = 3))
#> [1] 2
```
