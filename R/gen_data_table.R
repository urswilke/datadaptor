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

  df_var <- gen_var_table_raw(df)

  label <- tab_vallabs(df)

  counts |>
    full_join(label, by=c("var", "double" = "nv")) |>
    full_join(df_var, by=c("var"))
}


tab_counts <- function(df, values_drop_na = FALSE) {
  lengthen(df, values_drop_na) |>
    mutate(var = factor(.data$var, unique(.data$var))) |>
    group_by_all() |>
    tally(name = "Freq") |>
    ungroup()
}

lengthen <- function(df, values_drop_na = FALSE) {
  # add <variable type> + "_" as variable name prefix:
  coltypes <- df |> map_chr(typeof)
  names(df) <- paste0(coltypes, "_", names(df))


  df |>
    pivot_longer(
      cols = everything(),
      names_to = c(".value", "var"),
      values_transform = strip_attributes,
      # remove missing values:
      values_drop_na = values_drop_na,
      # lazy _ eager ...;
      # splits back the variable type until the first occurrence of _:
      names_pattern = "(.*?)_(.*)"
    ) |>
    arrange(var = factor(.data$var, unique(.data$var)))

}




#' Diff to labelled data frames
#'
#' @param df1 data frame 1
#' @param df2 data frame 2
#' @param id_var name of the id variable (string)
#' @param warn whether to emit a warning if `df1` and `df2` don't contain the
#'   same ids.
#'
#' @return data frame of diff results:
#'   For every variable `var`in the data.frames, the counts `n` are shown for
#'   all the values (one column per value type), variable and value labels, well
#'   as their type (column prefixes). The column suffixes `"_old"` and `"new"`
#'   indicate `df` and `df2`, respectively. If the type column is empty, the
#'   variable doesn't exist in the respective data.frame.
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapping <- Mapping$new(fake_survey, mapping_file)
#' mapping$modify_data()
#' diff_data(mapping$dat, mapping$dat_mod, "id")
diff_data <- function(df1, df2, id_var = "DC_ID", warn = TRUE) {
  if (!setequal(df1[[id_var]], df2[[id_var]])) {
    if (warn) {
      warning(
        "`diff_data()` doesn't work well if both datasets don't contain the same ids.\n",
        "Did you #ADDFILE or #FILTER or ?\n",
        "Only the cases occurring in both data sets will be compared.\n",
        "Remove this warning by setting `warn = FALSE`."
      )
    }
    shared_ids <- intersect(df1[[id_var]], df2[[id_var]])
    df1 <- df1[df1[[id_var]] %in% shared_ids,]
    df2 <- df2[df2[[id_var]] %in% shared_ids,]
  }

  long1 <- long_labelled_data(df1, id_var = id_var)
  long2 <- long_labelled_data(df2, id_var = id_var)
  allvars <- unique(c(long1$var, long2$var))
  full_join(
    long1,
    long2,
    suffix = c("_old", "_new"),
    by = c(id_var, "var")
  ) |>
    select(-all_of(c(id_var))) |>
    mutate(var = factor(.data$var, levels = allvars)) |>
    group_by_all() |>
    tally() |>
    ungroup()
}


lengthen_by_id <- function(df, id_var = "DC_ID") {
  # add <variable type> + "_" as variable name prefix:
  id_pos <- which(names(df) == id_var)
  coltypes <- df[-id_pos] |> map_chr(typeof)
  names(df)[-id_pos] <- paste0(coltypes, "_", names(df[-id_pos]))


  df |>
    pivot_longer(
      cols = -all_of(id_var),
      names_to = c(".value", "var"),
      values_transform = strip_attributes,
      # lazy _ eager ...;
      # splits back the variable type until the first occurrence of _:
      names_pattern = "(.*?)_(.*)"
    ) |>
    arrange(var = factor(.data$var, unique(.data$var)))

}

long_labelled_data <- function(df, id_var = "DC_ID") {
  counts <- lengthen_by_id(df, id_var)
  df_var <- df |>
    select(-all_of(c(id_var))) |>
    gen_var_table_raw()

  label <- tab_vallabs(df)

  counts |>
    full_join(label, by=c("var", "double" = "nv")) |>
    full_join(df_var, by=c("var"))
}
