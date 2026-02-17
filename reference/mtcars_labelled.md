# Labelled mtcars version

A labelled version of the `mtcars` dataset (see
[`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)). The data is stored
in variables of the type haven::labelled. The same data is also included
in the package in SPSS format. See in the examples section how to load
the SPSS version to R.

## Usage

``` r
mtcars_labelled
```

## Format

A data frame with 32 observations on 13 variables:

- id:

  car id

- model:

  Name of the car - this information is stored in rownames in `mtcars`.

- mpg:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- cyl:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- disp:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- hp:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- drat:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- wt:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- qsec:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- vs:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- am:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- gear:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

- carb:

  see [`?mtcars`](https://rdrr.io/r/datasets/mtcars.html)

## Examples

``` r
datadaptor::mtcars_labelled
#> # A tibble: 32 × 13
#>       id model       mpg   cyl     disp  hp    drat  wt    qsec  vs      am     
#>    <dbl> <chr>       <dbl> <dbl+l> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl+l> <dbl+l>
#>  1     1 Mazda RX4   21    6 [6 c… 160   110   3.9   2.62  16.5  0 [V-s… 1 [man…
#>  2     2 Mazda RX4 … 21    6 [6 c… 160   110   3.9   2.88  17.0  0 [V-s… 1 [man…
#>  3     3 Datsun 710  22.8  4 [4 c… 108    93   3.85  2.32  18.6  1 [str… 1 [man…
#>  4     4 Hornet 4 D… 21.4  6 [6 c… 258   110   3.08  3.22  19.4  1 [str… 0 [aut…
#>  5     5 Hornet Spo… 18.7  8 [8 c… 360   175   3.15  3.44  17.0  0 [V-s… 0 [aut…
#>  6     6 Valiant     18.1  6 [6 c… 225   105   2.76  3.46  20.2  1 [str… 0 [aut…
#>  7     7 Duster 360  14.3  8 [8 c… 360   245   3.21  3.57  15.8  0 [V-s… 0 [aut…
#>  8     8 Merc 240D   24.4  4 [4 c… 147.   62   3.69  3.19  20    1 [str… 0 [aut…
#>  9     9 Merc 230    22.8  4 [4 c… 141.   95   3.92  3.15  22.9  1 [str… 0 [aut…
#> 10    10 Merc 280    19.2  6 [6 c… 168.  123   3.92  3.44  18.3  1 [str… 0 [aut…
#> # ℹ 22 more rows
#> # ℹ 2 more variables: gear <dbl+lbl>, carb <dbl+lbl>
path <- system.file("extdata", "mtcars_labelled.sav", package = "datadaptor")
df <- haven::read_sav(path)
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
