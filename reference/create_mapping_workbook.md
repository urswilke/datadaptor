# Create a mapping openxlsx2 workbook object

Create a mapping openxlsx2 workbook object

## Usage

``` r
create_mapping_workbook(df_raw)
```

## Arguments

- df_raw:

  dataframe with labelled variables, e.g. resulting from
  [`haven::read_sav`](https://haven.tidyverse.org/reference/read_spss.html)

## Value

openxlsx2 workbook object

## See also

[`create_mapping()`](https://urswilke.gitlab.io/datadaptor/reference/create_mapping.md)
to directly save the mapping to a file.

## Examples

``` r
spss_file <- system.file(
  "extdata",
  "mtcars_labelled.sav",
  package = "datadaptor"
)
df <- haven::read_sav(spss_file)
if (FALSE) { # \dontrun{
create_mapping_workbook(df)
} # }
```
