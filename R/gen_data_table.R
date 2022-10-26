#' Generate data counts table
#'
#' @param df dataframe
#' @param values_drop_na remove missing values? (passed to `tidyr::pivot_longer()`.)
#'
#' @return Counts and labels data frame
#' @export
#'
#' @examples
#' gen_data_table(fake_survey)
gen_data_table <- function(df, values_drop_na = TRUE) {
  counts <- lengthen(df, values_drop_na) |>
    dplyr::mutate(var = forcats::as_factor(var)) |>
    dplyr::group_by_all() |>
    dplyr::tally(name = "Freq") |>
    dplyr::ungroup()

  var <- gen_var_table(df) %>%
    dplyr::select(c("var","type", "varlab"))

  label <- tablab::tab_vallabs(df) %>%
    dplyr::select(c("var","nv", "vallab"))

  counts |>
    dplyr::full_join(label, by=c("var", "double" = "nv")) |>
    dplyr::full_join(var, by=c("var"))
}

lengthen <- function(df, values_drop_na = TRUE) {
  # add <variable type> + "_" as variable name prefix:
  coltypes <- df |> purrr::map_chr(typeof)
  names(df) <- paste0(coltypes, "_", names(df))


  df |>
    tidyr::pivot_longer(
      cols = dplyr::everything(),
      names_to = c(".value", "var"),
      values_transform = tablab::strip_attributes,
      # remove missing values:
      values_drop_na = values_drop_na,
      # lazy _ eager ...;
      # splits back the variable type until the first occurrence of _:
      names_pattern = "(.*?)_(.*)"
    ) |>
    dplyr::arrange(var = forcats::as_factor(var))

}
