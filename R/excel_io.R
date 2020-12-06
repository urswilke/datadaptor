#' Create an Excel mapping file based on a labelled dataframe
#'
#' @param df_raw dataframe with labelled variables, e.g. resulting from haven::read_sav
#' @param filename name of the Excel file to be created
#'
#' @return
#' @export
#'
#' @examples
#' spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_filepath)
#' mapp_create(df, "mapping.xlsx")
mapp_create <- function(df_raw, filename) {

  df_varlab <-
    tablab::tab_varlabs(df_raw) %>%
    dplyr::mutate(new_label = "")
  df_vallabs <-
    tablab::tab_vallabs(df_raw) %>%
    dplyr::mutate(
      `new_label`      = "",
      `sum_var_label`  = "",
      `sum_var_value`  = "",
      `sum_var_vallab` = ""
    )

  wb <- openxlsx::createWorkbook()

  openxlsx::addWorksheet(wb, "Variables")
  openxlsx::addWorksheet(wb, "Labels")
  openxlsx::addWorksheet(wb, "Verbatims")
  openxlsx::addWorksheet(wb, "Free1")

  # Write the data to the sheets
  openxlsx::writeData(wb, sheet = "Variables", x = df_varlab)
  openxlsx::writeData(wb, sheet = "Labels", x = df_vallabs)
  openxlsx::writeData(wb, sheet = "Verbatims", x = "")
  openxlsx::writeData(wb, sheet = "Free1", x = "")

  # Export the file
  openxlsx::saveWorkbook(wb, filename)
}

#' Extract variable label sheet of Excel mapping file to dataframe
#'
#' @param filename name of the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
#' mapp_varl("mapping.xlsx")
mapp_varl <- function(filename) {
  readxl::read_xlsx(
    filename,
    sheet = "Variables"
  ) %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
}


#' Extract value label sheet of Excel mapping file to dataframe
#'
#' @param filename name of the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
#' mapp_vall("mapping.xlsx")
mapp_vall <- function(filename) {
  readxl::read_xlsx(
    filename,
    sheet = "Labels"
  ) %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
}


#' Extract free1 sheet of Excel mapping file to dataframe
#'
#' @param filename name of the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
#' mapp_free1("mapping.xlsx")
mapp_free1 <- function(filename) {
  res <- readxl::read_xlsx(
    filename,
    sheet = "Free1",
    range = cellranger::cell_cols("A:E"),
    col_names = FALSE,
    col_types = "text"
  )
  if (nrow(res) > 0) {
    res %>%
      dplyr::select(1:5) %>%
      dplyr::rename_all( ~ paste0("X", 1:5)) %>%
      dplyr::filter_all(dplyr::any_vars(!is.na(.))) %>%
      dplyr::mutate(row = dplyr::row_number())
  }
  else {
    purrr::map_dfc(1:5, ~character()) %>% purrr::set_names(paste0("X", 1:5))
  }
}
