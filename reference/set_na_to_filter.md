# Replace NA values by `miss_rec_val` labelled by `miss_rec_lab`

Replace NA values by `miss_rec_val` labelled by `miss_rec_lab`

## Usage

``` r
set_na_to_filter(x, miss_rec_val = -2, miss_rec_lab = "FILTER")
```

## Arguments

- x:

  numeric variable

- miss_rec_val:

  numeric value, NAs are replaced by; defaults to -2

- miss_rec_lab:

  character value, value label `miss_rec_val` will be labelled by;
  defaults to "FILTER"

## Value

`x` where NAs are replaced by `miss_rec_val` with added label
`miss_rec_lab`

## Examples

``` r
x <- haven::labelled(c(1, NA), labels = c("value label of 1" = 1))
x
#> <labelled<double>[2]>
#> [1]  1 NA
#> 
#> Labels:
#>  value            label
#>      1 value label of 1
set_na_to_filter(x)
#> <labelled<double>[2]>
#> [1]  1 -2
#> 
#> Labels:
#>  value            label
#>     -2           FILTER
#>      1 value label of 1
```
