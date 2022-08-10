
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenanpassr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/datenanpassr)](https://CRAN.R-project.org/package=datenanpassr)
<!-- badges: end -->

The R package datenanpassr is an approach to programmatically manipulate
labelled datasets via a pre-defined syntax of various types of commands
in various types of Excel sheets. It is a replacement of what my brother
initially programmed in VBA and SPSS and how we approach our daily work
of data cleaning of survey data. The package can be used to write
various data manipulations in a concise way filling in commands in Excel
cells.

## Installation

You can install datenanpassr from Gitlab with:

``` r
devtools::install_gitlab("urswilke/datenanpassr")
```

## Example

First load the library:

``` r
library(datenanpassr)
```

### Apply data adjustments on labelled data

Suppose you have an SPSS data file

``` r
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
df <- haven::read_sav(spss_file)
df
#> # A tibble: 100 × 10
#>               q1       q2      q3      q4       q5    id q6    q7    q8       q9
#>        <dbl+lbl> <dbl+lb> <dbl+l> <dbl+l> <dbl+lb> <dbl> <chr> <chr> <chr> <dbl>
#>  1  3 [normal]    2 [no]  3 [nor… 4 [muc…  2 [a b…     1 bla … bla … 2        NA
#>  2  3 [normal]    1 [yes] 5 [ver… 4 [muc…  5 [ver…     2 bla … bla … 9        NA
#>  3  1 [not at a…  1 [yes] 3 [nor… 2 [a b…  5 [ver…     3 bla … bla … 3        NA
#>  4  3 [normal]   99 [no … 4 [muc… 4 [muc…  4 [muc…     4 bla … bla … 3        NA
#>  5  5 [very muc… NA       2 [a b… 3 [nor…  3 [nor…     5 bla … bla … 9        NA
#>  6  5 [very muc… NA       4 [muc… 3 [nor…  2 [a b…     6 bla … bla … 7        NA
#>  7 99 [no answe…  2 [no]  3 [nor… 4 [muc… NA           7 bla … bla … 10       NA
#>  8  2 [a bit]     2 [no]  5 [ver… 2 [a b…  1 [not…     8 bla … bla … 1        NA
#>  9 99 [no answe… 99 [no … 1 [not… 1 [not…  2 [a b…     9 bla … bla … 2        NA
#> 10 99 [no answe…  1 [yes] 1 [not… 1 [not…  4 [muc…    10 bla … bla … 4        NA
#> # … with 90 more rows
#> # ℹ Use `print(n = ...)` to see more rows
```

and want to modify some of the content.

<!-- TODO:  -->
<!-- You can create an Excel mapping file that's based on a template filled with variable and label information from the dataset: -->
<!-- ```{r, eval=FALSE} -->
<!-- datenanpassr::mapp_create(df, "mapping.xlsx") -->
<!-- ``` -->

In the package you can find an [example Excel mapping
file](inst/extdata/mapping.xlsx) to demonstrate the commands in this
package. If you install `datenanpassr`, you can access the path of this
file with

``` r
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
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
#> # A tibble: 100 × 67
#>          q1 q2_ren…¹      q3 q4_re…²       q5    id      q6 q7       q8      kq5
#>    <dbl+lb> <dbl+lb> <dbl+l> <dbl+l> <dbl+lb> <dbl> <dbl+l> <chr> <dbl> <dbl+lb>
#>  1  3 [nor…  2 [no]  3 [nor… 4 [muc…  2 [a b…     1 3 [bla… bla …     2  1 [aaa]
#>  2  3 [nor…  1 [YES] 5 [ver… 4 [muc…  5 [ver…     2 4 [bla… bla …     9  7      
#>  3  1 [not…  1 [YES] 3 [nor… 2 [a b…  5 [ver…     3 8 [bla… bla …     3  7      
#>  4  3 [nor… 99 [no … 4 [muc… 4 [muc…  4 [muc…     4 5 [bla… bla …     3  3 [ccc]
#>  5  5 [ver… -2 [FIL… 2 [a b… 3 [nor…  3 [nor…     5 7 [bla… bla …     9  2 [bbb]
#>  6  5 [ver… -2 [FIL… 4 [muc… 3 [nor…  2 [a b…     6 5 [bla… bla …     7  1 [aaa]
#>  7 99 [no …  2 [no]  3 [nor… 4 [muc… NA           7 9 [bla… bla …    10 NA      
#>  8  2 [a b…  2 [no]  5 [ver… 2 [a b…  1 [not…     8 6 [bla… bla …     1  1 [aaa]
#>  9 99 [no … 99 [no … 1 [not… 1 [not…  2 [a b…     9 6 [bla… bla …     2  1 [aaa]
#> 10 99 [no …  1 [YES] 1 [not… 1 [not…  4 [muc…    10 3 [bla… bla …     4  7      
#> # … with 90 more rows, 57 more variables: q2 <dbl+lbl>, q4 <dbl+lbl>,
#> #   q97 <dbl>, q99 <dbl>, q6n <dbl+lbl>, q7n <dbl+lbl>, q6_1 <dbl+lbl>,
#> #   q6_2 <dbl+lbl>, q6_3 <dbl+lbl>, q6_4 <dbl+lbl>, q6_97 <dbl+lbl>,
#> #   q6_99 <dbl+lbl>, q6test_1 <dbl+lbl>, q6test_2 <dbl+lbl>,
#> #   q6test_3 <dbl+lbl>, q6test_4 <dbl+lbl>, q6test_97 <dbl+lbl>,
#> #   q6test_99 <dbl+lbl>, q6n1 <dbl+lbl>, q6n2 <dbl+lbl>, q6n3 <dbl+lbl>,
#> #   q6n4 <dbl+lbl>, q6n5 <dbl+lbl>, q6n6 <dbl+lbl>, q6n7 <dbl+lbl>, …
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
```

Let’s also have a closer look at one of the new variables:

``` r
df_mod$q6n
#> <labelled<double>[100]>
#>   [1]  1  3  2  2  3  2 NA NA  1  1  2  3 NA  3  3  1 NA  3  2  2  3  2 NA  1  2
#>  [26]  2  3  2  2  1  3  1  1  2  2  1  3 NA  3  3  1  1  3  2 NA  2  2  3  3  2
#>  [51]  1  2  1  2  2 NA NA  1  3  3  1  3  3 NA  1  2 NA NA  3  1  2  2  1  1  1
#>  [76]  3  2  2 NA NA NA  1  2  2  2  1  2 NA  2  2 NA NA  1  2 NA NA  2 NA NA  1
#> 
#> Labels:
#>  value     label
#>     -2    FILTER
#>      1      love
#>      2       joy
#>      3 happiness
#>     97    Others
#>     99 No answer
```

The manipulations defined in the Excel files are applied on the
dataframe that was derived from the SPSS file.

You can save the dataframe back to an SPSS file by again using the
[haven package](https://haven.tidyverse.org/):

``` r
haven::write_sav(df_mod, "fake_survey_mod.sav")
```
