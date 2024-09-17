``` r
date()
```

    ## [1] "Tue Sep 17 22:37:04 2024"

``` r
devtools::load_all()
```

    ## ℹ Loading datenanpassr

``` r
mapping_file <- "K:/Projekte/KG FMC ATU 2024/Syntax/Mapping FMC ATU 2024.xlsm"

bench::mark(Mapping$new(NULL, mapping_file), iterations = 5)
```

    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## • `` -> `...8`
    ## • `` -> `...9`
    ## • `` -> `...10`
    ## • `` -> `...11`
    ## • `` -> `...12`
    ## • `` -> `...13`
    ## • `` -> `...14`
    ## • `` -> `...15`
    ## • `` -> `...16`
    ## • `` -> `...17`
    ## • `` -> `...18`
    ## • `` -> `...19`
    ## • `` -> `...20`
    ## • `` -> `...21`
    ## • `` -> `...22`
    ## • `` -> `...23`
    ## • `` -> `...24`
    ## • `` -> `...25`
    ## • `` -> `...26`
    ## • `` -> `...27`
    ## • `` -> `...28`
    ## • `` -> `...29`
    ## • `` -> `...30`
    ## • `` -> `...31`
    ## • `` -> `...32`
    ## • `` -> `...33`
    ## • `` -> `...34`

    ## Warning: Some expressions had a GC in every iteration; so filtering is
    ## disabled.

    ## # A tibble: 1 × 6
    ##   expression                           min   median `itr/sec` mem_alloc `gc/sec`
    ##   <bch:expr>                      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    ## 1 Mapping$new(NULL, mapping_file)     1.4m    1.41m    0.0118    5.86GB    0.363
