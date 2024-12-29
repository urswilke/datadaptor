library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(datadaptor)
my_functions <- lsf.str("package:datadaptor") |> str_remove(" : .*") |> walk(prefixer::import_from) |> capture.output() |> str_subset("^$", negate = TRUE)

df <- tibble(import_string = my_functions) |>
  mutate(
    pkg = import_string |> str_remove("#' @importFrom ") |> str_remove(" .*"),
    fun = import_string |> str_remove("#' @importFrom [A-Za-z\\.]+ ") |> strsplit(" ")
  ) |>
  unnest(fun) |>
  distinct(pkg, fun) |>
  group_by(pkg) |>
  arrange(fun) |>
  # summarise(paste(fun, collapse = " ")) |>
  summarise(funs = list(fun)) |>
  filter(pkg != "datadaptor")
walk2(
  df$pkg,
  df$funs,
  ~ usethis::use_import_from(.x, .y, load = FALSE)
)
