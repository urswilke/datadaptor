# Mapping parameters

`get_mapping_options()` is a helper function called by
`Mapping$new(...)` or `Mapping$set_options(...)` to generate the
parameters in the `opts$da` field of a Mapping object.

## Usage

``` r
get_mapping_options(
  id_var = NULL,
  error_out = "unsafe",
  debug = FALSE,
  save_path = tempdir(),
  write_mapping_to_txt = FALSE,
  expr_eval_env = new.env(parent = baseenv()),
  lab_before_var_sheet = "yes",
  miss_rec_lab = "FILTER",
  miss_rec_val = -2,
  na_to_filter = TRUE,
  not_miss_to_filter_vars = NA_character_,
  verbose = FALSE,
  set_integers = FALSE,
  ...
)
```

## Arguments

- id_var:

  character string of the id variable name in the dataset.

- error_out:

  character string. Either "safe", "quiet" or "unsafe" (the default).
  Whether to continue executing when a command block fails ("safe" or
  "quiet"), or to error out ("unsafe"). Adds a column "error" to the
  mapping's command table `mapping$cmd_tbl`. The difference between
  "safe" & "quiet" is whether to print errors & warnings to the command
  line while running `Mapping$modify_data()`.

- debug:

  whether to enter in debug mode when an error occurs. Automatically
  sets `error_out = "safe"`.

- save_path:

  filepath where to save files.

- write_mapping_to_txt:

  Whether to write the `Mapping`'s data to text files (for instance, in
  order to allow for git version control during the course of a project
  that evolves). Defaults to FALSE. Will probably be deprecated in the
  future.

- expr_eval_env:

  The environment where expressions are evaluated. See
  [`?safer_env`](https://urswilke.codeberg.page/datadaptor/reference/safer_env.md).

- lab_before_var_sheet:

  Whether to apply the "Label" sheet before the "Variables" sheet.
  Defaults to `TRUE`.

- miss_rec_lab:

  Label given if `na_to_filter = TRUE`.

- miss_rec_val:

  Replace value if `na_to_filter = TRUE`.

- na_to_filter:

  if TRUE (the default), NA values ("missing" in SPSS) are transformed
  with.
  [`apply_command.cmd_recna_xcpt()`](https://urswilke.codeberg.page/datadaptor/reference/apply_command.md)
  in the first command block.

- not_miss_to_filter_vars:

  Space separated character string of variable names spared out for
  [`apply_command.cmd_recna_xcpt()`](https://urswilke.codeberg.page/datadaptor/reference/apply_command.md).

- verbose:

  Defaults to `FALSE`; If `TRUE` will be more chatty about what's
  happening (Very preliminary! at the moment, only used in crosstabser).

- set_integers:

  Defaults to `FALSE`; If `TRUE`, numeric columns consisting of only
  `NA` will be set to integer. (When
  [`haven::labelled`](https://haven.tidyverse.org/reference/labelled.html)
  columns with integers are saved to SPSS, this sets the "Decimals" to 0
  instead of 2 for numeric columns.)

- ...:

  used to pass arguments from `Mapping$new(...)`

## Value

list object (see examples)

## Examples

``` r
get_mapping_options()
#> $id_var
#> NULL
#> 
#> $na_to_filter
#> [1] TRUE
#> 
#> $error_out
#> [1] "unsafe"
#> 
#> $debug
#> [1] FALSE
#> 
#> $write_mapping_to_txt
#> [1] FALSE
#> 
#> $save_path
#> [1] "/tmp/RtmpDjb02Z"
#> 
#> $expr_eval_env
#> <environment: 0x55a1575096d0>
#> 
#> $lab_before_var_sheet
#> [1] "yes"
#> 
#> $miss_rec_lab
#> [1] "FILTER"
#> 
#> $miss_rec_val
#> [1] -2
#> 
#> $not_miss_to_filter_vars
#> [1] NA
#> 
#> $verbose
#> [1] FALSE
#> 
#> $set_integers
#> [1] FALSE
#> 
```
