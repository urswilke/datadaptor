# `command_block` overview

A dataset containing the list of `keyword`s that can be used in the
Excel mapping file to generate command_block objects.

## Usage

``` r
command_block_classes
```

## Format

A data frame of 26 `keyword`s and their corresponding command_block
classes:

- keyword:

  Excel mapping file keyword

- command_block:

  String denoting the name of the command_block subclass

- sheet:

  The sheet(s) in the Excel mapping file from where this command can be
  called

## Examples

``` r
# print all rows of tibble:
print(command_block_classes, n = 111)
#> # A tibble: 28 × 3
#>    keyword             command_block       sheet    
#>    <chr>               <chr>               <chr>    
#>  1 #RECNA              cmd_recna_xcpt      NA       
#>  2 #IF                 cmd_if              Free     
#>  3 #COMP               cmd_comp            Free     
#>  4 #VARL               cmd_set_lab         Free     
#>  5 #VALL               cmd_set_labs        Free     
#>  6 #REC                cmd_rec             Free     
#>  7 #SUMVAR             cmd_sumvar          Label    
#>  8 #AVALL              cmd_add_labs        Free     
#>  9 #DIC                cmd_dic             Free     
#> 10 #AUTOREC            cmd_autorec         Variables
#> 11 #STR2NUM            cmd_str_to_num      Variables
#> 12 #RENAME_varsheet    cmd_rename_varsheet Variables
#> 13 #RENAME             cmd_rename          Free     
#> 14 #MERGE              cmd_merge           Free     
#> 15 #NEWVALL            cmd_newvall         Label    
#> 16 #verbatim           cmd_verbatim        Verbatims
#> 17 cmd_verbatim_custom cmd_verbatim_custom Verbatims
#> 18 #DROP               cmd_drop            Variables
#> 19 #NEWLAB             cmd_newlab          Variables
#> 20 #KG                 cmd_kg              Free     
#> 21 #RFUN               cmd_rfun            Free     
#> 22 #R                  cmd_r               Free     
#> 23 #RMVAL              cmd_rmval           Free     
#> 24 #ADDFILE            cmd_addfile         Free     
#> 25 #SELECT             cmd_select          Free     
#> 26 #FILTER             cmd_filter          Free     
#> 27 #ACROSS             cmd_across          Free     
#> 28 #DEBUG              cmd_debug           Free     
```
