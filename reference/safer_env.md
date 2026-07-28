# Execution environments

The default environment where expressions from the Excel mapping file
are evaluated is baseenv(). (see argument `expr_eval_env` of
`?get_mapping_options()`). For a safer option you can use `safer_env`
which only contains a selection of base R functions (see example).
Additionally to the functions in the used environment, the object
`dat_mod` is added to the environment which represents the current state
of the data in `Mapping$dat_mod`.

## Usage

``` r
safer_env
```

## Examples

``` r
safer_env |>
  as.list() |>
  names()
#>  [1] "%/%"          "digamma"      "sqrt"         "tanh"         "cosh"        
#>  [6] "list"         "sinh"         "cumsum"       "expm1"        "acos"        
#> [11] "log1p"        "%>%"          "as.character" "["            "trunc"       
#> [16] "<-"           "^"            "%%"           "case_when"    "as.numeric"  
#> [21] "c"            "log10"        "trigamma"     "cos"          "lgamma"      
#> [26] "atan"         "cummin"       "ceiling"      "is.na"        "ifelse"      
#> [31] "%in%"         "!"            "<="           "attr"         "&"           
#> [36] "log"          "("            "*"            "+"            "cumprod"     
#> [41] "-"            "tan"          "floor"        "mean"         "{"           
#> [46] "/"            "|"            "as.logical"   "=="           "atanh"       
#> [51] "acosh"        "gamma"        "data.frame"   "sign"         "asin"        
#> [56] "rowSums"      "asinh"        "sinpi"        "[<-"          "attr<-"      
#> [61] "!="           ":"            "<"            "="            ">"           
#> [66] "cummax"       ">="           "log2"         "abs"          "cospi"       
#> [71] "tanpi"        "sin"          "exp"          "function"    
# Apart from base R functions it also contains `dplyr::case_when()`:
safer_env$case_when
#> function (..., .default = NULL, .unmatched = "default", .ptype = NULL, 
#>     .size = NULL) 
#> {
#>     args <- eval_formulas(..., allow_empty_dots = FALSE)
#>     conditions <- args$lhs
#>     values <- args$rhs
#>     .size <- case_when_size_common(conditions = conditions, values = values, 
#>         size = .size)
#>     conditions <- vec_recycle_common(!!!conditions, .size = .size)
#>     vec_case_when(conditions = conditions, values = values, default = .default, 
#>         unmatched = .unmatched, ptype = .ptype, size = .size, 
#>         conditions_arg = "", values_arg = "", default_arg = ".default", 
#>         error_call = current_env())
#> }
#> <bytecode: 0x55618f519000>
#> <environment: namespace:dplyr>
# To use it in a mapping, you can do:
if (FALSE) { # \dontrun{
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
m <- Mapping$new(spss_file, mapping_file, expr_eval_env = safer_env)
} # }
```
