# Documentation of the Excel mapping command blocks

## Command block overview

In this document, we will show how the different command blocks in
datadaptor work. There are the following keywords that you can use to
enter the command blocks in your Excel mapping file:

[TABLE]

*The column* `"command_block"` *shows the class, which determines how
datadaptor parses the command block* (with `parse_command_args()`) *and
then applies it on the data* (with
[`apply_command()`](https://urswilke.codeberg.page/datadaptor/reference/apply_command.md)).

## Command block examples

## Illustration of labelled datasets

In this article we’ll talk about labelled datasets. Therefore, we’ll
first explain how we’ll illustrate these datasets:

[TABLE]

The table shows a dataset containing the variables `q1`, `q2`& `q3`,
each containing 3 observations. In the `values` section, the data is
shown. `q1` & `q2` are numeric and `q3` is a string variable. Below
follows the section containing the `labels` in the data. The `varlab`
row in green shows the variable labels. `q1` is labelled with “hello”,
and `q2` is labelled with “how are you?”. Below, the labelled values are
shown. In `q1` value 1 is labelled by “a” and 2 is labelled by “b”. In
`q2` value 2 is labelled by “c” and 3 is labelled by “d”. The variable
`q3` is not labelled.

In the following sections we’ll explain, how an initial dataset is then
modified by command blocks from an Excel mapping file resulting in the
modified dataset.

## `Free` sheets

Here we’ll look at examples how various commands in the `Free` sheets
can look like.

### `#VARL`

[TABLE]

&

| A      | B   | C                       |
|--------|-----|-------------------------|
| \#VARL | q1  | assigned variable label |

=\>

[TABLE]

Actually, this command does not change the values, but it assigns the
variable label specified in column **C** of the command to the variable
specified in column **B**.

### `#VALL`

Assign **val**ue **l**abels

[TABLE]

&

[TABLE]

=\>

[TABLE]

This command also does not change the values. Just like `#VARL`, it
assigns the variable label specified in the first row of column **C**
(if empty, it keeps the variable label, if already existing) to the
variable specified in the first row in column **B**. It also assigns the
value labels in column **C** to the values in column **B** in the
following rows of the command.

### `#AVALL`

**A**dd **val**ue **l**abels

[TABLE]

&

[TABLE]

=\>

[TABLE]

`#AVALL` does the same as `#VALL`, except that it keeps the value values
of the original variable, if they are not overwritten.

### `#RMVAL`

**R**e**m**ove **val**ues and their labels

[TABLE]

&

[TABLE]

=\>

[TABLE]

Here, the `#RMVAL` command makes a copy of `q1`, named `q2`, and removes
the specified values. (In the first line of the command block, column
**B** specifies the variable to be recoded, and in column **C** the name
of the recoded variable. Column **D** assigns the new variable label.)
In the following rows you specify the values and their labels to be
removed in column **B**.

### `#COMP`

#### Example

[TABLE]

&

| A      | B   | C   |
|--------|-----|-----|
| \#COMP | q2  | 5   |

=\>

[TABLE]

This command **comp**utes a new variable (specified in column **B**)
with the value in column **C**.

#### Example

You can also assign a variable to the values of the new variable. In
this case, the labels of the original variable are also copied:

[TABLE]

&

| A      | B   | C   |
|--------|-----|-----|
| \#COMP | q2  | q1  |

=\>

[TABLE]

### `#IF`

#### Example

[TABLE]

&

| A    | B        | C      |
|------|----------|--------|
| \#IF | q1 \>= 2 | q2 = 5 |

=\>

[TABLE]

This command takes a condition (more precisely a logical vector of
length of the variables in the data) in column **B** and an assignment
in column **C** (of the form `<variable name> = <assigned values>`).
When the condition is `TRUE`, the expression (`<assigned values>`) is
assigned to `<variable name>`. In this case, the value 5 is assigned to
`q2` where `q1` is greater or equal to 2. In this case `q2` didn’t exist
in the data before, and thus is initialized to `NA` before.

#### Example

If the variable existed before, the values where the condition evaluates
to `FALSE` are kept, as can be seen in the next example:

[TABLE]

&

| A    | B        | C      |
|------|----------|--------|
| \#IF | q1 \>= 2 | q2 = 5 |

=\>

[TABLE]

Here the value of 7 in the first row is kept from the original data.

#### Example

The `#IF` command preserves labels, if an already existing variable is
modified:

[TABLE]

&

| A    | B        | C      |
|------|----------|--------|
| \#IF | q1 \>= 2 | q1 = 5 |

=\>

[TABLE]

### \#REC

#### Example

[TABLE]

&

[TABLE]

=\>

[TABLE]

The `#REC` command **rec**odes variables. In this example `q1` is
recoded to `kq1`. (In the first line of the command block, column **B**
specifies the variable to be recoded, and in column **C** the name of
the recoded variable. Column **D** assigns the new variable label.) In
the following rows you specify the intervals to be recoded in column
**B** and **C**, column **D** specifies the new value and column **E**
its label. So for instance, the second line specifies, that all values
in `q1` between 1 and 2 are recoded to 1 in `kq1` with the value label
`a & b`.

#### Example

If you don’t specify the variable label (column **D**, first row), the
one of the original variable is copied:

[TABLE]

&

[TABLE]

=\>

[TABLE]

#### Example

If the name of the recoded variable is the same as the original
variable, the values that are not recoded are kept:

[TABLE]

&

[TABLE]

=\>

[TABLE]

### \#KG

#### Example

[TABLE]

&

| A    | B   | C   |
|------|-----|-----|
| \#KG | q1  | q2  |

=\>

[TABLE]

The `#KG` command is useful to calculate cross-tabulations for subsets.
It computes new variables for all the value labels of the variable `q2`
(in column **C**). The value labels are copied from `q1` (the variable
in column **B**). The new variable labels are a combination of the value
labels of `q2` and the variable label of `q1`. The values are copied of
`q1` if `q2` takes the value specified in the variable label and are
`NA` otherwise.

### \#SELECT

This command block passes the arguments in column **B** to
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html).
However, renaming doesn’t work (see `#RENAME` to do this). It can be
used to remove and reorder variables in the dataset.

#### Example

This removes the variable `a2`:

[TABLE]

&

| A        | B   |
|----------|-----|
| \#SELECT | -a2 |

=\>

[TABLE]

#### Example

[TABLE]

&

| A        | B               |
|----------|-----------------|
| \#SELECT | matches("a\\d") |

=\>

[TABLE]

#### Example

In order to keep all variables, and only reorder those named before, you
can pass `everything()` in the end:

[TABLE]

&

| A        | B               |
|----------|-----------------|
| \#SELECT | matches("a\\d") |
|          | everything()    |

=\>

[TABLE]

### \#RENAME

#### Example

This command renames variables in column **B** to the names in column
**C**:

[TABLE]

&

| A        | B   | C               |
|----------|-----|-----------------|
| \#RENAME | a2  | new_name_for_a2 |
|          | b2  | new_name_for_b2 |

=\>

[TABLE]

### \#ACROSS

This command block has the same tidyselect selection semantics as
`#SELECT`. It then applies the function in column **C** by executing
`df |> dplyr::mutate(dplyr::across(var_selection, fun))` where `df` is
the current data, `var_selection` the selected variables in column
**B**, and `fun` the function.

#### Example

This takes all numeric variables from `a1` to `b2` and calculates the
deviation to their mean :

[TABLE]

&

[TABLE]

=\>

[TABLE]

Instead of `"function(x) x - mean(x)"` you can also use the short form
`"\(x) x - mean(x)"`, or write intermediate steps and by using curly
braces and separating statements with semi-colons like
`"\(x) {res <- x - mean(x); res}"` (also see
[`?"{"`](https://rdrr.io/r/base/Paren.html)).

#### Example

Here is a very clunky function applied on `a1` & `b2` that sets the
value -2 to `NA` and removes its value label.

[TABLE]

&

[TABLE]

=\>

[TABLE]

This function does the same as `#RMVAL`.

#### Example

It is also possible to provide the `.names` argument in the first row of
column **C**. And you can provide a list of multiple functions to the
`.fns` argument in the following rows. You can also give names to the
functions in column **B**.

[TABLE]

&

| A | B | C |
|----|----|----|
| \#ACROSS | where(is.numeric) & a1:b2 | {.col}\_\_\_{.fn} |
|  | rm_val | function(x) {x\[x == -2\] \<- NA; vall \<- attr(x, "labels"); attr(x, "labels") \<- vall\[vall != -2\]; x} |
|  | mean | mean |

=\>

[TABLE]

See the documentation of
[`dplyr::across()`](https://dplyr.tidyverse.org/reference/across.html)
for a more thorough documentation.

## `curlychop()`

The idea of the function
[`curlychop()`](https://urswilke.codeberg.page/datadaptor/reference/curlychop.md)
is to prevent you from writing redundant code by turning one line into
several commands. Let’s have a first look at it with the help of an
example.

#### Example

Let’s assume you want to make copies of several variables, all ending
with the same suffix “1”. You can do this by using several `#COMP`
commands:

[TABLE]

&

| A      | B   | C   |
|--------|-----|-----|
| \#COMP | ka1 | a1  |
| \#COMP | kb1 | b1  |

=\>

[TABLE]

The function
[`curlychop()`](https://urswilke.codeberg.page/datadaptor/reference/curlychop.md)
lets you write these commands in a more succinct form:

| X1     | X2      | X3     |
|--------|---------|--------|
| \#COMP | k{a b}1 | {a b}1 |

It replaces the curly braces by each of the parts inside (separated by
spaces). You can put as many parts inside the curly braces as you want,
but in the examples we’ll only write 2 parts to save the eye.

#### Example

You can also write multiple parts with curly braces inside one cell

[TABLE]

&

| A    | B               | C               |
|------|-----------------|-----------------|
| \#IF | {a b}1 == {1 4} | k{a b}1 = {5 6} |

=\>

[TABLE]

The above command block is equivalent to these 2 `#IF` commands:

| A    | B       | C       |
|------|---------|---------|
| \#IF | a1 == 1 | ka1 = 5 |
| \#IF | b1 == 4 | kb1 = 6 |

#### Example

For commands spanning multiple rows, you can also use
[`curlychop()`](https://urswilke.codeberg.page/datadaptor/reference/curlychop.md)
in the first row:

[TABLE]

&

[TABLE]

=\>

[TABLE]

The above command block is equivalent to these 2 `#REC` commands:

[TABLE]

## `Variables` sheets

To enter commands here, you don’t need to specify the commands, as in
the `Free` sheets. Instead you need to put the information in one of the
columns `op`, `new_name` or `new_label`:

### \#RENAME_varsheet

#### Example

This command renames the variables specified in the `var` column (column
**A**) to the names in the `new_name` column. It does the same as the
`#RENAME` command.

[TABLE]

&

| var | new_name |
|-----|----------|
| a1  | c1       |
| b1  | d1       |

=\>

[TABLE]

### \#NEWLAB

#### Example

This command assigns new variable labels (specified in the `new_label`
column) to the variables specified in the `var` column (column **A**).
It does the same as the `#VARL` command.

[TABLE]

&

[TABLE]

=\>

[TABLE]

### \#DROP

#### Example

This command removes the variables marked with `d` (for “drop”) in the
`op` column:

[TABLE]

&

| var | op  |
|-----|-----|
| a1  | d   |
| b1  |     |

=\>

[TABLE]

The result is the same as specifying `#SELECT -a1` on a `Free` sheet.

### \#STR2NUM

#### Example

This command turns string variables into numeric ones by putting an `n`
(for “numeric”) in the `op` column:

[TABLE]

&

| var | op  |
|-----|-----|
| a1  | n   |
| b1  |     |

=\>

[TABLE]

### \#AUTORECODE

#### Example

This command autorecodes string variables by putting `a` (for
“autorecode”) in the `op` column. It assigns labelled values (1, 2, 3,
…), ordered alphabetically:

[TABLE]

&

| var | op  |
|-----|-----|
| a1  | a   |

=\>

[TABLE]

## `Label` sheets

Here, you can modify value labels or create new variable

### \#SUMVAR

#### Example

This command recodes variables specified in the `var` column (column
**A**) to new variables, by attaching a “k” prefix. It is very similar
to the `#REC` command.

[TABLE]

&

[TABLE]

=\>

[TABLE]

All values of `a1` (specified by `nv`) that are assigned to the same
value under `sum_var_value` are mapped onto that value (labelled by the
string in the first row where this `sum_var_value` occurs). The assigned
variable label of the summary variable is specified in the first row of
`sum_var_label` (if empty the variable label of the original variable is
copied).

### \#NEWVALL

#### Example

This command replaces value labels like `#AVALL`:

[TABLE]

&

[TABLE]

=\>

[TABLE]

## `#RECNA`

This command is executed per default (unless you set the parameter
`na_to_filter` to `FALSE` when creating the `Mapping` object with

``` r

Mapping$new(na_to_filter = FALSE)
```

for instance). It:

- recodes missing values in all numeric variables in the dataset to `-2`
  (cf. parameter `miss_rec_val` in
  [`get_mapping_options()`](https://urswilke.codeberg.page/datadaptor/reference/get_mapping_options.md)),
  and
- labels this value by `FILTER` (cf. parameter `miss_rec_lab` in
  [`get_mapping_options()`](https://urswilke.codeberg.page/datadaptor/reference/get_mapping_options.md))
  in these variables

Under the hood, this will call the function
[`set_na_to_filter()`](https://urswilke.codeberg.page/datadaptor/reference/set_na_to_filter.md)
on all the numeric variables. You can make exceptions for the variable
names (space-separated & defined in the parameter string
`not_miss_to_filter_vars`; also see
[`get_mapping_options()`](https://urswilke.codeberg.page/datadaptor/reference/get_mapping_options.md)).

[TABLE]

&

| A    | B      | C     |
|------|--------|-------|
| \#IF | a == 1 | d = 2 |

=\>

[TABLE]

The missing values in the variables `a` & `b` were changed to `-2` and
the value label of `-2 = FILTER` was added. The variable `d` that was
generated by the `#COMP` command is not touched, as the `#RECNA` command
is executed in the very beginning of all commands in the mapping and
thus only affects the numeric variables present in the original dataset.
