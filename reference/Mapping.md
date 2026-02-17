# Mapping class

The [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
`Mapping` can be used to apply the changes specified in the command
blocks of an Excel mapping file to a (labelled) dataframe.

The information of the Excel mapping file results in the `cmd_tbl`
dataframe field of the mapping object. This dataframe has a column
`command_blocks` which is applied to the data in the `dat` field by the
method `modify_data()` and then results in the `dat_mod` field.

## Public fields

- `dat`:

  (filepath to pass to
  [`haven::read_sav()`](https://haven.tidyverse.org/reference/read_spss.html)
  to read in the) labelled dataframe to apply the mapping on.

- `mapping_file`:

  Mapping file document (see `mapping_type`). The class of this string
  will be set to "mapping_type".

- `mapping_type`:

  String specifying the mapping type. Either "excel" or "list". If not
  specified, when initializing it is auto-determined:

  - "list": If `mapping_file` is a list object.

  - "excel": If the `mapping_file` path ends on "xlsm" or "xlsx".

- `cmd_tbl`:

  Dataframe with the command block information

- `cmd`:

  R list structure containing the processed command block information of
  the Excel mapping file. **\[experimental\]**

- `dat_mod`:

  modified dataframe

- `opts`:

  Parameter list object (in `opts$da`)

- `wb`:

  For an excel mapping, the openxlsx2 workbook object, otherwise `NULL`.

- `ditw`:

  This is the "dust in the wind" list object field that stores data that
  didn't make it into their own field. For developers only! For
  reproducible code you should NEVER rely on this field as it might be
  subject to change without any warning.

## Methods

### Public methods

- [`Mapping$new()`](#method-Mapping-new)

- [`Mapping$process_sheet_commands()`](#method-Mapping-process_sheet_commands)

- [`Mapping$modify_data()`](#method-Mapping-modify_data)

- [`Mapping$save()`](#method-Mapping-save)

- [`Mapping$set_options()`](#method-Mapping-set_options)

- [`Mapping$read_data()`](#method-Mapping-read_data)

- [`Mapping$clone()`](#method-Mapping-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a Mapping object

#### Usage

    Mapping$new(
      dat = NULL,
      mapping_file = NULL,
      mapping_type = NULL,
      process_sheets = TRUE,
      ...
    )

#### Arguments

- `dat`:

  Dataframe to apply the mapping on.

- `mapping_file`:

  Path to the Excel mapping file.

- `mapping_type`:

  String specifying the mapping type. Either "excel" or "list".

- `process_sheets`:

  (default TRUE) allows (process_sheets = FALSE) to postpone the
  execution of the commands in the Excel mapping file to the
  modify_data() method

- `...`:

  Arguments passed to the `Mapping$set_options()` method which will
  populate the `Mapping$opts$da` field of the object.

#### Returns

A new `Mapping` object.

------------------------------------------------------------------------

### Method `process_sheet_commands()`

Parse the sheet data of the mapping file and derive the command blocks
included. Automatically run in the constructor if
`process_sheets = TRUE` (the default). Automatically run by the
`modify_data()` method if not done before.

#### Usage

    Mapping$process_sheet_commands()

------------------------------------------------------------------------

### Method `modify_data()`

Run all command blocks of the mapping file. The commands in the argument
`command_blocks` (defaults to the Mapping's `cmd_tbl$command_blocks`
field) successively are applied to the data in the field `"dat_mod"`
according to their subclass methods of
[`apply_command()`](https://urswilke.gitlab.io/datadaptor/reference/apply_command.md).

#### Usage

    Mapping$modify_data(reset = TRUE, command_blocks = self$cmd_tbl$command_blocks)

#### Arguments

- `reset`:

  whether to apply the modifications to the input data (field `dat`) or
  whether to keep previous modifications (only relevant when applying
  `modify_data()` multiple times).

- `command_blocks`:

  The `"command_blocks"` object results of the processing of the Excel
  mapping file.

------------------------------------------------------------------------

### Method [`save()`](https://rdrr.io/r/base/save.html)

Save the modified data to a file

The data can be exported to the file formats of Stata & SPSS. The Excel
export removes variable & value labels.

#### Usage

    Mapping$save(path = NULL, show = FALSE, name = "dat", filetype = "sav", ...)

#### Arguments

- `path`:

  [`character()`](https://rdrr.io/r/base/character.html) string or
  `NULL`. If `NULL` (the default) it will write the file to the path in
  `self$opts$da$save_path` with the file `name` & `filetype`.

- `show`:

  Whether to directly open the file (needs the according software
  installed and setup to open its `filetype`).

- `name`:

  [`character()`](https://rdrr.io/r/base/character.html) string
  containing the file name to be written. Is overwritten, by `path` if
  not `NULL`.

- `filetype`:

  [`character()`](https://rdrr.io/r/base/character.html) string
  containing the file type to be written. Is overwritten, by `path` if
  not `NULL`.

- `...`:

  Passed to methods.

#### Examples

    \dontrun{
    # Create a Mapping object from the files provided by the package:
    mapping_file <- system.file(
      "extdata",
      "mapping.xlsx",
      package = "datadaptor"
    )
    spss_file <- system.file(
      "extdata",
      "mtcars_labelled.sav",
      package = "datadaptor"
    )
    m <- Mapping$new(spss_file, mapping_file)

    # The method applies the modifications specified in a command_blocks object
    m$modify_data(command_blocks = m$cmd_tbl$command_blocks)
    m$save("stata_data.dta", show = TRUE)
    }

------------------------------------------------------------------------

### Method `set_options()`

Set / change options of the `Mapping` object

The dots (`...`) can be passed here to change settings, or already when
initializing the object with `Mapping$new(...)`

Additionally to the dots you can also pass parameters from an Excel
mapping file by using named regions starting with `"R_"`, for instance,
`"R_id_var"` will become `"id_var"`. The complete set of arguments
consists of he default values in
[`get_mapping_options()`](https://urswilke.gitlab.io/datadaptor/reference/get_mapping_options.md)
overwritten by the above named regions of the Excel file, and all this
can be overwritten by the dots.

The part of the arguments known to
[`get_mapping_options()`](https://urswilke.gitlab.io/datadaptor/reference/get_mapping_options.md)
is written to the `opts$da` field, The rest is written to the `opts$dev`
field.

#### Usage

    Mapping$set_options(...)

#### Arguments

- `...`:

  arguments passed to
  [`get_mapping_options()`](https://urswilke.gitlab.io/datadaptor/reference/get_mapping_options.md)

------------------------------------------------------------------------

### Method `read_data()`

Read in dataset

#### Usage

    Mapping$read_data(dat, ...)

#### Arguments

- `dat`:

  Dataset indentifier (see
  [`?read_data_`](https://urswilke.gitlab.io/datadaptor/reference/read_data_.md)
  helper function).

- `...`:

  Arguments passed to
  [`read_data_()`](https://urswilke.gitlab.io/datadaptor/reference/read_data_.md)
  helper function.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Mapping$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Create a Mapping object from the files provided by the package:
mapping_file <- system.file(
  "extdata",
  "mapping.xlsx",
  package = "datadaptor"
)
spss_file <- system.file(
  "extdata",
  "mtcars_labelled.sav",
  package = "datadaptor"
)
mapping <- Mapping$new(spss_file, mapping_file)

# The spss_file path was read into a dataframe in the "dat" field of the
# mapping object:
mapping$dat
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

# The Excel mapping file is translated to a `command_blocks()` object.
# It contains the processed information in a list structure that has
# its own print method.
# You can access it with
if (FALSE) { # \dontrun{
mapping$cmd_tbl$command_blocks
} # }
# Apply the command blocks to the dataset:
mapping$modify_data()

# Access the modified dataframe:
mapping$dat_mod
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

# To write it back to an SPSS file, you could do:
# mapping$save("path/to/your/file.sav")
# or with haven (used under the hood by `save()`):
# haven::write_sav(mapping$dat_mod, "path/to/your/file.sav")

## ------------------------------------------------
## Method `Mapping$save`
## ------------------------------------------------

if (FALSE) { # \dontrun{
# Create a Mapping object from the files provided by the package:
mapping_file <- system.file(
  "extdata",
  "mapping.xlsx",
  package = "datadaptor"
)
spss_file <- system.file(
  "extdata",
  "mtcars_labelled.sav",
  package = "datadaptor"
)
m <- Mapping$new(spss_file, mapping_file)

# The method applies the modifications specified in a command_blocks object
m$modify_data(command_blocks = m$cmd_tbl$command_blocks)
m$save("stata_data.dta", show = TRUE)
} # }
```
