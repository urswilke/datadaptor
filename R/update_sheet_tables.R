#' Update the "Variables" sheet table with new dataset
#'
#' @param dat The new dataset
#' @param mapping_file Path the Excel mapping file
#' @param sheet Name of the variables sheet in the mapping file
#' @param abort_if_commands_lost logical whether to abort if commands in the
#'   sheet are lost when updating; defaults to `TRUE`.
#'
#' @return Updated Variables sheet
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' dat <- spss_file %>%
#'   haven::read_sav() %>%
#'   # add a new variable:
#'   dplyr::mutate(
#'     new_var = haven::labelled(1, label = "new variable label"), .before = 1
#'   )
#' update_var_sheet(dat, mapping_file)
update_var_sheet <- function(dat,
                             mapping_file,
                             sheet = "Variables",
                             abort_if_commands_lost = TRUE) {
  df_varl <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet,
    col_types = "text"
  )
  df_types <- dat %>%
    purrr::map_chr(typeof) %>%
    tibble::enframe("var", "type")
  df_varl_new <- df_types %>%
    dplyr::full_join(
      dat %>%
        tablab::tab_varlabs(),
      by = "var"
    )

  if (abort_if_commands_lost) {
    df_commands_lost <- df_varl %>%
      dplyr::filter(if_any(c("new_label", "new_name", "op"), ~is.na(.x))) %>%
      dplyr::anti_join(df_varl_new, by = c("var", "varlab", "type"))
    stopifnot(nrow(df_commands_lost) == 0)
  }

  df_varl_new %>%
    dplyr::left_join(df_varl, by = c("var", "varlab", "type"))
}
