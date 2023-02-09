#' Update the "Variables" sheet table with new dataset
#'
#' @param dat The new dataset
#' @param mapping_file Path the Excel mapping file
#' @param sheet Name of the variables sheet in the mapping file
#' @param abort_if_commands_lost logical whether to abort if commands in the
#'   sheet are lost when updating; defaults to `TRUE`.
#'
#' @return Dataframe containing the table of the updated "Variables" sheet
#' @noRd
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' dat_mod <- spss_file |>
#'   haven::read_sav() |>
#'   # add a new variable in the first column of the dataframe:
#'   dplyr::mutate(
#'     new_var = haven::labelled(1, label = "variable label of new_var"),
#'     .before = 1
#'   )
#' update_var_table(dat_mod, mapping_file)
update_var_table <- function(dat,
                             mapping_file,
                             sheet = "Variables",
                             abort_if_commands_lost = TRUE) {
  df_varl <- read_xlsx(
    mapping_file,
    sheet = sheet,
    col_types = "text"
  )
  df_varl_new <- gen_var_table_raw(dat)

  if (abort_if_commands_lost) {
    df_commands_lost <- df_varl |>
      filter(if_any(c("new_label", "new_name", "op"), ~is.na(.x))) |>
      anti_join(df_varl_new, by = c("var", "varlab", "type"))
    stopifnot(nrow(df_commands_lost) == 0)
  }

  df_varl_new |>
    left_join(df_varl, by = c("var", "varlab", "type"))
}

gen_var_table_raw <- function(dat) {
  df_types <- dat |>
    map_chr(typeof) |>
    enframe("var", "type")
  df_types |>
    full_join(
      dat |>
        tab_varlabs(),
      by = "var"
    )
}

#' Update the "Label" sheet table with new dataset
#'
#' @param dat The new dataset
#' @param mapping_file Path the Excel mapping file
#' @param sheet Name of the "Label" sheet in the mapping file
#' @param abort_if_commands_lost logical whether to abort if commands in the
#'   sheet are lost when updating; defaults to `TRUE`.
#'
#' @return Dataframe containing the table of the updated "Label" sheet
#' @noRd
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' dat_mod <- spss_file |>
#'   haven::read_sav() |>
#'   # add a new variable in the first column of the dataframe:
#'   dplyr::mutate(
#'     new_var = haven::labelled(
#'       1,
#'       labels = c("value label of value 1 of new_var" = 1)
#'     ),
#'     .before = 1
#'   )
#' update_label_table(dat_mod, mapping_file)
update_label_table <- function(dat,
                               mapping_file,
                               sheet = "Label",
                               abort_if_commands_lost = TRUE) {
  df_vall <- read_xlsx(
    mapping_file,
    sheet = sheet,
    col_types = "text"
  ) |>
    mutate(nv = as.numeric(.data$nv))
  df_vall_new <- tab_vallabs(dat)

  if (abort_if_commands_lost) {
    df_commands_lost <- df_vall |>
      filter(if_any(
        c("new_label", "sum_var_label", "sum_var_value", "sum_var_vallab"),
        ~is.na(.x)
      )) |>
      anti_join(df_vall_new, by = c("var", "nv", "vallab"))
    stopifnot(nrow(df_commands_lost) == 0)
  }

  df_vall_new |>
    left_join(df_vall, by = c("var", "nv", "vallab"))

}


#' Generate tables with the variables' labels
#' @name label_tables
#' @examples
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' dat <- spss_file |>
#'   haven::read_sav()
#' gen_var_table(dat)
#' gen_label_table(dat)
NULL

#' @rdname label_tables
#'
#' @description `gen_var_table()` generates the "Variables" sheet table with the
#'   variable labels in the data.
#'
#' @param dat The dataset containing variables of type `haven::labelled `.
#'
#' @return For `gen_var_table()` a dataframe containing the table of the
#'   "Variables" sheet.
#' @export
gen_var_table <- function(dat) {
  gen_var_table_raw(dat) |>
    mutate(
      new_label = "",
      new_name = "",
      op = ""
    )
}

#' @rdname label_tables
#'
#' @description `gen_label_table()` generates the "Label" sheet table with the
#'   value labels in the data.
#'
#' @param dat The dataset containing variables of type `haven::labelled `.
#'
#' @return For `gen_label_table()` a dataframe containing the table for the
#'   "Label" sheet.
#' @export
gen_label_table <- function(dat) {
  tab_vallabs(dat) |>
    mutate(
      new_label      = "",
      sum_var_label  = "",
      sum_var_value  = "",
      sum_var_vallab = ""
    )
}




tab_1var_vallabs <- function(x) {
  vallab_vec <- attr(x, "labels")
  if (is.null(vallab_vec)) {
    return(tibble(
      nv = double(),
      vallab = character()
    ))
  }
  if (is.character(vallab_vec)) {
    stop("Value label tabulation not yet implemented for string variables!")
  }
  tibble(
    nv = unname(vallab_vec),
    vallab = names(vallab_vec)
  )
}
tab_vallabs <- function(df, remove_empty = TRUE) {
  res <- df |> map_dfr(tab_1var_vallabs, .id = "var")
  if (remove_empty) {
    res <- res |> drop_na("nv")
  }
  res
}

tab_1var_varlab <- function(x) {
  varlab <- attr(x, "label", exact = TRUE)
  if (is.null(varlab)) {
    return(NA_character_)
  }
  varlab
}
tab_varlabs <- function(df, remove_empty = TRUE) {
  res <- df |>
    map_chr(\(x) tab_1var_varlab(x)) |>
    enframe("var", "varlab")
  if (remove_empty) {
    res <- res |> drop_na("varlab")
  }
  res
}

