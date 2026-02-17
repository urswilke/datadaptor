# Generate tables with the variables' labels

`gen_var_table()` generates the "Variables" sheet table with the
variable labels in the data.

`gen_label_table()` generates the "Label" sheet table with the value
labels in the data.

## Usage

``` r
gen_var_table(dat)

gen_label_table(dat)
```

## Arguments

- dat:

  The dataset containing variables of type
  [`haven::labelled`](https://haven.tidyverse.org/reference/labelled.html)` `.

## Value

For `gen_var_table()` a dataframe containing the table of the
"Variables" sheet.

For `gen_label_table()` a dataframe containing the table for the "Label"
sheet.

## Examples

``` r
spss_file <- system.file(
  "extdata",
  "mtcars_labelled.sav",
  package = "datadaptor"
)
dat <- spss_file |>
  haven::read_sav()
gen_var_table(dat)
#> # A tibble: 13 × 7
#>    var   type      varlab                    new_label new_name op    hash      
#>    <chr> <chr>     <chr>                     <chr>     <chr>    <chr> <chr>     
#>  1 id    double    ""                        ""        ""       ""    c09df35d3…
#>  2 model character ""                        ""        ""       ""    5c438433e…
#>  3 mpg   double    "Miles/(US) gallon"       ""        ""       ""    bc0241e8f…
#>  4 cyl   double    "Number of cylinders"     ""        ""       ""    bacca15ac…
#>  5 disp  double    "Displacement (cu.in.)"   ""        ""       ""    10d968056…
#>  6 hp    double    "Gross horsepower"        ""        ""       ""    af4dfb32f…
#>  7 drat  double    "Rear axle ratio"         ""        ""       ""    4a2e9d1d7…
#>  8 wt    double    "Weight (1000 lbs)"       ""        ""       ""    e6117c0a8…
#>  9 qsec  double    "1/4 mile time"           ""        ""       ""    fd3996c60…
#> 10 vs    double    "Engine"                  ""        ""       ""    cbed337c1…
#> 11 am    double    "Transmission"            ""        ""       ""    a33123e82…
#> 12 gear  double    "Number of forward gears" ""        ""       ""    9503b752a…
#> 13 carb  double    "Number of carburetors"   ""        ""       ""    7f40d9f48…
gen_label_table(dat)
#> # A tibble: 18 × 7
#>    var      nv vallab       new_label sum_var_label sum_var_value sum_var_vallab
#>    <chr> <dbl> <chr>        <chr>     <chr>         <chr>         <chr>         
#>  1 cyl       4 4 cylinders  ""        ""            ""            ""            
#>  2 cyl       6 6 cylinders  ""        ""            ""            ""            
#>  3 cyl       8 8 cylinders  ""        ""            ""            ""            
#>  4 vs        0 V-shaped     ""        ""            ""            ""            
#>  5 vs        1 straight     ""        ""            ""            ""            
#>  6 am        0 automatic    ""        ""            ""            ""            
#>  7 am        1 manual       ""        ""            ""            ""            
#>  8 gear      3 3 gears      ""        ""            ""            ""            
#>  9 gear      4 4 gears      ""        ""            ""            ""            
#> 10 gear      5 5 gears      ""        ""            ""            ""            
#> 11 carb      1 1 carburetor ""        ""            ""            ""            
#> 12 carb      2 2 carbureto… ""        ""            ""            ""            
#> 13 carb      3 3 carbureto… ""        ""            ""            ""            
#> 14 carb      4 4 carbureto… ""        ""            ""            ""            
#> 15 carb      5 5 carbureto… ""        ""            ""            ""            
#> 16 carb      6 6 carbureto… ""        ""            ""            ""            
#> 17 carb      7 7 carbureto… ""        ""            ""            ""            
#> 18 carb      8 8 carbureto… ""        ""            ""            ""            
```
