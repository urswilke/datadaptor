#' Update the "Variables" sheet table with new dataset
#'
#' @param dat The new dataset
#' @param mapping_file Path the Excel mapping file
#' @param sheet Name of the variables sheet in the mapping file
#' @param abort_if_commands_lost logical whether to abort if commands in the
#'   sheet are lost when updating; defaults to `TRUE`.
#'
#' @return Dataframe containing the table of the updated "Variables" sheet
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' dat_mod <- spss_file %>%
#'   haven::read_sav() %>%
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
  df_varl <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet,
    col_types = "text"
  )
  df_varl_new <- gen_var_table_raw(dat)

  if (abort_if_commands_lost) {
    df_commands_lost <- df_varl %>%
      dplyr::filter(if_any(c("new_label", "new_name", "op"), ~is.na(.x))) %>%
      dplyr::anti_join(df_varl_new, by = c("var", "varlab", "type"))
    stopifnot(nrow(df_commands_lost) == 0)
  }

  df_varl_new %>%
    dplyr::left_join(df_varl, by = c("var", "varlab", "type"))
}

gen_var_table_raw <- function(dat) {
  df_types <- dat %>%
    purrr::map_chr(typeof) %>%
    tibble::enframe("var", "type")
  df_types %>%
    dplyr::full_join(
      dat %>%
        tablab::tab_varlabs(),
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
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' dat_mod <- spss_file %>%
#'   haven::read_sav() %>%
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
  df_vall <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet,
    col_types = "text"
  ) %>%
    dplyr::mutate(nv = as.numeric(.data$nv))
  df_vall_new <- gen_label_table_raw(dat)

  if (abort_if_commands_lost) {
    df_commands_lost <- df_vall %>%
      dplyr::filter(if_any(
        c("new_label", "sum_var_label", "sum_var_value", "sum_var_vallab"),
        ~is.na(.x)
      )) %>%
      dplyr::anti_join(df_vall_new, by = c("var", "nv", "cv", "vallab"))
    stopifnot(nrow(df_commands_lost) == 0)
  }

  df_vall_new %>%
    dplyr::left_join(df_vall, by = c("var", "nv", "cv", "vallab"))

}

gen_label_table_raw <- function(dat) {
  tablab::tab_vallabs(dat)
}

#' Generate the "Variables" sheet table
#'
#' @param dat The dataset containing variables of type `haven::labelled `.
#'
#' @return Dataframe containing the table of the "Variables" sheet
#' @export
#'
#' @examples
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' dat <- spss_file %>%
#'   haven::read_sav()
#' gen_var_table(dat)
gen_var_table <- function(dat) {
  gen_var_table_raw(dat) %>%
    dplyr::mutate(
      new_label = "",
      new_name = "",
      op = ""
    )
}

#' Generate the "Label" sheet table
#'
#' @param dat The dataset containing variables of type `haven::labelled `.
#'
#' @return Dataframe containing the table of the "Label" sheet
#' @export
#'
#' @examples
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' dat <- spss_file %>%
#'   haven::read_sav()
#' gen_label_table(dat)
gen_label_table <- function(dat) {
  gen_label_table_raw(dat) %>%
    dplyr::mutate(
      new_label      = "",
      sum_var_label  = "",
      sum_var_value  = "",
      sum_var_vallab = ""
    )
}
