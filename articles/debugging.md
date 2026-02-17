# debugging

## Debugging

In order to debug the command blocks of a mapping you can set the option
`debug = TRUE`.

When the execution of a code block runs into an error, this then jumps
into the code. We’ll sneak an error in this `#IF` `command_block` (In X2
you have to write a string containing a valid logical expression):

``` r

library(datadaptor)
free_commands <- tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5, ~row,
  "#IF", "q1 ===#$%#!@ 18", "q2 = 2", "", "", 6
)
free_commands
```

When we construct our `Mapping` object:

``` r

m <- Mapping$new(
  tibble::tibble(q1 = 18),
  list(Free = free_commands),
  debug = TRUE
)
```

end then execute the modifications, the debugger stops at the
[`browser()`](https://rdrr.io/r/base/browser.html).

``` r

m$modify_data()
```

and you will see the command prompt of the debugger:

`Browse[1]>`

There, you can move into the function that produces the error by
continuing (pressing `Shift` + `F5` in RStudio).
