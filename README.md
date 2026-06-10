
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datadaptor

*The main home of this repository is
[here](https://codeberg.org/urswilke/datadaptor)*

<!-- badges: start -->

<!-- [![CRAN status](https://www.r-pkg.org/badges/version/datadaptor)](https://CRAN.R-project.org/package=datadaptor) -->

[![datadaptor status
badge](https://urswilke.r-universe.dev/datadaptor/badges/version)](https://urswilke.r-universe.dev/datadaptor)
[![R CMD
check](https://ci.codeberg.org/api/badges/16369/status.svg)](https://ci.codeberg.org/repos/16369)  
![Codecov](https://badgen.net/codecov/github/urswilke/datadaptor?icon=codecov&label)
![Codeberg
stars](https://badgen.net/codeberg/stars/urswilke/datadaptor/yellow?icon=sourcegraph)
<!-- badges: end -->

The R package datadaptor is an approach to programmatically manipulate
labelled datasets via a pre-defined syntax of various types of commands
in various types of Excel sheets. It is a replacement of what my brother
initially programmed in VBA and SPSS and how we approach our daily work
of data cleaning of survey data. The package can be used to write
various data manipulations in a concise way filling in commands in Excel
cells.

## Installation

You can install datadaptor from codeberg with:

``` r
devtools::install_git("https://codeberg.org/urswilke/datadaptor")
```

Otherwise, you can also install datadaptor from github or gitlab with:

``` r
devtools::install_github("urswilke/datadaptor")
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
spss_file <- system.file("extdata", "fruit_survey.sav", package = "datadaptor")
df <- haven::read_sav(spss_file)
df
#> # A tibble: 100 × 12
#>       id q1       q2_1     q2_2     q2_3     q2_97    q3_1     q3_2     q3_3    
#>    <dbl> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb>
#>  1     1  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  0 [Not…  2 [2]    4 [4]    5 [5 =…
#>  2     2  1 [Yes]  0 [Not…  1 [Sel…  1 [Sel…  0 [Not… NA        2 [2]    5 [5 =…
#>  3     3  1 [Yes]  0 [Not…  0 [Not…  1 [Sel…  1 [Sel… NA       NA        1 [1 =…
#>  4     4  1 [Yes]  1 [Sel…  0 [Not…  0 [Not…  0 [Not…  1 [1 =… NA       NA      
#>  5     5  2 [No]  NA       NA       NA       NA       NA       NA       NA      
#>  6     6  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  3 [3]    2 [2]    5 [5 =…
#>  7     7  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  0 [Not…  5 [5 =…  4 [4]    5 [5 =…
#>  8     8  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  1 [1 =…  5 [5 =…  2 [2]  
#>  9     9 99 [No … NA       NA       NA       NA       NA       NA       NA      
#> 10    10  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  2 [2]    1 [1 =…  5 [5 =…
#> # ℹ 90 more rows
#> # ℹ 3 more variables: q3_97 <dbl+lbl>, q4 <dbl+lbl>, q5 <dbl>
```

and want to modify some of the content.

<!-- TODO:  -->

<!-- You can create an Excel mapping file that's based on a template filled with variable and label information from the dataset: -->

<!-- ```{r, eval=FALSE} -->

<!-- datadaptor::create_mapping(df, "mapping.xlsx") -->

<!-- ``` -->

In the package you can find an [example Excel mapping
file](https://codeberg.org/urswilke/datadaptor/src/branch/master/inst/extdata/mapping-fruits.xlsx)
to demonstrate the commands in this package. If you install
`datadaptor`, you can access the path of this file with

``` r
mapping_file <- system.file("extdata", "mapping-fruits.xlsx", package = "datadaptor")
```

and then open it with:

``` r
utils::browseURL(mapping_file)
```

Have a look at the `vignette("command_blocks")` for examples how to
manipulate and generate new variables in your labelled dataset. There
you can find out more about the syntax how the commands in the mapping
file work. Once you have added the commands to manipulate your data, you
can generate a mapping object with

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
#> # A tibble: 100 × 18
#>       id q1       q2_1     q2_2     q2_3     q2_97    q3_1     q3_2     q3_3    
#>    <dbl> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb>
#>  1     1  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  0 [Not…  2 [2]    4 [4]    5 [5 =…
#>  2     2  1 [Yes]  0 [Not…  1 [Sel…  1 [Sel…  0 [Not… -2 [FIL…  2 [2]    5 [5 =…
#>  3     3  1 [Yes]  0 [Not…  0 [Not…  1 [Sel…  1 [Sel… -2 [FIL… -2 [FIL…  1 [1 =…
#>  4     4  1 [Yes]  1 [Sel…  0 [Not…  0 [Not…  0 [Not…  1 [1 =… -2 [FIL… -2 [FIL…
#>  5     5  2 [No]  -2 [FIL… -2 [FIL… -2 [FIL… -2 [FIL… -2 [FIL… -2 [FIL… -2 [FIL…
#>  6     6  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  3 [3]    2 [2]    5 [5 =…
#>  7     7  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  0 [Not…  5 [5 =…  4 [4]    5 [5 =…
#>  8     8  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  1 [1 =…  5 [5 =…  2 [2]  
#>  9     9 99 [No … -2 [FIL… -2 [FIL… -2 [FIL… -2 [FIL… -2 [FIL… -2 [FIL… -2 [FIL…
#> 10    10  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  2 [2]    1 [1 =…  5 [5 =…
#> # ℹ 90 more rows
#> # ℹ 9 more variables: q3_97 <dbl+lbl>, q4 <dbl+lbl>, q5 <dbl+lbl>,
#> #   kq2_1 <dbl+lbl>, kq2_2 <dbl+lbl>, kq2_3 <dbl+lbl>, n_fruits <dbl>,
#> #   q2_99 <dbl+lbl>, kq5 <dbl+lbl>
```

Let’s also have a closer look at one of the new variables:

``` r
df_mod$kq5
#> <labelled<double>[100]>: Fruit number category
#>   [1] NA  2  3  3 NA  2  2  2 NA  1  3  1  3  3  3  2 NA NA NA  2  3  2 NA NA  3
#>  [26]  3  1 NA  2  3  1  3  1 NA  3  1  1  2 NA  1  2  3  2 NA  3 NA NA NA NA  3
#>  [51] NA  1  1  3  1 NA NA  1 NA NA  3 NA  1 NA  2  2 NA NA NA  2 NA  3 NA  3 NA
#>  [76]  1  2 NA NA  3  2  2  3  2  3  1  3  1  3  1  1  2  2  3 NA NA  3  2  2  3
#> 
#> Labels:
#>  value      label
#>      1  3 or less
#>      2     4 or 5
#>      3 6 and more
```

The manipulations defined in the Excel file are applied on the dataframe
that was derived from the SPSS file.

You can save the dataframe back to an SPSS file by again using the
[haven package](https://haven.tidyverse.org/):

``` r
haven::write_sav(df_mod, "fruit_survey-modified.sav")
```

[Here](https://urswilke.codeberg.page/crosstabser/articles/crosstabser.html#mapping-file-content)
you can find a small description what each of the commands in
`mapping_file` does, and how this can be used for the tabulation of the
data.

## Further use

### Tabulation

If you additionally want to tabulate survey data, please have a look at
the accompanying package
[crosstabser](https://codeberg.org/urswilke/crosstabser/) that expands
the functionality of datadaptor.

### Dashboards

For interactive dashboards with charts of the crosstabs, please have a
look at the accompanying package
[table_charter](https://gitlab.com/urswilke/table_charter) that expands
the functionality of crosstabser.

### datadaptor - crosstabser - table_charter

For an interactive demo of the combined use of datadaptor, crosstabser &
table_charter, where you can play around in your browser and see how
that changes the results, please have a look
[here](https://urswilke.github.io/datadaptor-crosstabser-table_charter-demo).

## Security warning

datadaptor evaluates code from user input. Do not expose this program to
the internet or random users under any circumstances.
