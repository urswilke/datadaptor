#' Create an Excel mapping file based on a labelled dataframe
#'
#' The mapping file consists of the sheets "Variables", "Label", "Verbatims" & "Free".
#' Each of these controlls different aspects of data manipulations you can apply
#' to a labelled dataset. You can add as much of those sheets as you want to the file.
#' The commands entered in the mapping file can later be excuted on the data set
#' with \code{mapp_xl_to_data()}. The
#' sequence of commands is executed in the same order as the sequence of sheets in the mapping file.
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
  openxlsx::addWorksheet(wb, "Label")
  openxlsx::addWorksheet(wb, "Verbatims")
  openxlsx::addWorksheet(wb, "Free1")

  # Write the data to the sheets
  openxlsx::writeData(wb, sheet = "Variables", x = df_varlab)
  openxlsx::writeData(wb, sheet = "Label", x = df_vallabs)
  openxlsx::writeData(wb, sheet = "Verbatims", x = "")
  openxlsx::writeData(wb, sheet = "Free1", x = "")

  # Export the file
  openxlsx::saveWorkbook(wb, filename)
}

#' Extract variable label sheet of Excel mapping file to dataframe
#'
#' @param filename name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapp_varl(mapping_filepath)
mapp_varl <- function(filename, sheet = "Variables", translate_xlsm = FALSE) {
  df_varl <- readxl::read_xlsx(
    filename,
    sheet = sheet
  ) %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
  if (translate_xlsm) {
    df_varl <- df_varl %>% dplyr::select(
      var = 1,
      varlab = 3,
      op = Operation,
      new_name = `New var name`,
      new_label = `New var label`
    ) %>%
      dplyr::slice(-1) %>%
      dplyr::mutate(varlab = ifelse(varlab == "<none>", NA_character_, varlab))
  }
  df_varl
}


#' Extract value label sheet of Excel mapping file to dataframe
#'
#' @param filename name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapp_vall(mapping_filepath)
mapp_vall <- function(filename, sheet = "Label", translate_xlsm = FALSE) {
  df_vall <- readxl::read_xlsx(
    filename,
    sheet = sheet
  )
  if (translate_xlsm) {
    df_vall <- df_vall  %>% dplyr::select(
      var = 1,
      nv = 2,
      vallab = 3,
      new_label = 4,
      sum_var_label = 7,
      sum_var_value = 8,
      sum_var_vallab = 9
    ) %>% dplyr::slice(-1) %>%
      tidyr::fill(var)
  }
  df_vall %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
}


#' Extract free1 sheet of Excel mapping file to dataframe
#'
#' @param  filename name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapp_free1(mapping_filepath)
mapp_free1 <- function(filename, sheet = "Free1", translate_xlsm = FALSE) {
  df_free <- readxl::read_xlsx(
    filename,
    sheet = sheet,
    range = cellranger::cell_cols("A:E"),
    col_names = paste0("X", 1:5),
    col_types = "text"
  )
  if (nrow(df_free) > 0) {
    df_free <- df_free %>%
      dplyr::select(1:5) %>%
      # dplyr::rename_all( ~ paste0("X", 1:5)) %>%
      dplyr::filter_all(dplyr::any_vars(!is.na(.))) %>%
      dplyr::mutate(row = dplyr::row_number()) %>%
      dplyr::mutate(X2 = ifelse(
        X1 == "#IF",
        replace_single_equals_sign(X2),
        X2
      )) %>%
      dplyr::mutate(X3 = ifelse(
        X1 == "#COMP",
        replace_single_equals_sign(X3),
        X3
      ))
  }
  else {
    df_free <-
      purrr::map_dfc(1:5, ~character()) %>%
      purrr::set_names(paste0("X", 1:5))
  }
  if (translate_xlsm) {
    df_free <-
      df_free %>% dplyr::slice(-1)
  }
  df_free
}

replace_single_equals_sign <- function(column) {
  # see: https://stackoverflow.com/questions/28460473/how-do-i-match-a-single-equals-sign-with-regular-expressions/28460640
  stringr::str_replace(
    column,
    "(?<![=><])=(?!=)",
    "=="
  )
}
