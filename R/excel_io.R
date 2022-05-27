#' Create an Excel mapping file based on a labelled dataframe
#'
#' The mapping file consists of the sheets "Variables", "Label", "Verbatims" &
#' "Free". Each of these controls different aspects of data manipulations you
#' can apply to a labelled dataset. You can add as much of those sheets as you
#' want to the file. The commands entered in the mapping file can later be
#' executed on the data set with \code{mapp_xl_to_data()}. The sequence of
#' commands is executed in the same order as the sequence of sheets in the
#' mapping file.
#'
#' @param df_raw dataframe with labelled variables, e.g. resulting from
#'   haven::read_sav
#' @param mapping_file name of the Excel file to be created
#'
#' @export
#' @importFrom rlang := .data
#'
#' @examples
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_file)
#' \dontrun{
#' mapp_create(df, "mapping.xlsx")
#' }
mapp_create <- function(df_raw, mapping_file) {
  df_varlab <- gen_var_table(df_raw) %>%
    dplyr::mutate(new_label = "", new_name = "", op = "")
  df_vallabs <- gen_label_table(df_raw) %>%
    dplyr::mutate(
      new_label      = "",
      sum_var_label  = "",
      sum_var_value  = "",
      sum_var_vallab = ""
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
#' Extract variable label sheet of Excel mapping file to dataframe
#'
#' @param  self \code{Mapping} object
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return Command block table of the "Variables" sheet of the Excel mapping
#'   file.
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' m <- Mapping$new(NULL, mapping_file)
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_var_sheet_cmd_table(m)
mapp_var_sheet_cmd_table <- function(self, sheet = "Variables") {
  self$cmd$sheet_data_raw[[sheet]] %>%
    format_df_varl()
}

read_variables_sheet_raw <- function(mapping_file, sheet = "Variables", translate_xlsm = FALSE) {
  if (translate_xlsm) {
    df_varl <- read_xlsm_variables_sheet_raw(mapping_file, sheet)
  } else {
    df_varl <- readxl::read_xlsx(
      mapping_file,
      sheet = sheet,
      col_types = "text"
    )
  }
  df_varl
}
read_xlsm_variables_sheet_raw <- function(mapping_file, sheet) {
  readxl::read_xlsx(
    mapping_file,
    sheet = sheet,
    range = cellranger::cell_limits(c(3, 1), c(NA, 13)),
    col_names = c("var", "nn1", "varlab", "nn2", "nn3", "nn4", "nn5", "nn6", "nn7", "nn8", "op", "new_name", "new_label"),
    col_types = "text"
  ) %>%
    dplyr::select(-dplyr::matches("^nn[1-8]$"))
}

format_df_varl <- function(df_varl) {
  df_varl %>%
    dplyr::mutate(row = (dplyr::row_number() + 1) %>% as.character()) %>%
    parse_varlab_cmd_table()
}



parse_varlab_cmd_table <- function(df_varl) {
  dplyr::bind_rows(
    parse_str_to_num_cmd_block(df_varl),
    parse_autorecode_cmd_block(df_varl),
    parse_drop_cmd_block(df_varl),
    parse_rename_cmd_block(df_varl),
    parse_newlab_cmd_blocks(df_varl)
  )
}

parse_newlab_cmd_blocks <- function(df_varl) {
  df_varl %>%
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
  df_varl %>%
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
  df_varl %>%
    dplyr::filter(.data$op == "a") %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#AUTOREC") %>%
    dplyr::mutate(new_var = .data$var) %>%
    dplyr::select(-.data$new_label, -.data$op, -.data$varlab, -.data$new_name) %>%
    dplyr::group_by(.data$sheet, .data$action, .data$new_var, .data$row) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}


parse_drop_cmd_block <- function(df_varl) {
  df_varl %>%
    dplyr::filter(.data$op == "d") %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#DROP") %>%
    dplyr::group_by(.data$sheet, .data$action) %>%
    dplyr::summarise(
      row = paste(row, collapse = ", "),
      new_var = NA_character_,
      vars = list(.data$var)
    ) %>%
    dplyr::group_by(.data$sheet, .data$action, .data$new_var, row) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}


parse_str_to_num_cmd_block <- function(df_varl) {
  df_varl %>%
    dplyr::filter(.data$op == "n") %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#STR2NUM") %>%
    dplyr::mutate(new_var = .data$var) %>%
    dplyr::select(-.data$new_label, -.data$op, -.data$varlab, -.data$new_name) %>%
    dplyr::group_by(.data$sheet, .data$action, .data$new_var, .data$row) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}





#' Extract value label sheet of Excel mapping file to dataframe
#'
#' @param  self \code{Mapping} object
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return Command block table of the "Label" sheet of the Excel mapping file.
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' m <- Mapping$new(NULL, mapping_file)
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_vallab_sheet_cmd_table(m)
mapp_vallab_sheet_cmd_table <- function(self, sheet = "Label") {
  df_vall <- self$cmd$sheet_data_raw[[sheet]]

  df_vall <- df_vall %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
  dplyr::bind_rows(
    parse_newvall_cmd_table(df_vall),
    parse_sumvar_cmd_table(df_vall)
  )
}

read_label_sheet_raw <- function(mapping_file, sheet, translate_xlsm = FALSE) {
  if (translate_xlsm) {
    df_vall <- read_xlsm_label_sheet_raw(mapping_file, sheet)
  } else {
    df_vall <- readxl::read_xlsx(
      mapping_file,
      sheet = sheet
    )
  }
  df_vall
}
read_xlsm_label_sheet_raw <- function(mapping_file, sheet) {
  readxl::read_xlsx(
    mapping_file,
    sheet = sheet,
    range = cellranger::cell_limits(c(3, 1), c(NA, 9)),
    col_names = c(
      "var", "nv", "vallab", "new_label", "not_needed1",
      "not_needed2", "sum_var_label", "sum_var_value",
      "sum_var_vallab"
    ),
    col_types = "text"
  ) %>%
    dplyr::select(-.data$not_needed1, -.data$not_needed2) %>%
    dplyr::mutate(
      nv = as.numeric(.data$nv),
      sum_var_value = as.numeric(.data$sum_var_value)
    ) %>%
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
    dplyr::relocate(.data$sheet, .data$action) %>%
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
    dplyr::relocate(.data$sheet, .data$action) %>%
    dplyr::group_by(.data$sheet, .data$action, .data$new_var) %>%
    dplyr::mutate(row = paste(.data$row, collapse = ", ")) %>%
    dplyr::group_by(.data$sheet, .data$action, .data$row, .data$new_var) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}




#' Extract free1 sheet of Excel mapping file to dataframe
#'
#' @param  self \code{Mapping} object
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return Command block table of the "Free" sheet of the Excel mapping file.
#' @export
#'
#' @examples
#' # create empty template from labelled dataset `fake_survey` via:
#' # mapp_create(fake_survey, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' m <- Mapping$new(NULL, mapping_file)
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_free_sheet_cmd_table(m)
mapp_free_sheet_cmd_table <- function(self, sheet = "Free1") {
  df_free <- self$cmd$sheet_data_raw[[sheet]]
  if (nrow(df_free) > 0) {
    df_free <- df_free[1:6]
  } else {
    df_free <-
      purrr::map_dfc(1:5, ~ character()) %>%
      purrr::set_names(paste0("X", 1:5)) %>%
      dplyr::mutate(row = NA_character_)
  }
  df_free %>%
    put_absolute_filepaths(self$mapping_file) %>%
    process_raw_free_cmd_table()
}
mapp_free_sheet_cmd_table_raw <- function(mapping_file, sheet = "Free1") {
  df_free <- readxl::read_xlsx(
    mapping_file,
    range = cellranger::cell_limits(ul = c(1, 1), lr = c(NA, 5), sheet = sheet),
    col_names = paste0("X", 1:5),
    col_types = "text"
  ) %>%
    dplyr::mutate(row = dplyr::row_number()) %>%
    dplyr::filter(dplyr::if_any(dplyr::starts_with("X"), ~ !is.na(.)))
  df_free
}



process_raw_free_cmd_table <- function(df_free) {
  if (nrow(df_free) == 0) {
    return(NULL)
  }
  df_free %>%
    delete_empty_X1_not_multiline() %>%
    add_curlies_to_cell_with_spaces() %>%
    curlychop() %>%
    dplyr::group_by(.data$row) %>%
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
      action == "#IF" ~ stringr::str_remove(.data$X3, "=.*") %>% stringr::str_squish(),
      action == "#KG" ~ paste(.data$X2, .data$X3, sep = "_"),
      action == "#MERGE" ~ paste(.data$X4, collapse = ", ")
    ))
}

add_curlies_to_cell_with_spaces <- function(df_free) {
  # transform X2 containing spaces to curlychop()able (surrounded by curly
  # braces):
  df_free %>%
    dplyr::mutate(X2 = ifelse(
      grepl("(#VARL|#REC|#VALL|#AVALL)", .data$X1) == TRUE & stringr::str_detect(.data$X2, " ") & stringr::str_detect(.data$X2, "\\{", negate = TRUE),
      paste0("{", .data$X2, "}"),
      .data$X2
    ))
}
delete_empty_X1_not_multiline <- function(df_free) {
  df_free %>%
    dplyr::mutate(temp = stringr::str_detect(
      .data$X1,
      "^#VALL$|^#REC$|^#AVALL$",
      negate = TRUE
    )) %>%
    tidyr::fill(.data$temp) %>%
    dplyr::mutate(temp = .data$temp & is.na(.data$X1)) %>%
    dplyr::filter(!.data$temp) %>%
    dplyr::select(-.data$temp)
}
