``` r
date()
```

    ## [1] "Tue Sep 17 22:53:11 2024"

``` r
devtools::load_all()
```

    ## ℹ Loading datenanpassr

``` r
mapping_file <- "tests/testthat/excel/mapping_old.xlsx" |> here::here()

bench::mark(Mapping$new(NULL, mapping_file), iterations = 5)
```

    ## Warning: Some expressions had a GC in every iteration; so filtering is
    ## disabled.

    ## # A tibble: 1 × 6
    ##   expression                           min   median `itr/sec` mem_alloc `gc/sec`
    ##   <bch:expr>                      <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    ## 1 Mapping$new(NULL, mapping_file)    1.05s    1.09s     0.922    5.97MB     5.71
