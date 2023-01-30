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
gen_data_table <- function(df, values_drop_na = FALSE) {
  counts <- tab_counts(df, values_drop_na)

  var <- gen_var_table(df) |>
    dplyr::select(c("var","type", "varlab"))

  label <- tab_vallabs(df)

  counts |>
    dplyr::full_join(label, by=c("var", "double" = "nv")) |>
    dplyr::full_join(var, by=c("var"))
}


tab_counts <- function(df, values_drop_na = FALSE) {
  lengthen(df, values_drop_na) |>
    dplyr::mutate(var = forcats::as_factor(var)) |>
    dplyr::group_by_all() |>
    dplyr::tally(name = "Freq") |>
    dplyr::ungroup()
}

lengthen <- function(df, values_drop_na = FALSE) {
  # add <variable type> + "_" as variable name prefix:
  coltypes <- df |> purrr::map_chr(typeof)
  names(df) <- paste0(coltypes, "_", names(df))


  df |>
    tidyr::pivot_longer(
      cols = dplyr::everything(),
      names_to = c(".value", "var"),
      values_transform = strip_attributes,
      # remove missing values:
      values_drop_na = values_drop_na,
      # lazy _ eager ...;
      # splits back the variable type until the first occurrence of _:
      names_pattern = "(.*?)_(.*)"
    ) |>
    dplyr::arrange(var = forcats::as_factor(var))

}




#' Diff to labelled data frames
#'
#' @param df1 data frame 1
#' @param df2 data frame 2
#' @param id_var name of the id variable (string)
#'
#' @return data frame of diff results:
#'   For every variable `var`in the data.frames, the counts `n` are shown for
#'   all the values (one column per value type), variable and value labels, well
#'   as their type (column prefixes). The column suffixes `"_old"` and `"new"`
#'   indicate `df` and `df2`, respectively. If the type column is empty, the
#'   variable doesn't exist in the resepctive data.frame.
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapping <- Mapping$new(fake_survey, mapping_file)
#' mapping$modify_data()
#' diff_data(mapping$dat, mapping$dat_mod, "id")
diff_data <- function(df1, df2, id_var = "DC_ID") {
  long1 <- long_labelled_data(df1, id_var = id_var)
  long2 <- long_labelled_data(df2, id_var = id_var)
  allvars <- unique(c(long1$var, long2$var))
  full_join(
    long1,
    long2,
    suffix = c("_old", "_new"),
    by = c(id_var, "var")
  ) |>
    select(-all_of(id_var)) |>
    mutate(var = factor(var, levels = allvars)) |>
    group_by_all() |>
    tally() |>
    ungroup()
}


lengthen_by_id <- function(df, id_var = "DC_ID") {
  # add <variable type> + "_" as variable name prefix:
  id_pos <- which(names(df) == id_var)
  coltypes <- df[-id_pos] |> purrr::map_chr(typeof)
  names(df)[-id_pos] <- paste0(coltypes, "_", names(df[-id_pos]))


  df |>
    tidyr::pivot_longer(
      cols = -all_of(id_var),
      names_to = c(".value", "var"),
      values_transform = strip_attributes,
      # lazy _ eager ...;
      # splits back the variable type until the first occurrence of _:
      names_pattern = "(.*?)_(.*)"
    ) |>
    dplyr::arrange(var = forcats::as_factor(var))

}

long_labelled_data <- function(df, id_var = "DC_ID") {
  counts <- lengthen_by_id(df, id_var)
  var <- df |>
    select(-all_of(id_var))|>
    gen_var_table() |>
    dplyr::select(c("var","type", "varlab"))

  label <- tab_vallabs(df)

  counts |>
    dplyr::full_join(label, by=c("var", "double" = "nv")) |>
    dplyr::full_join(var, by=c("var"))
}
