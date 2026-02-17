# Generate data counts table

Generate data counts table

## Usage

``` r
gen_data_table(df, values_drop_na = FALSE)
```

## Arguments

- df:

  dataframe

- values_drop_na:

  remove missing values? (passed to
  [`tidyr::pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html).)

## Value

Counts and labels data frame

## Examples

``` r
gen_data_table(mtcars_labelled)
#> # A tibble: 237 × 7
#>    var   double character  Freq vallab type   varlab
#>    <chr>  <dbl> <chr>     <int> <chr>  <chr>  <chr> 
#>  1 id         1 NA            1 NA     double ""    
#>  2 id         2 NA            1 NA     double ""    
#>  3 id         3 NA            1 NA     double ""    
#>  4 id         4 NA            1 NA     double ""    
#>  5 id         5 NA            1 NA     double ""    
#>  6 id         6 NA            1 NA     double ""    
#>  7 id         7 NA            1 NA     double ""    
#>  8 id         8 NA            1 NA     double ""    
#>  9 id         9 NA            1 NA     double ""    
#> 10 id        10 NA            1 NA     double ""    
#> # ℹ 227 more rows
```
