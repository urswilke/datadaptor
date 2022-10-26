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
  res1 <- df |>
    tidyr::pivot_longer(
      dplyr::everything(),
      # in order to merge string & numeric variables into one column:
      values_transform = as.character,
      # in order to keep variable order:
      names_transform = forcats::as_factor,
      # remove missing values:
      values_drop_na = values_drop_na,
      names_to = "var",
      values_to = "nv"
    ) |>
    dplyr::count(.data$var, .data$nv, name = "Freq")

  var1 <- gen_var_table(df) %>%
    dplyr::select(c("var","type", "varlab"))

  label1 <- tablab::tab_vallabs(df) %>%
    dplyr::select(c("var","nv", "vallab"))

  res1 <- merge(res1, label1, by=c("var", "nv"), all=TRUE)
  merge(res1, var1, by="var")

}
