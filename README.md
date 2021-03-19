
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datenanpassr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/datenanpassr)](https://CRAN.R-project.org/package=datenanpassr)
<!-- badges: end -->

The goal of datenanpassr is to manipulate labelled datasets using
commands from an Excel file.

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
#> # A tibble: 100 x 8
#>            q1         q2        q3        q4         q5    id q6        q7      
#>     <dbl+lbl>  <dbl+lbl> <dbl+lbl> <dbl+lbl>  <dbl+lbl> <dbl> <chr>     <chr>   
#>  1  3 [norma…  2 [no]    3 [norma… 4 [much]   2 [a bit]     1 bla bla … bla bla…
#>  2  3 [norma…  1 [yes]   5 [very … 4 [much]   5 [very …     2 bla bla … bla bla…
#>  3  1 [not a…  1 [yes]   3 [norma… 2 [a bit]  5 [very …     3 bla joy   bla bla…
#>  4  3 [norma… 99 [no an… 4 [much]  4 [much]   4 [much]      4 bla bla … bla bla…
#>  5  5 [very … NA         2 [a bit] 3 [norma…  3 [norma…     5 bla happ… bla fear
#>  6  5 [very … NA         4 [much]  3 [norma…  2 [a bit]     6 bla bla … bla pain
#>  7 99 [no an…  2 [no]    3 [norma… 4 [much]  NA             7 bla love  bla bla…
#>  8  2 [a bit]  2 [no]    5 [very … 2 [a bit]  1 [not a…     8 bla bla … bla bla…
#>  9 99 [no an… 99 [no an… 1 [not a… 1 [not a…  2 [a bit]     9 bla bla … bla bla…
#> 10 99 [no an…  1 [yes]   1 [not a… 1 [not a…  4 [much]     10 bla bla … bla bla…
#> # … with 90 more rows
```

and want to modify some of the content.

You can create an Excel mapping file that’s based on a template filled
with variable and label information from the dataset:

``` r
datenanpassr::mapp_create(df, "mapping.xlsx")
```

In this Excel file commands can be added to do data cleaning or create
new variables in the dataset.

In datenanpassr there’s, an [Excel mapping
file](inst/extdata/mapping.xlsx) included to demonstrate how this can be
done with this package. If you install `datenanpassr`, it provides an
included example mapping file:

``` r
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
```

You can then open the file with:

``` r
utils::browseURL(mapping_file)
```

Have a lock at the Excel command block vignette for examples how to
manipulate and generate new variables in your labelled dataset:

``` r
vignette("excel_command_blocks")
```

There you can find out more about the syntax how the commands in the
mapping file work.

Once you have added the commands to manipulate your data, you can apply
the changes to your dataset with:

``` r
df_mod <- datenanpassr::mapp_xl_to_data(df, mapping_file)
```

``` r
df_mod
#> # A tibble: 100 x 51
#>           q1 q2_renamed      q3 q4_renamed       q5    id      q6 q7         kq1
#>    <dbl+lbl>  <dbl+lbl> <dbl+l>  <dbl+lbl> <dbl+lb> <dbl> <dbl+l> <chr> <dbl+lb>
#>  1  3 [norm…  2 [no]    3 [nor… 4 [much]    2 [a b…     1 3 [bla… bla …  2 [3]  
#>  2  3 [norm…  1 [YES]   5 [ver… 4 [much]    5 [ver…     2 4 [bla… bla …  2 [3]  
#>  3  1 [not …  1 [YES]   3 [nor… 2 [a bit]   5 [ver…     3 8 [bla… bla …  1 [1-2]
#>  4  3 [norm… 99 [no an… 4 [muc… 4 [much]    4 [muc…     4 5 [bla… bla …  2 [3]  
#>  5  5 [very… -2 [FILTE… 2 [a b… 3 [normal]  3 [nor…     5 7 [bla… bla …  3 [4-5]
#>  6  5 [very… -2 [FILTE… 4 [muc… 3 [normal]  2 [a b…     6 5 [bla… bla …  3 [4-5]
#>  7 99 [no a…  2 [no]    3 [nor… 4 [much]   -2 [FIL…     7 9 [bla… bla … NA      
#>  8  2 [a bi…  2 [no]    5 [ver… 2 [a bit]   1 [not…     8 6 [bla… bla …  1 [1-2]
#>  9 99 [no a… 99 [no an… 1 [not… 1 [not at…  2 [a b…     9 6 [bla… bla … NA      
#> 10 99 [no a…  1 [YES]   1 [not… 1 [not at…  4 [muc…    10 3 [bla… bla … NA      
#> # … with 90 more rows, and 42 more variables: q6n <dbl+lbl>, q7n <dbl+lbl>,
#> #   q6_1 <dbl+lbl>, q6_2 <dbl+lbl>, q6_3 <dbl+lbl>, q6_4 <dbl+lbl>,
#> #   q6_97 <dbl+lbl>, q6_99 <dbl+lbl>, q6test_1 <dbl+lbl>, q6test_2 <dbl+lbl>,
#> #   q6test_3 <dbl+lbl>, q6test_4 <dbl+lbl>, q6test_97 <dbl+lbl>,
#> #   q6test_99 <dbl+lbl>, q6n1 <dbl+lbl>, q6n2 <dbl+lbl>, q6n3 <dbl+lbl>,
#> #   q6n4 <dbl+lbl>, q6n5 <dbl+lbl>, q6n6 <dbl+lbl>, q6n7 <dbl+lbl>,
#> #   q6n8 <dbl+lbl>, q6n9 <dbl+lbl>, q6n10 <dbl+lbl>, x <dbl>, abc <dbl>,
#> #   kq5 <dbl>, kq6 <dbl>, kq3 <dbl+lbl>, kq1xq2_renamedkminus20 <dbl+lbl>,
#> #   kq1xq2_renamedk10 <dbl+lbl>, kq1xq2_renamedk20 <dbl+lbl>,
#> #   kq1xq2_renamedk990 <dbl+lbl>, n <dbl+lbl>, a1 <dbl+lbl>, a2 <dbl+lbl>,
#> #   r_expr_var <dbl+lbl>, q2 <dbl+lbl>, sum_of_k_vars <dbl>, a <dbl>,
#> #   kkq1 <dbl+lbl>, free2_var <dbl>
```

Let’s also have a closer look at one of the new variables:

``` r
df_mod$q6n
#> <labelled<double>[100]>
#>   [1]  1  3  2  2  3  2  1  1  1  1  2  3  2  3  3  1  1  3  2  2  3  2  1  1  2
#>  [26]  2  3  2  2  1  3  1  1  2  2  1  3  2  3  3  1  1  3  2  2  2  2  3  3  2
#>  [51]  1  2  1  2  2  2  2  1  3  3  1  3  3 NA  1  2  1  1  3  1  2  2  1  1  1
#>  [76]  3  2  2  3 NA  2  1  2  2  2  1  2  2  2  2  1 NA  1  2 NA  2  2  3  3  1
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
