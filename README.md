
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datadaptor

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/datadaptor)](https://CRAN.R-project.org/package=datadaptor)
<!-- badges: end -->

The R package datadaptor is an approach to programmatically manipulate
labelled datasets via a pre-defined syntax of various types of commands
in various types of Excel sheets. It is a replacement of what my brother
initially programmed in VBA and SPSS and how we approach our daily work
of data cleaning of survey data. The package can be used to write
various data manipulations in a concise way filling in commands in Excel
cells.

## Installation

You can install datadaptor from Gitlab with:

``` r
devtools::install_gitlab("urswilke/datadaptor")
```

## Example

First load the library:

``` r
library(datadaptor)
```

### Apply data adjustments on labelled data

Suppose you have an SPSS data file

``` r
spss_file <- system.file("extdata", "mtcars_labelled.sav", package = "datadaptor")
df <- haven::read_sav(spss_file)
df
#> # A tibble: 32 × 13
#>       id model         mpg cyl      disp    hp  drat    wt  qsec vs      am     
#>    <dbl> <chr>       <dbl> <dbl+l> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl+l> <dbl+l>
#>  1     1 Mazda RX4    21   6 [6 c…  160    110  3.9   2.62  16.5 0 [V-s… 1 [man…
#>  2     2 Mazda RX4 …  21   6 [6 c…  160    110  3.9   2.88  17.0 0 [V-s… 1 [man…
#>  3     3 Datsun 710   22.8 4 [4 c…  108     93  3.85  2.32  18.6 1 [str… 1 [man…
#>  4     4 Hornet 4 D…  21.4 6 [6 c…  258    110  3.08  3.22  19.4 1 [str… 0 [aut…
#>  5     5 Hornet Spo…  18.7 8 [8 c…  360    175  3.15  3.44  17.0 0 [V-s… 0 [aut…
#>  6     6 Valiant      18.1 6 [6 c…  225    105  2.76  3.46  20.2 1 [str… 0 [aut…
#>  7     7 Duster 360   14.3 8 [8 c…  360    245  3.21  3.57  15.8 0 [V-s… 0 [aut…
#>  8     8 Merc 240D    24.4 4 [4 c…  147.    62  3.69  3.19  20   1 [str… 0 [aut…
#>  9     9 Merc 230     22.8 4 [4 c…  141.    95  3.92  3.15  22.9 1 [str… 0 [aut…
#> 10    10 Merc 280     19.2 6 [6 c…  168.   123  3.92  3.44  18.3 1 [str… 0 [aut…
#> # ℹ 22 more rows
#> # ℹ 2 more variables: gear <dbl+lbl>, carb <dbl+lbl>
```

and want to modify some of the content.

<!-- TODO:  -->
<!-- You can create an Excel mapping file that's based on a template filled with variable and label information from the dataset: -->
<!-- ```{r, eval=FALSE} -->
<!-- datadaptor::create_mapping(df, "mapping.xlsx") -->
<!-- ``` -->

In the package you can find an [example Excel mapping
file](inst/extdata/mapping.xlsx) to demonstrate the commands in this
package. If you install `datadaptor`, you can access the path of this
file with

``` r
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datadaptor")
```

and then open it with:

``` r
utils::browseURL(mapping_file)
```

Have a look at the `vignette("command_blocks")` for examples how to
manipulate and generate new variables in your labelled dataset.

There you can find out more about the syntax how the commands in the
mapping file work.

Once you have added the commands to manipulate your data, you can
generate a mapping object with

``` r
mapping <- Mapping$new(df, mapping_file)
```

and apply the changes to your dataset with:

``` r
mapping$modify_data()
```

You can then access the modified data with:

``` r
(df_mod <- mapping$dat_mod)
#> # A tibble: 32 × 16
#>    id       car_name mpg   cyl      disp    hp  drat    wt  qsec vs      am     
#>    <dbl+lb> <chr>    <dbl> <dbl+l> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl+l> <dbl+l>
#>  1  1       Mazda R… 21    6 [6 c…  160    110  3.9   2.62  16.5 0 [V-s… 1 [man…
#>  2  2       Mazda R… 21    6 [6 c…  160    110  3.9   2.88  17.0 0 [V-s… 1 [man…
#>  3  3       Datsun … 22.8  4 [4 c…  108     93  3.85  2.32  18.6 1 [str… 1 [man…
#>  4  4       Hornet … 21.4  6 [6 c…  258    110  3.08  3.22  19.4 1 [str… 0 [aut…
#>  5  5       Hornet … 18.7  8 [8 c…  360    175  3.15  3.44  17.0 0 [V-s… 0 [aut…
#>  6  6       Valiant  18.1  6 [6 c…  225    105  2.76  3.46  20.2 1 [str… 0 [aut…
#>  7  7       Duster … 14.3  8 [8 c…  360    245  3.21  3.57  15.8 0 [V-s… 0 [aut…
#>  8  8       Merc 24… 24.4  4 [4 c…  147.    62  3.69  3.19  20   1 [str… 0 [aut…
#>  9  9       Merc 230 22.8  4 [4 c…  141.    95  3.92  3.15  22.9 1 [str… 0 [aut…
#> 10 10       Merc 280 19.2  6 [6 c…  168.   123  3.92  3.44  18.3 1 [str… 0 [aut…
#> # ℹ 22 more rows
#> # ℹ 5 more variables: gear <dbl+lbl>, carb <dbl+lbl>, kcarb <dbl+lbl>,
#> #   vs2 <dbl+lbl>, am2 <dbl+lbl>
```

Let’s also have a closer look at one of the new variables:

``` r
df_mod$am2
#> <labelled<double>[32]>: New variable label for am2
#>  [1]  2  2  2 NA NA NA NA NA NA NA NA NA NA NA NA NA NA  2  2  2 NA NA NA NA NA
#> [26]  2  2  2  2  2  2  2
#> 
#> Labels:
#>  value                        label
#>      1 Super duper code for value 1
#>      2 Super duper code for value 2
```

The manipulations defined in the Excel files are applied on the
dataframe that was derived from the SPSS file.

You can save the dataframe back to an SPSS file by again using the
[haven package](https://haven.tidyverse.org/):

``` r
haven::write_sav(df_mod, "mtcars_labelled_mod.sav")
```

## Security warning

datadaptor evaluates code from user input. Do not expose this program to
the internet or random users under any circumstances.
