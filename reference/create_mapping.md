# Create an Excel mapping file based on a labelled dataframe

The mapping file consists of the sheets "Variables", "Label",
"Verbatims" & "Free". Each of these controls different aspects of data
manipulations you can apply to a labelled dataset. You can add as much
of those sheets (sheets starting with one of these 4 prefixes) as you
want to the file. The commands entered in the mapping file can then be
executed on the data set with the `Mapping` class. The sequence of
commands is executed in the same order as the sequence of sheets in the
mapping file.

## Usage

``` r
create_mapping(df_raw, mapping_file, mapping_type = "excel")
```

## Arguments

- df_raw:

  dataframe with labelled variables, e.g. resulting from haven::read_sav

- mapping_file:

  name of the Excel file to be created

- mapping_type:

  String specifying the mapping type. Either "excel" or "list". Defaults
  to "excel".

## Examples

``` r
spss_file <- system.file(
  "extdata",
  "mtcars_labelled.sav",
  package = "datadaptor"
)
df <- haven::read_sav(spss_file)
if (FALSE) { # \dontrun{
create_mapping(df, "mapping.xlsx")
} # }
```
