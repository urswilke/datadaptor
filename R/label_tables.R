#' Update the "Variables" sheet table with new dataset
#'
#' @param dat The new dataset
#' @param mapping_file Path the Excel mapping file
#' @param sheet Name of the variables sheet in the mapping file
#'
#' @return Dataframe containing the table of the updated "Variables" sheet
#' @noRd
#'
#' @examples
#' mapping_file <- system.file(
#'   "extdata",
#'   "mapping.xlsx",
#'   package = "datadaptor"
#' )
#' spss_file <- system.file(
#'   "extdata",
#'   "mtcars_labelled.sav",
#'   package = "datadaptor"
#' )
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
                             only_changes = FALSE) {
  df_varl <- read_xlsx(
    mapping_file,
    sheet = sheet,
    col_types = "text",
    .name_repair = c("unique_quiet")
  ) |>
  select(c("var", "type", "varlab")) |>
  filter(!is.na(var))

  df_varl_new <- gen_var_table_raw(dat)


  df_combined <- df_varl_new |>
    power_full_join(
      df_varl,
      by = c("var")
    ) |>
    mutate(status = case_when(
      is.na(type.y) ~ "1 - New variable",
      is.na(type.x) ~ "5 - Variable deleted",
      type.x != type.y & varlab.x != varlab.y ~ "2 - Type & label changed",
      type.x != type.y ~ "3 - Type changed",
      varlab.x != varlab.y ~ "4 - Label changed",
      .default = "6 - Unchanged"
    )) |>
    select(c("status", "var", "type.x", "type.y", "varlab.x", "varlab.y")) |>
    arrange(status)


  if (only_changes)
  {
      df_combined |> filter(status != "6 - Unchanged")
  } else {
      df_combined
  }
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
#' @return Dataframe containing the table of the updated "Label" sheet
#' @noRd
#'
#' @examples
#' mapping_file <- system.file(
#'   "extdata",
#'   "mapping.xlsx",
#'   package = "datadaptor"
#' )
#' spss_file <- system.file(
#'   "extdata",
#'   "mtcars_labelled.sav",
#'   package = "datadaptor"
#' )
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
                               only_changes = FALSE) {
  df_vall <- read_xlsx(
    mapping_file,
    sheet = sheet,
    col_types = "text",
    .name_repair = c("unique_quiet")
  ) |>
    select(c("var", "nv", "label")) |>
    filter(!is.na(var)) |>
    as.numeric("nv")

  df_vall_new <- tab_vallabs(dat)


  df_combined <- df_vall_new |>
    power_full_join(
      df_vall,
      by = c("var", "nv")
    ) |>
    mutate(nv = as.numeric(.data$nv), exists = 1) |>
    mutate(status = case_when(
      is.na(label.y) ~ "1 - New label",
      is.na(label.x) ~ "3 - Label deleted",
      label.x != label.y ~ "2 - Label changed",
      .default = "4 - Unchanged"
    )) |>
    select(c("status", "var", "nv", "label.x", "label.y")) |>
    arrange(status)

  if (only_changes)
  {
    df_combined |> filter(status != "4 - Unchanged")
  } else {
    df_combined
  }
}


#' Generate tables with the variables' labels
#' @name label_tables
#' @examples
#' spss_file <- system.file(
#'   "extdata",
#'   "mtcars_labelled.sav",
#'   package = "datadaptor"
#' )
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
      op = "",
      hash = dat |> sapply(digest)
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
  attr(x, "label", exact = TRUE) %||% ""
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
