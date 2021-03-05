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
#' @export
#'
#' @examples
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_file)
#' \dontrun{
#' mapp_create(df, "mapping.xlsx")
#' }
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
#' @return Dataframe containing the information of the "configr" sheet in the Excel mapping file.
#' @export
#' @importFrom rlang := .data
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_configr(mapping_file)
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
#' @return Command block table of the "Variables" sheet of the Excel mapping file.
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_var_sheet_cmd_table(mapping_file)
mapp_var_sheet_cmd_table <- function(mapping_file, sheet = "Variables", translate_xlsm = FALSE) {
  df_varl <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet
  ) %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
  if (translate_xlsm) {
    df_varl <- translate_xlsm_var_sheet(df_varl)
  }
  df_varl %>% parse_varlab_cmd_table()
}
translate_xlsm_var_sheet <- function(df_varl) {
  df_varl %>% dplyr::select(
    var = 1,
    varlab = 3,
    op = .data$Operation,
    new_name = .data$`New var name`,
    new_label = .data$`New var label`
  ) %>%
    dplyr::slice(-1) %>%
    dplyr::mutate(varlab = ifelse(.data$varlab == "<none>", NA_character_, .data$varlab))
}

parse_varlab_cmd_table <- function(df_varl) {
  dplyr::bind_rows(
    parse_autorecode_cmd_block(df_varl),
    parse_rename_cmd_block(df_varl),
    parse_newlab_cmd_blocks(df_varl)
  )
}

parse_newlab_cmd_blocks <- function(df_varl) {
  df_varl %>%
    dplyr::mutate(row = (dplyr::row_number() + 1) %>% as.character()) %>%
    tidyr::drop_na(.data$new_label) %>%
    dplyr::mutate(var = dplyr::coalesce(.data$new_name, .data$var)) %>%
    dplyr::mutate(new_var = .data$var) %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#NEWLAB") %>%
    dplyr::select(-.data$new_name, -.data$op) %>%
    dplyr::group_by(.data$sheet, .data$action, row, .data$new_var) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}
parse_rename_cmd_block <- function(df_varl) {
  df_rename <- df_varl %>%
    dplyr::mutate(row = (dplyr::row_number() + 1) %>% as.character()) %>%
    tidyr::drop_na(.data$new_name) %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#RENAME") %>%
    dplyr::mutate(new_var = .data$new_name) %>%
    dplyr::select(-.data$new_label, -.data$op, -.data$varlab) %>%
    dplyr::group_by(.data$sheet, .data$action) %>%
    dplyr::summarise(
      row = paste(row, collapse = ", "),
      new_names = list(.data$new_var),
      new_var = paste(.data$new_var, collapse = ", "),
      vars = list(.data$var)
    ) %>%
    dplyr::group_by(.data$sheet, .data$action, .data$new_var, row) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}

parse_autorecode_cmd_block <- function(df_varl) {
  df_autorec <- df_varl %>%
    dplyr::mutate(row = (dplyr::row_number() + 1) %>% as.character()) %>%
    dplyr::filter(.data$op == "a") %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#AUTOREC") %>%
    dplyr::mutate(new_var = .data$var) %>%
    dplyr::select(-.data$new_label, -.data$op, -.data$varlab, -.data$new_name) %>%
    dplyr::group_by(.data$sheet, .data$action, .data$new_var, .data$row) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}





#' Extract value label sheet of Excel mapping file to dataframe
#'
#' @param mapping_file name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#' @param translate_xlsm logical whether to translate the format of Wolf's mapping file to the format of `mapp_create()``
#'
#' @return Command block table of the "Label" sheet of the Excel mapping file.
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_vallab_sheet_cmd_table(mapping_file)
mapp_vallab_sheet_cmd_table <- function(mapping_file, sheet = "Label", translate_xlsm = FALSE) {
  df_vall <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet
  )
  if (translate_xlsm) {
    df_vall <- translate_xlsm_vallab_sheet(df_vall)
  }
  df_vall <- df_vall %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
  dplyr::bind_rows(
    parse_newvall_cmd_table(df_vall),
    parse_sumvar_cmd_table(df_vall)
  )

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
    tidyr::fill(.data$var)
}
parse_sumvar_cmd_table <- function(df_vall) {
  df_vall %>%
    tidyr::drop_na(.data$sum_var_value) %>%
    dplyr::select(-.data$new_label) %>%
    dplyr::mutate(new_var = paste0("k", .data$var)) %>%
    dplyr::mutate(orig_var = .data$var) %>%
    dplyr::group_by(.data$new_var, .data$orig_var) %>%
    dplyr::mutate(row = paste(.data$row, collapse = ", ")) %>%
    dplyr::mutate(sheet = "Label") %>%
    dplyr::mutate(action = "#SUMVAR") %>%
    dplyr::relocate(.data$sheet, .data$action)  %>%
    dplyr::group_by(.data$sheet, .data$action, .data$row, .data$new_var) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}
parse_newvall_cmd_table <- function(df_vall) {
  df_vall %>%
    tidyr::drop_na(.data$new_label) %>%
    dplyr::mutate(new_var = .data$var) %>%
    dplyr::mutate(orig_var = .data$var) %>%
    dplyr::mutate(sheet = "Label") %>%
    dplyr::mutate(action = "#NEWVALL") %>%
    dplyr::relocate(.data$sheet, .data$action)  %>%
    dplyr::group_by(.data$sheet, .data$action, .data$new_var) %>%
    dplyr::mutate(row = paste(.data$row, collapse = ", ")) %>%
    dplyr::group_by(.data$sheet, .data$action, .data$row, .data$new_var) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}




#' Extract free1 sheet of Excel mapping file to dataframe
#'
#' @param  mapping_file name of the Excel mapping file
#' @param  sheet name of the sheet in the Excel mapping file
#' @param translate_xlsm logical whether to translate the format of Wolf's mapping file to the format of `mapp_create()``
#'
#' @return Command block table of the "Free" sheet of the Excel mapping file.
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_free_sheet_cmd_table(mapping_file)
mapp_free_sheet_cmd_table <- function(mapping_file, sheet = "Free1", translate_xlsm = FALSE) {
  df_free_raw <- mapp_free_sheet_cmd_table_raw(mapping_file, sheet, translate_xlsm)
  df_free_raw %>%
    put_absolute_filepaths(mapping_file) %>%
    process_raw_free_cmd_table()
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

process_raw_free_cmd_table <- function(df_free) {
  if (nrow(df_free) == 0) {
    return(tibble::tibble())
  }
  df_free %>%
    replace_single_equals_sign_IF_AND_COMP() %>%
    delete_empty_X1_not_multiline() %>%
    add_curlies_to_cell_with_spaces() %>%
    curliply() %>%
    dplyr::mutate(action = .data$X1[1]) %>%
    dplyr::group_by(.data$action, .data$row) %>%
    get_new_var_name_free() %>%
    dplyr::group_by(.data$action, .data$row, .data$new_var, .data$raw_index) %>%
    tidyr::nest() %>%
    dplyr::ungroup() %>%
    dplyr::select(-.data$raw_index)
}
put_absolute_filepaths <- function(df_free, mapping_file) {
  df_free[df_free$X1 %in% c("#MERGE", "#RFUN"), ][["X2"]] <-
    df_free[df_free$X1 %in% c("#MERGE", "#RFUN"), ][["X2"]] %>%
    purrr::map_chr(~ adapt_filepath(.x, mapping_file))
  df_free
}
get_new_var_name_free <- function(df_free) {
  col2_names <- c("#VALL", "#AVALL", "#COMP", "#COMPR", "#VARL")
  col3_names <- c("#REC", "#DIC")
  df_free %>%
    dplyr::mutate(new_var = dplyr::case_when(
      action %in% col3_names ~ .data$X3[1],
      action %in% col2_names ~ .data$X2[1],
      action == "#IF"        ~ stringr::str_remove(.data$X3, "=.*") %>% stringr::str_squish(),
      action == "#KG"        ~ paste(.data$X2, .data$X3, sep = "_"),
      action == "#MERGE"    ~ paste(.data$X4, collapse = ", ")
    )
  )
}

add_curlies_to_cell_with_spaces <- function(df_free) {
  # transform X2 containing spaces to curliply()able (surrounded by curly braces):
  df_free %>%
    dplyr::mutate(X2 = ifelse(
      .data$X1 == "#VARL" & stringr::str_detect(.data$X2, " ") & stringr::str_detect(.data$X2, "\\{", negate = TRUE),
      paste0("{", .data$X2, "}"),
      .data$X2
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
      .data$X1 %in% "#IF",
      replace_single_equals_sign(.data$X2),
      .data$X2
    )) %>%
    dplyr::mutate(X3 = ifelse(
      .data$X1 %in% "#COMP",
      replace_single_equals_sign(.data$X3),
      .data$X3
    ))
}
delete_empty_X1_not_multiline <- function(df_free) {
  df_free %>%
    dplyr::mutate(temp = stringr::str_detect(.data$X1, "^#VALL$|^#REC$|^#AVALL$", negate = T)) %>%
    tidyr::fill(.data$temp) %>%
    dplyr::mutate(temp = .data$temp & is.na(.data$X1)) %>%
    dplyr::filter(!.data$temp) %>%
    dplyr::select(-.data$temp)
}
