# Diff to labelled data frames

Diff to labelled data frames

## Usage

``` r
diff_data(df1, df2, id_var = "DC_ID", n_max = 20, warn = TRUE)
```

## Arguments

- df1:

  data frame 1

- df2:

  data frame 2

- id_var:

  name of the id variable (string)

- n_max:

  Maximum number of values/value labels in variables. Variables
  containing more than `n_max` won't be printed.

- warn:

  whether to emit a warning if `df1` and `df2` don't contain the same
  ids.

## Value

data frame of diff results: For every variable `var`in the data.frames,
the counts `n` are shown for all the values (one column per value type),
variable and value labels, well as their type (column prefixes). The
column suffixes `"_old"` and `"new"` indicate `df` and `df2`,
respectively. If the type column is empty, the variable doesn't exist in
the respective data.frame.

## Examples

``` r
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datadaptor")
mapping <- Mapping$new(mtcars_labelled, mapping_file)
mapping$modify_data()
diff_data(mapping$dat, mapping$dat_mod, "id")
#> # A tibble: 26 × 12
#>    var   double_old character_old vallab_old  type_old varlab_old     double_new
#>    <fct>      <dbl> <chr>         <chr>       <chr>    <chr>               <dbl>
#>  1 cyl            4 NA            4 cylinders double   Number of cyl…          4
#>  2 cyl            6 NA            6 cylinders double   Number of cyl…          6
#>  3 cyl            8 NA            8 cylinders double   Number of cyl…          8
#>  4 vs             0 NA            V-shaped    double   Engine                  0
#>  5 vs             1 NA            straight    double   Engine                  1
#>  6 am             0 NA            automatic   double   Transmission            0
#>  7 am             1 NA            manual      double   Transmission            1
#>  8 gear           3 NA            3 gears     double   Number of for…          3
#>  9 gear           4 NA            4 gears     double   Number of for…          4
#> 10 gear           5 NA            5 gears     double   Number of for…          5
#> # ℹ 16 more rows
#> # ℹ 5 more variables: character_new <chr>, vallab_new <chr>, type_new <chr>,
#> #   varlab_new <chr>, n <int>
```
