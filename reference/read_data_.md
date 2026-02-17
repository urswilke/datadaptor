# Ingest data from data.frame or file path

Ingest data from data.frame or file path

## Usage

``` r
read_data_(dat, ...)
```

## Arguments

- dat:

  String. Either a path to an SPSS file, a data.frame, or `NULL`.

- ...:

  Arguments passed to methods.

## Value

Returns `dat` (unchanged) in case of a data.frame, in case of a
character string returns the data.frame resulting of
`haven::read_sav(dat)`/`haven::read_dta(dat)`/`qs2::qs_read(dat)` or
`openxlsx2::read_xls(x)` for excel files (depending on the file
extension) or returns `NULL` in case of `NULL`.
