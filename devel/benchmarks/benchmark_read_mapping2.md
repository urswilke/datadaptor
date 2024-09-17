``` r
date()
```

    ## [1] "Tue Sep 17 22:25:17 2024"

``` r
devtools::load_all()
```

    ## ℹ Loading datenanpassr

``` r
mapping_file <- "K:/Projekte/KG FMC ATU 2024/Syntax/Mapping FMC ATU 2024.xlsm"

bench::mark(Mapping$new(NULL, mapping_file), iterations = 5)
```

    ## Warning: Some expressions had a GC in every iteration; so filtering is
    ## disabled.

    ## # A tibble: 1 × 6
    ##   expression                           min   median `itr/sec` mem_alloc `gc/sec`
    ##   <bch:expr>                      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    ## 1 Mapping$new(NULL, mapping_file)    24.1s    24.6s    0.0407    1.91GB     1.80
