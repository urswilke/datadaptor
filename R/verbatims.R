

make_assigns_df <- function(verba_file, mapping_verba_sheet) {
  verba_file_sheets <-
    verba_file %>%
    readxl::excel_sheets() %>%
    # except "Codestufen", the first sheet:
    .[-1] %>%
    # by setting names, the map function applied later, will assign these names to
    # the created list elements...
    purrr::set_names()

  read_assigns <- function(sheet_name){
    readxl::read_excel(verba_file, sheet = sheet_name, col_names = TRUE, range = cellranger::cell_limits(ul = c(32, 4))) %>%
      dplyr::select(`Orig. Variable`, ID, Antwort, dplyr::matches("^Zuord "))
  }


  # gather & prepare all assignments ------------------------------------------
  l_assigns_raw <-
    verba_file_sheets %>%
    purrr::map(~read_assigns(.x))


  df_assigns <-
    l_assigns_raw %>%
    # write all the assignments in the same data frame:
    dplyr::bind_rows(.id = "q_id") %>%
    # add the EFA1MCG2MDG3 information & VariableZiel from the verbatim sheet in
    # the mapping file:
    dplyr::full_join(
      mapping_verba_sheet,
      by = c(
        "Orig. Variable" = "VariableOriginal",
        "q_id" = "Tabellen-blatt"
      )
    ) %>%
    # gather all the assignments in two columns: i_assign is the index of the
    # column (Zuord 1, ..., 5) and code_assign is the assigned code:
    tidyr::gather(i_assign, code_assign, starts_with("Zuord")) %>%
    # this removes the data where nothing was assigned. If one wants to have a
    # stable number of variables assigned, this should be changed:
    tidyr::drop_na(code_assign) %>%
    # remove the substring "Zuord ":
    dplyr::mutate(i_assign = stringr::str_remove(i_assign, "^Zuord ")) %>%
    # replace the {OT...} term:
    dplyr::mutate(VariableZiel = un_OT_ize(VariableZiel, `Orig. Variable`)) %>%
    # depending on the variable type, the name of the variable to be assigned is
    # created by replacing the "{nn}" term: if one wants to allow multiple
    # assigned variable for EFA, the first line has to be adapted according to the
    # second...
    dplyr::mutate(var_ziel = dplyr::case_when(EFA1MCG2MDG3 == 1 ~ stringr::str_remove(VariableZiel, "\\{nn\\}"),
                                              EFA1MCG2MDG3 == 2 ~ stringr::str_replace(VariableZiel, "\\{nn\\}", as.character(i_assign)),
                                              EFA1MCG2MDG3 == 3 ~ stringr::str_replace(VariableZiel, "\\{nn\\}", as.character(code_assign)))) %>%
    # if there are several assignment columns for EFA variables, this line removes
    # them:
    # filter(!(EFA1MCG2MDG3 == 1 & i_assign != 1)) %>%
    # the value to be assigned for mdg variables is 1, otherwise code_assign:
    dplyr::mutate(val_assign = dplyr::if_else(EFA1MCG2MDG3 == 3, 1, code_assign)) %>%
    # the column code_assign is only needed for mdg variables to assign the right
    # variable labels later. Therefore, it is set to NA for the other variables:
    # dplyr::mutate(code_assign = dplyr::if_else(EFA1MCG2MDG3 != 3, NA_real_, code_assign)) %>%
    dplyr::select(-i_assign) %>%
    dplyr::rename(DC_ID = ID) %>%
    # the sorting of DC_ID is probably very important that the assigning of the
    # verbatim codes later is done in the correct order:
    dplyr::arrange(DC_ID)
  df_assigns
}
make_codestufen_df <- function(verba_file) {
  df_codestufen <-
    readxl::read_excel(
      verba_file,
      sheet = "Codestufen",
      col_names = TRUE,
      range = cellranger::cell_limits(ul = c(1, 2))
    ) %>%
    # in the Codestufen sheet there is no title for the code column; R
    # automatically has given the name X__1; change it to "Code"...:
    dplyr::mutate(Code = dplyr::row_number()) %>%
    tidyr::gather(q_id, Beschreibung,-Code) %>%
    # only retain codes where a category ("Beschreibung") exists:
    tidyr::drop_na(Beschreibung)
  df_codestufen
}
make_verba_sheet_df <- function(map_file, sheet) {
  mapping_verba_sheet <-
    readxl::read_excel(map_file,
                       skip = 16,
                       sheet = sheet,
                       col_names = TRUE) %>%
    tidyr::drop_na(VariableOriginal) %>%
    dplyr::select(VariableOriginal:`Tabellen-blatt`, VariableZiel)
  mapping_verba_sheet
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
make_assigns_cmd_table <- function(df_assigns, df_cats) {
  df_assigns_overview <-
    df_assigns %>%
    dplyr::mutate(code_cat_join = ifelse(EFA1MCG2MDG3 == 3, code_assign, NA)) %>%
    dplyr::group_by(q_id, var_ziel, EFA1MCG2MDG3, code_cat_join, val_assign) %>%
    dplyr::summarise(id_list = list(as.numeric(DC_ID))) %>%
    dplyr::left_join(df_cats, by = c("q_id", "code_cat_join" = "code")) %>%
    dplyr::mutate(
      sheet = "verbatims",
      new_var = var_ziel,
      action = "#Verba",
      row = dplyr::cur_group_id() %>% as.character()
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(assigned_val = val_assign) %>%
    dplyr::group_by(sheet, action, row, new_var, assigned_val) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
  df_assigns_overview
}
make_labs_df <- function(df_codestufen, mapping_verba_sheet) {
  make_verbatim_labels <- function(EFA1MCG2MDG3, data) {
    switch (
      EFA1MCG2MDG3,
      "1" = list(purrr::set_names(data$Code, data$Beschreibung)),
      "2" = list(purrr::set_names(data$Code, data$Beschreibung)),
      "3" = tibble::tibble(code = data$Code, varlab = data$Beschreibung),
      stop("Invalid EFA1MCG2MDG3 code")
    )
  }

  df_labs <- df_codestufen %>%
    dplyr::group_by(q_id) %>%
    tidyr::nest() %>%
    dplyr::left_join(mapping_verba_sheet %>%
                dplyr::select(q_id = `Tabellen-blatt`, EFA1MCG2MDG3) %>%
                dplyr::distinct(q_id, .keep_all = TRUE),
              by = "q_id") %>%
    dplyr::summarise(vallab = purrr::map2(EFA1MCG2MDG3, data, make_verbatim_labels),
              .groups = "drop") %>%
    # due to the structure of the mixed output of make_verbatim_labels(), of lists
    # and tibbles, this unnests the tibbles (containing code and varlab columns),
    # and doesn't change the named vallab lists:
    tidyr::unnest(vallab)
  df_labs
}



make_verbatim_cmd_table <- function(map_file, verba_file = mapp_extract_verbatim_file(map_file, sheet), sheet = "Verbatims"){
  if (is.na(verba_file)) {
    return(tibble::tibble())
  }
  mapping_verba_sheet <- make_verba_sheet_df(map_file, sheet = sheet)
  df_assigns <- make_assigns_df(verba_file, mapping_verba_sheet)
  df_codestufen <- make_codestufen_df(verba_file)
  df_cats <- make_labs_df(df_codestufen, mapping_verba_sheet)
  df_assigns_overview <- make_assigns_cmd_table(df_assigns, df_cats)
  df_assigns_overview
}


mapp_extract_verbatim_file <- function(mapping_file, sheet) {
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

