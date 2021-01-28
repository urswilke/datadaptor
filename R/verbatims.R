#' Extract verbatim sheet related data of Excel mapping file to dataframe
#'
#' @param mapping_file name of the Excel mapping file
#' @param sheet name of the sheet in the Excel mapping file
#' @param translate_xlsm logical whether to translate the format of Wolf's mapping file to the format of `mapp_create()``
#' @param verba_file character string of the name of the Verbatim file
#' @param id_var_str character string of the name of the id variable in the data file
#'
#' @return
#' @export
#'
#' @examples
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' verbatim_filepath <- system.file("extdata", "Verbatims_fake_survey.xlsx", package = "datenanpassr")
#' # open these Excel files (that come with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_filepath)
#' utils::browseURL(verbatim_filepath)
#' }
#' mapp_verbatim_sheet_cmd_tbl(mapping_filepath, verba_file = verbatim_filepath, id = "id")
mapp_verbatim_sheet_cmd_tbl <- function(
  mapping_file,
  verba_file = extract_verbatim_file_name(mapping_file, sheet),
  sheet = "Verbatims",
  id_var_str
) {
  l <- make_verba_data_raw(mapping_file, verba_file, sheet)
  make_verbatim_assignment_table_raw(l) %>%
    dplyr::mutate(
      action = "#Verba",
      new_var = var_ziel,
      sheet = sheet,
      val_assign_temp = val_assign,
      id_var_str = id_var_str
    ) %>%
    dplyr::group_by(sheet, action, row, new_var, val_assign_temp) %>%
    tidyr::nest() %>%
    dplyr::ungroup() %>%
    dplyr::select(-val_assign_temp)
}

make_verba_sheet_df <- function(mapping_file, sheet) {
  mapping_verba_sheet <-
    readxl::read_excel(mapping_file,
                       skip = 16,
                       sheet = sheet,
                       col_names = TRUE) %>%
    tidyr::drop_na(VariableOriginal) %>%
    dplyr::select(VariableOriginal:`Tabellen-blatt`, VariableZiel) %>%
    # HACK!!! TODO: replace with general regex
    dplyr::mutate(VariableZiel = un_OT_ize(VariableZiel, VariableOriginal) %>% un_OT_ize(VariableOriginal) %>% un_OT_ize(VariableOriginal)) %>%
    dplyr::relocate(q_id = `Tabellen-blatt`)
  mapping_verba_sheet
}
extract_verbatim_file_name <- function(mapping_file, sheet) {
  file_path <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet,
    range = cellranger::cell_cols(c("B:D")),
    skip = 0
  ) %>%
    dplyr::rename_all(~LETTERS[2:4]) %>%
    dplyr::filter(B == "Filename input") %>%
    dplyr::pull(D) %>%
    stringr::str_replace_all("\\\\", "/")
  if (is.na(file_path)) {
    return(file_path)
  }
  if (fs::is_absolute_path(file_path)) {
    return(file_path)
  }
  else {
    mapping_dir <- mapping_file %>% fs::path_dir()
    return(paste0(mapping_dir, "/", file_path))
  }
}
make_assigns_list <- function(verba_file, mapping_verba_sheet) {
  verba_file_sheets <-
    verba_file %>%
    readxl::excel_sheets() %>%
    # except "Codestufen", the first sheet:
    .[-1] %>%
    purrr::set_names()

  read_assigns <- function(sheet_name){
    readxl::read_excel(verba_file, sheet = sheet_name, col_names = TRUE, range = cellranger::cell_limits(ul = c(32, 4))) %>%
      dplyr::select(orig_var = `Orig. Variable`, ID, dplyr::matches("^Zuord "))
  }


  verba_file_sheets %>%
    purrr::map(~read_assigns(.x))
}
make_codestufen_list <- function(verba_file) {
  df_codestufen <-
    readxl::read_excel(
      verba_file,
      sheet = "Codestufen",
      col_names = TRUE,
      range = cellranger::cell_limits(ul = c(1, 2))
    ) %>%
    dplyr::mutate_all(~ ifelse(. == "<reserved>", NA, .)) %>%
    dplyr::mutate(Code = dplyr::row_number()) %>%
    dplyr::relocate(Code)
  2:length(df_codestufen) %>%
    purrr::set_names(names(df_codestufen)[-1]) %>%
    purrr::map(~dplyr::select(df_codestufen, 1, lab = .x) %>% tidyr::drop_na())
}
#function to replace the term {OT...} in var_ziel by the corresponding substring
#in orig_var:
un_OT_ize <- function(var_ziel,orig_var){
  # exctract the three digits in {OT...} :
  copyDigits <- stringr::str_match(var_ziel,"\\{OT(.*?)\\}")[,2]
  # the first two digits in the beginning represent the starting positition:
  cp1stPos <- copyDigits %>% stringr::str_match("^\\d\\d") %>% as.numeric()
  # the last digit in the end represent the length:
  cpLength <- copyDigits %>% stringr::str_match("\\d$") %>% as.numeric()
  # extract substring of orig_var:
  replaceStr <- stringr::str_sub(orig_var, cp1stPos, cp1stPos + cpLength - 1)
  # replace the term {OT...} by the latter substring:
  var_name <- stringr::str_replace(var_ziel,"\\{OT\\d\\d\\d\\}",replaceStr)
  var_name
}


make_verba_data_raw <- function(mapping_file, verba_file, sheet) {
  mapping_verba_sheet <- make_verba_sheet_df(mapping_file, sheet = sheet)
  verba_sheets <- mapping_verba_sheet$q_id
  l_codestufen <- make_codestufen_list(verba_file)
  l_codestufen <- l_codestufen[verba_sheets]
  l_assigns <- make_assigns_list(verba_file, mapping_verba_sheet)
  l_assigns <- l_assigns[verba_sheets]
  l <- vector("list", length(verba_sheets))
  for (i in 1:length(verba_sheets)) {
    l[[i]][["name"]] <- verba_sheets[i]
    l[[i]][["meta"]] <- mapping_verba_sheet %>% dplyr::slice(i)
    l[[i]][["assignments"]] <- l_assigns[[i]] %>% dplyr::filter(orig_var == l[[i]][["meta"]] %>% dplyr::pull(VariableOriginal))
    l[[i]][["labs"]] <- l_codestufen[i]
  }
  l
}
make_mdg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  df_vars_n_labs <- i_l$labs[[1]] %>%
    dplyr::mutate(
      var_ziel = var_template %>% stringr::str_replace(
        "\\{nn\\}",
        Code %>% as.character()
      )
    ) %>%
    dplyr::rename(varlab = lab) %>%
    dplyr::mutate(varlab = as.list(varlab))
  df_assigns <- i_l$assignments %>%
    tidyr::gather(i_assign, code_assign, dplyr::starts_with("Zuord")) %>%
    dplyr::select(-i_assign) %>%
    tidyr::drop_na() %>%
    dplyr::group_by(code_assign) %>%
    dplyr::summarise(id_list = list(unique(ID))) %>%
    dplyr::full_join(
      df_vars_n_labs,
      by = c("code_assign" = "Code")
    ) %>%
    dplyr::mutate(
      val_assign = 1,
      vallab = rep(list(c("unselected" = 0, "selected" = 1)), nrow(.))) %>%
    dplyr::select(-code_assign)
  df_assigns
}
make_efa_assignment_table <- function(i_l) {
  # in case multiple "Zuord" columns occur in assignment data, code would break
  # and only the first is needed:
  i_l$assignments <- i_l$assignments %>% dplyr::select(1:3)
  make_mcg_assignment_table(i_l)
}
make_mcg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  vallabs <- i_l$labs[[1]] %>% dplyr::relocate(2) %>% tibble::deframe()
  df_assigns <- i_l$assignments %>%
    tidyr::gather(i_assign, val_assign, dplyr::starts_with("Zuord")) %>%
    dplyr::mutate(i_assign = stringr::str_remove(i_assign, "^Zuord ") %>% as.numeric()) %>%
    dplyr::group_by(i_assign, val_assign) %>%
    dplyr::summarise(id_list = list(ID)) %>%
    dplyr::mutate(
      var_ziel = var_template %>% stringr::str_replace(
        "\\{nn\\}",
        i_assign %>% as.character()
      )
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      varlab = rep(list(NULL), nrow(.)),
      vallab = rep(list(vallabs), nrow(.))
    ) %>%
    dplyr::select(-i_assign)
  df_assigns
}
translate_verba_line <- function(verba_type, verba_data) {
  switch (verba_type,
          "1" = make_efa_assignment_table(verba_data),
          "2" = make_mcg_assignment_table(verba_data),
          "3" = make_mdg_assignment_table(verba_data),
          stop("Invalid verbatim type code.")
  )
}

make_verbatim_assignment_table_raw <- function(l){
  verba_types <- l %>% purrr::map_dbl(purrr::chuck, "meta", "EFA1MCG2MDG3")
  purrr::map2(verba_types, l, translate_verba_line) %>%
    dplyr::bind_rows(.id = "row")
}
