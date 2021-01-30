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
#' @param mapping_file name of the Excel file to be created
#'
#' @return
#' @export
#'
#' @examples
#' spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_filepath)
#' mapp_create(df, "mapping.xlsx")
mapp_create <- function(df_raw, mapping_file) {

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
  openxlsx::saveWorkbook(wb, mapping_file)
}
#' Extract configr sheet of Excel mapping file to dataframe
#'
#' @param mapping_file name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_filepath)
#' }
#' mapp_configr(mapping_filepath)
mapp_configr <- function(mapping_file, sheet = "configr") {
  df_config <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet
  ) %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
  df_config
}




#' Extract variable label sheet of Excel mapping file to dataframe
#'
#' @param mapping_file name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#' @param translate_xlsm logical whether to translate the format of Wolf's mapping file to the format of mapp_create
#'
#' @return
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_filepath)
#' }
#' mapp_var_sheet_cmd_table(mapping_filepath)
mapp_var_sheet_cmd_table <- function(mapping_file, sheet = "Variables", translate_xlsm = FALSE) {
  df_varl <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet
  ) %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
  if (translate_xlsm) {
    df_varl <- translate_xlsm_var_sheet(df_varl)
  }
  df_varl %>% make_varlab_cmd_table()
}
translate_xlsm_var_sheet <- function(df_varl) {
  df_varl %>% dplyr::select(
    var = 1,
    varlab = 3,
    op = Operation,
    new_name = `New var name`,
    new_label = `New var label`
  ) %>%
    dplyr::slice(-1) %>%
    dplyr::mutate(varlab = ifelse(varlab == "<none>", NA_character_, varlab))
}

make_varlab_cmd_table <- function(df_varl) {
  dplyr::bind_rows(
    make_varlab_rename_tbl(df_varl),
    make_varlab_newlab_table(df_varl)
  )
}

make_varlab_newlab_table <- function(df_varl) {
  df_varl %>%
    dplyr::mutate(row = (dplyr::row_number() + 1) %>% as.character()) %>%
    tidyr::drop_na(new_label) %>%
    dplyr::mutate(var = dplyr::coalesce(new_name, var)) %>%
    dplyr::mutate(new_var = var) %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#NEWLAB") %>%
    dplyr::select(-new_name, -op) %>%
    dplyr::group_by(sheet, action, row, new_var) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}
make_varlab_rename_tbl <- function(df_varl) {
  df_rename <- df_varl %>%
    dplyr::mutate(row = (dplyr::row_number() + 1) %>% as.character()) %>%
    tidyr::drop_na(new_name) %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#RENAME") %>%
    dplyr::mutate(new_var = new_name) %>%
    dplyr::select(-new_label, -op, -varlab) %>%
    dplyr::group_by(sheet, action) %>%
    dplyr::summarise(
      row = paste(row, collapse = ", "),
      new_names = list(new_var),
      new_var = paste(new_var, collapse = ", "),
      vars = list(var)
    ) %>%
    dplyr::group_by(sheet, action, new_var, row) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}





#' Extract value label sheet of Excel mapping file to dataframe
#'
#' @param mapping_file name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#' @param translate_xlsm logical whether to translate the format of Wolf's mapping file to the format of `mapp_create()``
#'
#' @return
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_filepath)
#' }
#' mapp_vallab_sheet_cmd_table(mapping_filepath)
mapp_vallab_sheet_cmd_table <- function(mapping_file, sheet = "Label", translate_xlsm = FALSE) {
  df_vall <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet
  )
  if (translate_xlsm) {
    df_vall <- translate_xlsm_vallab_sheet(df_vall)
  }
  df_vall %>%
    dplyr::mutate(row = dplyr::row_number() + 1) %>%
    make_sumvar_cmd_table()
}
translate_xlsm_vallab_sheet <- function(df_vall) {
  df_vall %>% dplyr::select(
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
make_sumvar_cmd_table <- function(df_vall) {
  df_vall %>%
    tidyr::drop_na(sum_var_value) %>%
    dplyr::select(-new_label) %>%
    dplyr::mutate(new_var = paste0("k", var)) %>%
    dplyr::mutate(orig_var = var) %>%
    dplyr::group_by(new_var, orig_var) %>%
    dplyr::mutate(row = paste(row, collapse = ", ")) %>%
    dplyr::mutate(sheet = "Label") %>%
    dplyr::mutate(action = "#SUMVAR") %>%
    dplyr::relocate(sheet, action)  %>%
    dplyr::group_by(sheet, action, row, new_var) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}




#' Extract free1 sheet of Excel mapping file to dataframe
#'
#' @param  mapping_file name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#' @param translate_xlsm logical whether to translate the format of Wolf's mapping file to the format of `mapp_create()``
#'
#' @return
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_filepath)
#' }
#' mapp_free_sheet_cmd_table(mapping_filepath)
mapp_free_sheet_cmd_table <- function(mapping_file, sheet = "Free1", translate_xlsm = FALSE) {
  df_free_raw <- mapp_free_sheet_cmd_table_raw(mapping_file, sheet, translate_xlsm)
  df_free_raw %>%
    make_free_cmd_table()
}
mapp_free_sheet_cmd_table_raw <- function(mapping_file, sheet = "Free1", translate_xlsm = FALSE) {
  df_free <- readxl::read_xlsx(
    mapping_file,
    range = cellranger::cell_limits(ul = c(1, 1), lr = c(NA, 5), sheet = sheet),
    col_names = paste0("X", 1:5),
    col_types = "text"
  )
  if (nrow(df_free) > 0) {
    df_free <- df_free %>%
      dplyr::select(1:5) %>%
      # dplyr::rename_all( ~ paste0("X", 1:5)) %>%
      dplyr::mutate(row = dplyr::row_number())
  }
  else {
    df_free <-
      purrr::map_dfc(1:5, ~character()) %>%
      purrr::set_names(paste0("X", 1:5))
  }
  if (translate_xlsm) {
    df_free <- translate_xlsm_free_sheet(df_free)
  }
  df_free
}
translate_xlsm_free_sheet <- function(df_free) {
  df_free %>% dplyr::slice(-1)
}

make_free_cmd_table <- function(df_f1) {
  if (nrow(df_f1) == 0) {
    return(tibble::tibble())
  }
  res <- df_f1 %>%
    replace_single_equals_sign_IF_AND_COMP() %>%
    delete_empty_X1_not_multiline() %>%
    add_curlies_to_cell_with_spaces() %>%
    curliply() %>%
    dplyr::mutate(action = X1[1]) %>%
    dplyr::group_by(action, row) %>%
    get_new_var_name_free() %>%
    dplyr::group_by(action, row, new_var, raw_index) %>%
    tidyr::nest() %>%
    dplyr::ungroup() %>%
    dplyr::select(-raw_index)
}
get_new_var_name_free <- function(df_f1) {
  col2_names <- c("#VALL", "#AVALL", "#COMP", "#COMPR", "#VARL")
  col3_names <- c("#REC", "#DIC")
  df_f1 %>%
    dplyr::mutate(new_var = dplyr::case_when(
      action %in% col3_names ~ X3[1],
      action %in% col2_names ~ X2[1],
      action == "#IF"        ~ stringr::str_remove(X3, "=.*") %>% stringr::str_squish(),
      action == "#KG"        ~ paste(X2, X3, sep = "_")
    )
  )
}

add_curlies_to_cell_with_spaces <- function(df_f1) {
  # transform X2 containing spaces to curliply()able (surrounded by curly braces):
  df_f1 %>%
    dplyr::mutate(X2 = ifelse(
      X1 == "#VARL" & stringr::str_detect(X2, " ") & stringr::str_detect(X2, "\\{", negate = TRUE),
      paste0("{", X2, "}"),
      X2
  ))
}
replace_single_equals_sign_IF_AND_COMP <- function(df_free) {
  replace_single_equals_sign <- function(column) {
    # see: https://stackoverflow.com/questions/28460473/how-do-i-match-a-single-equals-sign-with-regular-expressions/28460640
    stringr::str_replace_all(
      column,
      "(?<![=><])=(?!=)",
      "=="
    )
  }
  df_free %>%
    dplyr::mutate(X2 = ifelse(
      X1 %in% "#IF",
      replace_single_equals_sign(X2),
      X2
    )) %>%
    dplyr::mutate(X3 = ifelse(
      X1 %in% "#COMP",
      replace_single_equals_sign(X3),
      X3
    ))
}
delete_empty_X1_not_multiline <- function(df_f1) {
  df_f1 %>%
    dplyr::mutate(temp = stringr::str_detect(X1, "^#VALL$|^#REC$|^#AVALL$", negate = T)) %>%
    tidyr::fill(temp) %>%
    dplyr::mutate(temp = temp & is.na(X1)) %>%
    dplyr::filter(!temp) %>%
    dplyr::select(-temp)
}
