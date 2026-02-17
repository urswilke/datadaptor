# Multiply repetitive parts of command blocks using curly braces

This function turns the first line of command blocks of the "Free"
sheets into multiple by replacing the curly braces by each of the parts
inside (separated by spaces). This can help to save yourself from
repetitive writing without diving into something like regular
expressions.

## Usage

``` r
curlychop(df_free_raw)
```

## Arguments

- df_free_raw:

  code blocks read in by `mapp_free_sheet_cmd_table_raw()`

## Value

Dataframe containing multiple code blocks. The number of returned code
blocks corresponds to the number of space separated parts in the curly
brackets. The part embraced by the curly braces of the initial code
block is replaced by each of the space separated parts.

## Examples

``` r
# Minimal example:
df_curly <- data.frame(
  X1 = "#IF",
  X2 = "q{2 3} == 1",
  X3 = "kq{5 6} = {7 8}",
  X4 = NA_character_,
  row = "1"
)
df_curly
#>    X1          X2              X3   X4 row
#> 1 #IF q{2 3} == 1 kq{5 6} = {7 8} <NA>   1
curlychop(df_curly)
#> # A tibble: 2 × 6
#>   X1    X2      X3      X4    row   raw_index
#>   <chr> <chr>   <chr>   <chr> <chr>     <int>
#> 1 #IF   q2 == 1 kq5 = 7 NA    1_1           1
#> 2 #IF   q3 == 1 kq6 = 8 NA    1_2           1
```
