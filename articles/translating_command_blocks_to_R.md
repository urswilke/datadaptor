# Translating the Excel mapping commands to R

``` r

library(datadaptor)
```

When a `mapping` object is created,

``` r

mapping_file <- system.file("extdata", "mapping.xlsx", package = "datadaptor")
spss_file <- system.file("extdata", "mtcars_labelled.sav", package = "datadaptor")
m <- Mapping$new(spss_file, mapping_file)
```

the command blocks are translated to a list structure `m$cmd` containing
intermediate results.

## Excel sheets parsed

When the `mapping_file` is passed to construct a `Mapping` object `m`,
the commands of all sheets whose names start with one of the following
strings will be parsed:

``` r

command_block_classes$sheet |>
  na.omit() |>
  unique()
#> [1] "Free"      "Label"     "Variables" "Verbatims"
```

## Parse the sheets to an R list object

The sheets are parsed to a named list `m$cmd$sheet_data_raw` with
dataframes. This is what it looks like for the `"Free1"` sheet of the
Excel file:

``` r

m$cmd$sheet_data_raw$Free1
#> # A tibble: 4 × 6
#>   X1    X2               X3                              X4    X5      row
#>   <chr> <chr>            <chr>                           <chr> <chr> <int>
#> 1 #IF   {vs am} == {0 1} {vs am}2 = {1 2}                NA    NA        4
#> 2 #VALL {vs am}2         New variable label for {vs am}2 NA    NA        6
#> 3 NA    1                Super duper code for value 1    NA    NA        7
#> 4 NA    2                Super duper code for value 2    NA    NA        8
```

## Raw command table

The whole information in `m$cmd$sheet_data_raw` is then joint to a
dataframe

``` r

m$cmd$df_cmd_raw
#> # A tibble: 9 × 5
#>   sheet     action           row                            new_var raw         
#>   <chr>     <chr>            <chr>                          <chr>   <list>      
#> 1 Config    #RECNA           NA                             NA      <named list>
#> 2 Label     #SUMVAR          12, 13, 14, 15, 16, 17, 18, 19 kcarb   <tibble>    
#> 3 Variables #STR2NUM         2                              id      <tibble>    
#> 4 Variables #RENAME_varsheet 3                              car_na… <tibble>    
#> 5 Variables #NEWLAB          4                              mpg     <tibble>    
#> 6 Free1     #IF              4_1                            vs2     <tibble>    
#> 7 Free1     #IF              4_2                            am2     <tibble>    
#> 8 Free1     #VALL            6, 7, 8_1                      vs2     <tibble>    
#> 9 Free1     #VALL            6, 7, 8_2                      am2     <tibble>
```

## Generating `"command_block"`s

Each line in `m$cmd$df_cmd_raw` is translated to a `command_block()`.
The whole resulting list of all lines comprised in a `command_blocks()`
object. These objects have their own printing method. See here for the 3
first elements:

``` r

m$cmd$command_blocks[1:3]
#> [[1]]
#> $sheet
#> [1] "Config"
#> 
#> $action
#> [1] "#RECNA"
#> 
#> $row
#> [1] NA
#> 
#> $new_var
#> [1] NA
#> 
#> $raw
#> $raw[[1]]
#> $raw[[1]]$xs
#> [1] NA
#> 
#> $raw[[1]]$replace_val
#> [1] -2
#> 
#> $raw[[1]]$replace_label
#> [1] "FILTER"
#> 
#> 
#> 
#> $args
#> $args$xs
#> [1] NA
#> 
#> $args$v
#> [1] -2
#> 
#> $args$vallab
#> [1] "FILTER"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_recna_xcpt" "command_block" 
#> 
#> [[2]]
#> $sheet
#> [1] "Label"
#> 
#> $action
#> [1] "#SUMVAR"
#> 
#> $row
#> [1] "12, 13, 14, 15, 16, 17, 18, 19"
#> 
#> $new_var
#> [1] "kcarb"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 8 × 6
#>   var      nv sum_var_label       sum_var_value sum_var_vallab orig_var
#>   <chr> <dbl> <chr>                       <dbl> <chr>          <chr>   
#> 1 carb      1 Carburetor category             1 1 or 2         carb    
#> 2 carb      2 NA                              1 NA             carb    
#> 3 carb      3 NA                              2 3 to 8         carb    
#> 4 carb      4 NA                              2 NA             carb    
#> 5 carb      5 NA                              2 NA             carb    
#> 6 carb      6 NA                              2 NA             carb    
#> 7 carb      7 NA                              2 NA             carb    
#> 8 carb      8 NA                              2 NA             carb    
#> 
#> 
#> $args
#> $args$x
#> [1] "kcarb"
#> 
#> $args$y
#> [1] "carb"
#> 
#> $args$varlab
#> [1] "Carburetor category"
#> 
#> $args$vs0
#> [1] 1 2 3 4 5 6 7 8
#> 
#> $args$vs
#> [1] 1 1 2 2 2 2 2 2
#> 
#> $args$vallabs
#> [1] "1 or 2" NA       "3 to 8" NA       NA       NA       NA       NA      
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_sumvar"    "command_block"
#> 
#> [[3]]
#> $sheet
#> [1] "Variables"
#> 
#> $action
#> [1] "#STR2NUM"
#> 
#> $row
#> [1] "2"
#> 
#> $new_var
#> [1] "id"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 1 × 2
#>   var   type     
#>   <chr> <chr>    
#> 1 id    character
#> 
#> 
#> $args
#> $args$x
#> [1] "id"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_str_to_num" "command_block"
```

But underneath, it is a list where each element has a field `args`. For
instance, the third element looks like this:

``` r

names(m$cmd$command_blocks[[3]])
#> [1] "sheet"   "action"  "row"     "new_var" "raw"     "args"
m$cmd$command_blocks[[3]]$args
#> $x
#> [1] "id"
```

## Overview command table

The whole information is put to `m$cmd_tbl`:

``` r

m$cmd_tbl
#> # A tibble: 9 × 6
#>   sheet     action           row             new_var raw          command_blocks
#>   <chr>     <chr>            <chr>           <chr>   <list>       <unsafe>      
#> 1 Config    #RECNA           NA              NA      <named list> <cmd_rcn_>    
#> 2 Label     #SUMVAR          12, 13, 14, 15… kcarb   <tibble>     <cmd_smvr>    
#> 3 Variables #STR2NUM         2               id      <tibble>     <cmd_st__>    
#> 4 Variables #RENAME_varsheet 3               car_na… <tibble>     <cmd_rnm_>    
#> 5 Variables #NEWLAB          4               mpg     <tibble>     <cmd_nwlb>    
#> 6 Free1     #IF              4_1             vs2     <tibble>     <cmd_if>      
#> 7 Free1     #IF              4_2             am2     <tibble>     <cmd_if>      
#> 8 Free1     #VALL            6, 7, 8_1       vs2     <tibble>     <cmd_st_l>    
#> 9 Free1     #VALL            6, 7, 8_2       am2     <tibble>     <cmd_st_l>
```

## `args` overview table

Lets have a look at a table with an example of the types of the objects
in `args` for each of the `"command_block"` subclasses:

- `x`, `y`: Character strings of variable names in the data set (or to
  be created).
- `varlab` Character string containing a variable label
- `v`: numeric() (or character()) vector; value(s) of a value label
- `vallab`: character() vector; value label(s)
- `id_list`: a list of ids in the data,
- valid R character vectors of R expressions:
  - `ex`: an expression,
  - `ex_cond`: a conditional expression,
  - `ex_fun`: an existing function name
  - `filepath`: a filepath

## Apply command blocks

These command blocks can then be applied to the data with

``` r

m$modify_data()
```

Underneath the hood, this function calls `apply_commands()` and passes
it the arguments `args` (see above).

You can then access the data with

``` r

m$dat_mod
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
```

Click here to show whole list structure print output of `m$cmd`!

``` r

m$cmd
#> $sheet_data_raw
#> $sheet_data_raw$Label
#> # A tibble: 18 × 6
#>    var      nv new_label sum_var_label       sum_var_value sum_var_vallab
#>    <chr> <dbl> <chr>     <chr>                       <dbl> <chr>         
#>  1 cyl       4 NA        NA                             NA NA            
#>  2 cyl       6 NA        NA                             NA NA            
#>  3 cyl       8 NA        NA                             NA NA            
#>  4 vs        0 NA        NA                             NA NA            
#>  5 vs        1 NA        NA                             NA NA            
#>  6 am        0 NA        NA                             NA NA            
#>  7 am        1 NA        NA                             NA NA            
#>  8 gear      3 NA        NA                             NA NA            
#>  9 gear      4 NA        NA                             NA NA            
#> 10 gear      5 NA        NA                             NA NA            
#> 11 carb      1 NA        Carburetor category             1 1 or 2        
#> 12 carb      2 NA        NA                              1 NA            
#> 13 carb      3 NA        NA                              2 3 to 8        
#> 14 carb      4 NA        NA                              2 NA            
#> 15 carb      5 NA        NA                              2 NA            
#> 16 carb      6 NA        NA                              2 NA            
#> 17 carb      7 NA        NA                              2 NA            
#> 18 carb      8 NA        NA                              2 NA            
#> 
#> $sheet_data_raw$Variables
#> # A tibble: 13 × 6
#>    var   varlab                  type      new_label        op    new_name
#>    <chr> <chr>                   <chr>     <chr>            <chr> <chr>   
#>  1 id    NA                      character NA               n     NA      
#>  2 model NA                      character NA               NA    car_name
#>  3 mpg   Miles/(US) gallon       double    Miles per gallon NA    NA      
#>  4 cyl   Number of cylinders     double    NA               NA    NA      
#>  5 disp  Displacement (cu.in.)   double    NA               NA    NA      
#>  6 hp    Gross horsepower        double    NA               NA    NA      
#>  7 drat  Rear axle ratio         double    NA               NA    NA      
#>  8 wt    Weight (1000 lbs)       double    NA               NA    NA      
#>  9 qsec  1/4 mile time           double    NA               NA    NA      
#> 10 vs    Engine                  double    NA               NA    NA      
#> 11 am    Transmission            double    NA               NA    NA      
#> 12 gear  Number of forward gears double    NA               NA    NA      
#> 13 carb  Number of carburetors   double    NA               NA    NA      
#> 
#> $sheet_data_raw$Verbatims
#> NULL
#> 
#> $sheet_data_raw$Free1
#> # A tibble: 4 × 6
#>   X1    X2               X3                              X4    X5      row
#>   <chr> <chr>            <chr>                           <chr> <chr> <int>
#> 1 #IF   {vs am} == {0 1} {vs am}2 = {1 2}                NA    NA        4
#> 2 #VALL {vs am}2         New variable label for {vs am}2 NA    NA        6
#> 3 NA    1                Super duper code for value 1    NA    NA        7
#> 4 NA    2                Super duper code for value 2    NA    NA        8
#> 
#> 
#> $sheet_command_tables_raw
#> $sheet_command_tables_raw$Config
#> # A tibble: 1 × 5
#>   sheet  action row   new_var raw             
#>   <chr>  <chr>  <chr> <chr>   <list>          
#> 1 Config #RECNA NA    NA      <named list [3]>
#> 
#> $sheet_command_tables_raw$Label
#> # A tibble: 1 × 5
#>   sheet action  new_var row                            raw             
#>   <chr> <chr>   <chr>   <chr>                          <list>          
#> 1 Label #SUMVAR kcarb   12, 13, 14, 15, 16, 17, 18, 19 <tibble [8 × 6]>
#> 
#> $sheet_command_tables_raw$Variables
#> # A tibble: 3 × 5
#>   row   sheet     action           new_var  raw             
#>   <chr> <chr>     <chr>            <chr>    <list>          
#> 1 2     Variables #STR2NUM         id       <tibble [1 × 2]>
#> 2 3     Variables #RENAME_varsheet car_name <tibble [1 × 2]>
#> 3 4     Variables #NEWLAB          mpg      <tibble [1 × 4]>
#> 
#> $sheet_command_tables_raw$Verbatims
#> NULL
#> 
#> $sheet_command_tables_raw$Free1
#> # A tibble: 4 × 4
#>   row       action new_var raw             
#>   <chr>     <chr>  <chr>   <list>          
#> 1 4_1       #IF    vs2     <tibble [1 × 5]>
#> 2 4_2       #IF    am2     <tibble [1 × 5]>
#> 3 6, 7, 8_1 #VALL  vs2     <tibble [3 × 5]>
#> 4 6, 7, 8_2 #VALL  am2     <tibble [3 × 5]>
#> 
#> 
#> $df_cmd_raw
#> # A tibble: 9 × 5
#>   sheet     action           row                            new_var raw         
#>   <chr>     <chr>            <chr>                          <chr>   <list>      
#> 1 Config    #RECNA           NA                             NA      <named list>
#> 2 Label     #SUMVAR          12, 13, 14, 15, 16, 17, 18, 19 kcarb   <tibble>    
#> 3 Variables #STR2NUM         2                              id      <tibble>    
#> 4 Variables #RENAME_varsheet 3                              car_na… <tibble>    
#> 5 Variables #NEWLAB          4                              mpg     <tibble>    
#> 6 Free1     #IF              4_1                            vs2     <tibble>    
#> 7 Free1     #IF              4_2                            am2     <tibble>    
#> 8 Free1     #VALL            6, 7, 8_1                      vs2     <tibble>    
#> 9 Free1     #VALL            6, 7, 8_2                      am2     <tibble>    
#> 
#> $command_blocks
#> [[1]]
#> $sheet
#> [1] "Config"
#> 
#> $action
#> [1] "#RECNA"
#> 
#> $row
#> [1] NA
#> 
#> $new_var
#> [1] NA
#> 
#> $raw
#> $raw[[1]]
#> $raw[[1]]$xs
#> [1] NA
#> 
#> $raw[[1]]$replace_val
#> [1] -2
#> 
#> $raw[[1]]$replace_label
#> [1] "FILTER"
#> 
#> 
#> 
#> $args
#> $args$xs
#> [1] NA
#> 
#> $args$v
#> [1] -2
#> 
#> $args$vallab
#> [1] "FILTER"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_recna_xcpt" "command_block" 
#> 
#> [[2]]
#> $sheet
#> [1] "Label"
#> 
#> $action
#> [1] "#SUMVAR"
#> 
#> $row
#> [1] "12, 13, 14, 15, 16, 17, 18, 19"
#> 
#> $new_var
#> [1] "kcarb"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 8 × 6
#>   var      nv sum_var_label       sum_var_value sum_var_vallab orig_var
#>   <chr> <dbl> <chr>                       <dbl> <chr>          <chr>   
#> 1 carb      1 Carburetor category             1 1 or 2         carb    
#> 2 carb      2 NA                              1 NA             carb    
#> 3 carb      3 NA                              2 3 to 8         carb    
#> 4 carb      4 NA                              2 NA             carb    
#> 5 carb      5 NA                              2 NA             carb    
#> 6 carb      6 NA                              2 NA             carb    
#> 7 carb      7 NA                              2 NA             carb    
#> 8 carb      8 NA                              2 NA             carb    
#> 
#> 
#> $args
#> $args$x
#> [1] "kcarb"
#> 
#> $args$y
#> [1] "carb"
#> 
#> $args$varlab
#> [1] "Carburetor category"
#> 
#> $args$vs0
#> [1] 1 2 3 4 5 6 7 8
#> 
#> $args$vs
#> [1] 1 1 2 2 2 2 2 2
#> 
#> $args$vallabs
#> [1] "1 or 2" NA       "3 to 8" NA       NA       NA       NA       NA      
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_sumvar"    "command_block"
#> 
#> [[3]]
#> $sheet
#> [1] "Variables"
#> 
#> $action
#> [1] "#STR2NUM"
#> 
#> $row
#> [1] "2"
#> 
#> $new_var
#> [1] "id"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 1 × 2
#>   var   type     
#>   <chr> <chr>    
#> 1 id    character
#> 
#> 
#> $args
#> $args$x
#> [1] "id"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_str_to_num" "command_block" 
#> 
#> [[4]]
#> $sheet
#> [1] "Variables"
#> 
#> $action
#> [1] "#RENAME_varsheet"
#> 
#> $row
#> [1] "3"
#> 
#> $new_var
#> [1] "car_name"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 1 × 2
#>   new_names vars     
#>   <list>    <list>   
#> 1 <chr [1]> <chr [1]>
#> 
#> 
#> $args
#> $args$xs
#> [1] "car_name"
#> 
#> $args$ys
#> [1] "model"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_rename_varsheet" "command_block"      
#> 
#> [[5]]
#> $sheet
#> [1] "Variables"
#> 
#> $action
#> [1] "#NEWLAB"
#> 
#> $row
#> [1] "4"
#> 
#> $new_var
#> [1] "mpg"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 1 × 4
#>   var   new_label        varlab            type  
#>   <chr> <chr>            <chr>             <chr> 
#> 1 mpg   Miles per gallon Miles/(US) gallon double
#> 
#> 
#> $args
#> $args$x
#> [1] "mpg"
#> 
#> $args$varlab
#> [1] "Miles per gallon"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_newlab"    "command_block"
#> 
#> [[6]]
#> $sheet
#> [1] "Free1"
#> 
#> $action
#> [1] "#IF"
#> 
#> $row
#> [1] "4_1"
#> 
#> $new_var
#> [1] "vs2"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 1 × 5
#>   X1    X2      X3      X4    X5   
#>   <chr> <chr>   <chr>   <chr> <chr>
#> 1 #IF   vs == 0 vs2 = 1 NA    NA   
#> 
#> 
#> $args
#> $args$x
#> [1] "vs2"
#> 
#> $args$ex
#> [1] "1"
#> 
#> $args$ex_cond
#> [1] "vs == 0"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_if"        "command_block"
#> 
#> [[7]]
#> $sheet
#> [1] "Free1"
#> 
#> $action
#> [1] "#IF"
#> 
#> $row
#> [1] "4_2"
#> 
#> $new_var
#> [1] "am2"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 1 × 5
#>   X1    X2      X3      X4    X5   
#>   <chr> <chr>   <chr>   <chr> <chr>
#> 1 #IF   am == 1 am2 = 2 NA    NA   
#> 
#> 
#> $args
#> $args$x
#> [1] "am2"
#> 
#> $args$ex
#> [1] "2"
#> 
#> $args$ex_cond
#> [1] "am == 1"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_if"        "command_block"
#> 
#> [[8]]
#> $sheet
#> [1] "Free1"
#> 
#> $action
#> [1] "#VALL"
#> 
#> $row
#> [1] "6, 7, 8_1"
#> 
#> $new_var
#> [1] "vs2"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 3 × 5
#>   X1    X2    X3                           X4    X5   
#>   <chr> <chr> <chr>                        <chr> <chr>
#> 1 #VALL vs2   New variable label for vs2   NA    NA   
#> 2 NA    1     Super duper code for value 1 NA    NA   
#> 3 NA    2     Super duper code for value 2 NA    NA   
#> 
#> 
#> $args
#> $args$x
#> [1] "vs2"
#> 
#> $args$varlab
#> [1] "New variable label for vs2"
#> 
#> $args$vs
#> [1] 1 2
#> 
#> $args$vallabs
#> [1] "Super duper code for value 1" "Super duper code for value 2"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_set_labs"  "command_block"
#> 
#> [[9]]
#> $sheet
#> [1] "Free1"
#> 
#> $action
#> [1] "#VALL"
#> 
#> $row
#> [1] "6, 7, 8_2"
#> 
#> $new_var
#> [1] "am2"
#> 
#> $raw
#> $raw[[1]]
#> # A tibble: 3 × 5
#>   X1    X2    X3                           X4    X5   
#>   <chr> <chr> <chr>                        <chr> <chr>
#> 1 #VALL am2   New variable label for am2   NA    NA   
#> 2 NA    1     Super duper code for value 1 NA    NA   
#> 3 NA    2     Super duper code for value 2 NA    NA   
#> 
#> 
#> $args
#> $args$x
#> [1] "am2"
#> 
#> $args$varlab
#> [1] "New variable label for am2"
#> 
#> $args$vs
#> [1] 1 2
#> 
#> $args$vallabs
#> [1] "Super duper code for value 1" "Super duper code for value 2"
#> 
#> 
#> attr(,"row.names")
#> [1] 1
#> attr(,"class")
#> [1] "cmd_set_labs"  "command_block"
#> 
#> attr(,"class")
#> [1] "unsafe"         "command_blocks" "list"
```
