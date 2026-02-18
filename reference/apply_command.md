# Apply a command block to the data

see
[`vignette("command_blocks")`](https://urswilke.codeberg.page/datadaptor/articles/command_blocks.md)

## Usage

``` r
apply_command(cdb, mapping, ...)

# S3 method for class 'cmd_recna_xcpt'
apply_command(cdb, mapping, xs, v, vallab, ...)

# S3 method for class 'cmd_r'
apply_command(cdb, mapping, exs, ...)

# S3 method for class 'cmd_rfun'
apply_command(cdb, mapping, filepath, ex_fun, ...)

# S3 method for class 'cmd_kg'
apply_command(cdb, mapping, x, y, ...)

# S3 method for class 'cmd_drop'
apply_command(cdb, mapping, xs, ...)

# S3 method for class 'cmd_select'
apply_command(cdb, mapping, exs, ...)

# S3 method for class 'cmd_across'
apply_command(cdb, mapping, exs, ex_fun, exs_fns_names, ex_names, ...)

# S3 method for class 'cmd_filter'
apply_command(cdb, mapping, exs, ...)

# S3 method for class 'cmd_verbatim'
apply_command(
  cdb,
  mapping,
  x,
  v,
  varlab,
  vs,
  vallabs,
  id_list,
  v0,
  ex_further_cond,
  id = mapping$opts$da$id_var,
  ...
)

# S3 method for class 'cmd_verbatim_custom'
apply_command(
  cdb,
  mapping,
  x,
  varlab,
  vs,
  vallabs,
  id_list,
  v0,
  ex_further_cond,
  ex_assign,
  id = mapping$opts$da$id_var,
  ...
)

# S3 method for class 'cmd_merge'
apply_command(cdb, mapping, xs, filepath, id, coal, ...)

# S3 method for class 'cmd_addfile'
apply_command(cdb, mapping, filepath, ...)

# S3 method for class 'cmd_rename_varsheet'
apply_command(cdb, mapping, xs, ys, ...)

# S3 method for class 'cmd_rename'
apply_command(cdb, mapping, xs, ys, ...)

# S3 method for class 'cmd_if'
apply_command(cdb, mapping, x, ex_cond, ex, ...)

# S3 method for class 'cmd_comp'
apply_command(cdb, mapping, x, ex, ...)

# S3 method for class 'cmd_debug'
apply_command(cdb, mapping, ...)

# S3 method for class 'cmd_set_lab'
apply_command(cdb, mapping, x, varlab, ...)

# S3 method for class 'cmd_newlab'
apply_command(cdb, mapping, x, varlab, ...)

# S3 method for class 'cmd_rmval'
apply_command(cdb, mapping, x, y, vs, varlab, ...)

# S3 method for class 'cmd_set_labs'
apply_command(cdb, mapping, x, varlab, vs, vallabs, ...)

# S3 method for class 'cmd_add_labs'
apply_command(cdb, mapping, x, varlab = NULL, vs, vallabs, ...)

# S3 method for class 'cmd_newvall'
apply_command(cdb, mapping, x, varlab = NULL, vs, vallabs, ...)

# S3 method for class 'cmd_rec'
apply_command(cdb, mapping, x, y, varlab, vs0, vs, vs2, vallabs, ...)

# S3 method for class 'cmd_sumvar'
apply_command(cdb, mapping, x, y, varlab, vs0, vs, vallabs, ...)

# S3 method for class 'cmd_dic'
apply_command(cdb, mapping, x, y, ...)

# S3 method for class 'cmd_autorec'
apply_command(cdb, mapping, x, ...)

# S3 method for class 'cmd_str_to_num'
apply_command(cdb, mapping, x, ...)
```

## Arguments

- cdb:

  `command_block` object

- mapping:

  mapping object

- ...:

  Arguments passed to method

- v, v0, vs, vs0, vs2:

  Numeric value(s)

- vallab, vallabs:

  Value label(s)

- filepath:

  Character string containing valid file path

- x, xs, y, ys:

  character string (vector) of variable names in `mapping$dat_mod`

- varlab:

  Character string containing a variable label

- id_list:

  Vector of id values in `mapping$dat_mod[id]`.

- id:

  Character string of the variable name of the id variable in
  `mapping$dat`.

- coal:

  Character string containing either `"xy"` or `"yx"`. This determines
  if
  [`powerjoin::coalesce_xy()`](https://rdrr.io/pkg/powerjoin/man/coalesce_xy.html)
  or
  [`powerjoin::coalesce_yx()`](https://rdrr.io/pkg/powerjoin/man/coalesce_xy.html)
  is used when merging data with variables that already exist.

- ex, exs, ex_cond, ex_fun, ex_further_cond, ex_assign, exs_fns_names,
  ex_names:

  Character strings containing valid R expressions. They will be
  evaluated in `mapping$opts$da$expr_eval_env` (see
  [`get_mapping_options()`](https://urswilke.codeberg.page/datadaptor/reference/get_mapping_options.md)),
  except `exs` which contains a list of expressions evaluated in the
  global environment.

## Methods (by class)

- `apply_command(cmd_recna_xcpt)`: Replace missing values of the
  labelled variables in `mapping$dat_mod` (except those specified in
  `xs`) with the value `v`, labelled `vallab`.

- `apply_command(cmd_r)`: Execute R code

- `apply_command(cmd_rfun)`: Execute the function named `ex_fun` and
  defined in the R script named `filepath`.

- `apply_command(cmd_kg)`: Split variable

- `apply_command(cmd_drop)`:

- `apply_command(cmd_select)`:

- `apply_command(cmd_across)`:

- `apply_command(cmd_filter)`:

- `apply_command(cmd_verbatim)`:

- `apply_command(cmd_verbatim_custom)`:

- `apply_command(cmd_merge)`:

- `apply_command(cmd_addfile)`:

- `apply_command(cmd_rename_varsheet)`:

- `apply_command(cmd_rename)`:

- `apply_command(cmd_if)`:

- `apply_command(cmd_comp)`:

- `apply_command(cmd_debug)`:

- `apply_command(cmd_set_lab)`:

- `apply_command(cmd_newlab)`:

- `apply_command(cmd_rmval)`:

- `apply_command(cmd_set_labs)`:

- `apply_command(cmd_add_labs)`:

- `apply_command(cmd_newvall)`:

- `apply_command(cmd_rec)`:

- `apply_command(cmd_sumvar)`:

- `apply_command(cmd_dic)`:

- `apply_command(cmd_autorec)`:

- `apply_command(cmd_str_to_num)`:

## Examples

``` r
# see vignette("command_blocks")
```
