# Format the dataframe returned by reading an excel sheet with `openxlsx2::wb_read()`

Turns the dataframe into a tibble with character columns and trims the
leading/trailing spaces of the strings.

## Usage

``` r
format_sheet_data(df, cols = dplyr::everything())
```

## Arguments

- df:

  dataframe

- cols:

  tidy-select expression to specify which columns to trim; defaults to
  [`dplyr::everything()`](https://tidyselect.r-lib.org/reference/everything.html)

## Value

formatted dataframe

## Examples

``` r
data.frame(a = " a ", b = 1) |> format_sheet_data()
#> # A tibble: 1 × 2
#>   a     b    
#>   <chr> <chr>
#> 1 a     1    
```
