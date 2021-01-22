# library(datenanpassr)
library(tidyverse)
map_file <- "inst/extdata/mapping.xlsx"
# sheet = "Verbatims"
# verba_file = datenanpassr:::mapp_extract_verbatim_file(map_file, sheet)
# df_assigns <- make_assigns_df(verba_file, mapping_verba_sheet)
# df_codestufen <- datenanpassr:::make_codestufen_df(verba_file)
# df_cats <- make_labs_df(df_codestufen, mapping_verba_sheet)
make_verba_sheet_df <- function(map_file, sheet) {
  mapping_verba_sheet <-
    readxl::read_excel(map_file,
                       skip = 16,
                       sheet = sheet,
                       col_names = TRUE) %>%
    tidyr::drop_na(VariableOriginal) %>%
    dplyr::select(VariableOriginal:`Tabellen-blatt`, VariableZiel) %>%
    relocate(q_id = `Tabellen-blatt`)
  mapping_verba_sheet
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
make_assigns_list <- function(verba_file, mapping_verba_sheet) {
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
      dplyr::select(orig_var = `Orig. Variable`, ID, dplyr::matches("^Zuord "))
  }


  # gather & prepare all assignments ------------------------------------------
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
    # in the Codestufen sheet there is no title for the code column; R
    # automatically has given the name X__1; change it to "Code"...:
    dplyr::mutate(Code = dplyr::row_number()) %>%
    relocate(Code)
  # %>%
  #   tidyr::gather(q_id, Beschreibung,-Code) %>%
  #   # only retain codes where a category ("Beschreibung") exists:
  #   tidyr::drop_na(Beschreibung)
  2:length(df_codestufen) %>%
    set_names(names(df_codestufen)[-1]) %>%
    map(~select(df_codestufen, 1, lab = .x) %>% drop_na())
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


make_verba_data_raw <- function(map_file, verba_file, sheet) {
  mapping_verba_sheet <- make_verba_sheet_df(map_file, sheet = sheet)
  verba_sheets <- mapping_verba_sheet$q_id
  l_codestufen <- make_codestufen_list(verba_file)
  l_codestufen <- l_codestufen[verba_sheets]
  l_assigns <- make_assigns_list(verba_file, mapping_verba_sheet)
  l_assigns <- l_assigns[verba_sheets]
  l <- vector("list", length(verba_sheets))
  for (i in 1:length(verba_sheets)) {
    l[[i]][["name"]] <- verba_sheets[i]
    l[[i]][["meta"]] <- mapping_verba_sheet %>% slice(i)
    l[[i]][["assignments"]] <- l_assigns[[i]] %>% filter(orig_var == l[[i]][["meta"]] %>% pull(VariableOriginal))
    l[[i]][["labs"]] <- l_codestufen[i]
  }
  l
}
# mapping_verba_sheet %>% filter(EFA1MCG2MDG3 == 3)

# l %>% map_dbl(chuck, 2, "EFA1MCG2MDG3")
# i_l <- l[[4]]
make_mdg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  df_vars_n_labs <- i_l$labs[[1]] %>%
    mutate(
      var_ziel = var_template %>% str_replace(
        "\\{nn\\}",
        Code %>% as.character()
      )
    ) %>%
    rename(varlab = lab)
  df_assigns <- i_l$assignments %>%
    tidyr::gather(i_assign, code_assign, starts_with("Zuord")) %>%
    dplyr::select(-i_assign) %>%
    tidyr::drop_na() %>%
    group_by(code_assign) %>%
    summarise(id_list = list(ID)) %>%
    full_join(
      df_vars_n_labs,
      by = c("code_assign" = "Code")
    ) %>%
    dplyr::mutate(
      val_assign = 1,
      vallab = rep(list(c("unselected" = 0, "selected" = 1)), nrow(.))) %>%
    dplyr::select(-code_assign)
  df_assigns
}
# make_mdg_assignment_table(i_l)
# l %>% map_dfr(make_mdg_assignment_table)
#
#
# i_l <- l[[5]]
make_mcg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  vallabs <- i_l$labs[[1]] %>% relocate(2) %>% deframe()
  df_assigns <- i_l$assignments %>%
    tidyr::gather(i_assign, val_assign, starts_with("Zuord")) %>%
    dplyr::mutate(i_assign = stringr::str_remove(i_assign, "^Zuord ") %>% as.numeric()) %>%
    group_by(i_assign, val_assign) %>%
    summarise(id_list = list(ID)) %>%
    mutate(
      var_ziel = var_template %>% str_replace(
        "\\{nn\\}",
        i_assign %>% as.character()
      )
    ) %>%
    ungroup() %>%
    dplyr::mutate(
      vallab = rep(list(vallabs), nrow(.))) %>%
    select(-i_assign)
  df_assigns
}
translate_verba_line <- function(verba_type, verba_data) {
  switch (verba_type,
    "1" = make_mcg_assignment_table(verba_data),
    "2" = make_mcg_assignment_table(verba_data),
    "3" = make_mdg_assignment_table(verba_data),
    stop("Invalid verbatim type code.")
  )
}

make_verbatim_assignment_table_raw <- function(l){
  verba_types <- l %>% map_dbl(chuck, "meta", "EFA1MCG2MDG3")
  map2(verba_types, l, translate_verba_line) %>%
    bind_rows(.id = "row")
}
make_verba_cmd_tbl <- function(map_file, verba_file = mapp_extract_verbatim_file(map_file, sheet), sheet = "Verbatims") {
  l <- make_verba_data_raw(map_file, verba_file, sheet)
  make_verbatim_assignment_table_raw(l) %>%
    mutate(
      action = "#Verba",
      new_var = var_ziel,
      sheet = sheet
    ) %>%
    group_by(sheet, action, row, new_var) %>%
    nest() %>%
    ungroup()
}



v <- make_verba_cmd_tbl(map_file)
# l %>% make_verbatim_assignment_table_raw()
# make_mcg_assignment_table(i_l)
# l %>% map_dfr(make_mdg_assignment_table)
# df_assigns_overview <- make_assigns_cmd_table(df_assigns, df_cats)
# make_verbatim_cmd_table(map_file)
# make_assigns_cmd_table <- function(df_assigns, df_cats) {
#   df_assigns_overview <-
#     df_assigns %>%
#     dplyr::mutate(code_cat_join = ifelse(EFA1MCG2MDG3 == 3, code_assign, NA)) %>%
#     dplyr::group_by(q_id, var_ziel, EFA1MCG2MDG3, code_cat_join, val_assign) %>%
#     dplyr::summarise(id_list = list(as.numeric(DC_ID))) %>%
#     dplyr::left_join(df_cats, by = c("q_id", "code_cat_join" = "code")) %>%
#     dplyr::mutate(
#       sheet = "verbatims",
#       new_var = var_ziel,
#       action = "#Verba",
#       row = dplyr::cur_group_id() %>% as.character()
#     ) %>%
#     dplyr::ungroup() %>%
#     dplyr::mutate(assigned_val = val_assign) %>%
#     dplyr::group_by(sheet, action, row, new_var, assigned_val) %>%
#     tidyr::nest() %>%
#     dplyr::ungroup()
#   df_assigns_overview
# }
# make_labs_df <- function(df_codestufen, mapping_verba_sheet) {
#   make_verbatim_labels <- function(EFA1MCG2MDG3, data) {
#     switch (
#       EFA1MCG2MDG3,
#       "1" = list(purrr::set_names(data$Code, data$Beschreibung)),
#       "2" = list(purrr::set_names(data$Code, data$Beschreibung)),
#       "3" = tibble::tibble(code = data$Code, varlab = data$Beschreibung),
#       stop("Invalid EFA1MCG2MDG3 code")
#     )
#   }
#
#   df_labs <- df_codestufen %>%
#     dplyr::group_by(q_id) %>%
#     tidyr::nest() %>%
#     dplyr::left_join(mapping_verba_sheet %>%
#                        dplyr::select(q_id = `Tabellen-blatt`, EFA1MCG2MDG3) %>%
#                        dplyr::distinct(q_id, .keep_all = TRUE),
#                      by = "q_id") %>%
#     dplyr::summarise(vallab = purrr::map2(EFA1MCG2MDG3, data, make_verbatim_labels),
#                      .groups = "drop") %>%
#     # due to the structure of the mixed output of make_verbatim_labels(), of lists
#     # and tibbles, this unnests the tibbles (containing code and varlab columns),
#     # and doesn't change the named vallab lists:
#     tidyr::unnest(vallab)
#   df_labs
# }
#
#
#
# make_verbatim_cmd_table <- function(map_file, verba_file = mapp_extract_verbatim_file(map_file, sheet), sheet = "Verbatims"){
#   if (is.na(verba_file)) {
#     return(tibble::tibble())
#   }
#   mapping_verba_sheet <- make_verba_sheet_df(map_file, sheet = sheet)
#   df_assigns <- make_assigns_df(verba_file, mapping_verba_sheet)
#   df_codestufen <- make_codestufen_df(verba_file)
#   df_cats <- make_labs_df(df_codestufen, mapping_verba_sheet)
#   df_assigns_overview <- make_assigns_cmd_table(df_assigns, df_cats)
#   df_assigns_overview
# }
#
#
#
#
#
#
# %>%
#   # add the EFA1MCG2MDG3 information & VariableZiel from the verbatim sheet in
#   # the mapping file:
#   dplyr::full_join(
#     mapping_verba_sheet,
#     by = c(
#       "Orig. Variable" = "VariableOriginal",
#       "q_id" = "Tabellen-blatt"
#     )
#   )
#
#
# # df_assigns
# %>%
#   # replace the {OT...} term:
#   dplyr::mutate(VariableZiel = un_OT_ize(VariableZiel, `Orig. Variable`)) %>%
#   # depending on the variable type, the name of the variable to be assigned is
#   # created by replacing the "{nn}" term: if one wants to allow multiple
#   # assigned variable for EFA, the first line has to be adapted according to the
#   # second...
#   dplyr::mutate(var_ziel = dplyr::case_when(EFA1MCG2MDG3 == 1 ~ stringr::str_remove(VariableZiel, "\\{nn\\}"),
#                                             EFA1MCG2MDG3 == 2 ~ stringr::str_replace(VariableZiel, "\\{nn\\}", as.character(i_assign)),
#                                             EFA1MCG2MDG3 == 3 ~ stringr::str_replace(VariableZiel, "\\{nn\\}", as.character(code_assign)))) %>%
#   # if there are several assignment columns for EFA variables, this line removes
#   # them:
#   # filter(!(EFA1MCG2MDG3 == 1 & i_assign != 1)) %>%
#   # the value to be assigned for mdg variables is 1, otherwise code_assign:
#   dplyr::mutate(val_assign = dplyr::if_else(EFA1MCG2MDG3 == 3, 1, code_assign)) %>%
#   # the column code_assign is only needed for mdg variables to assign the right
#   # variable labels later. Therefore, it is set to NA for the other variables:
#   # dplyr::mutate(code_assign = dplyr::if_else(EFA1MCG2MDG3 != 3, NA_real_, code_assign)) %>%
#   dplyr::select(-i_assign) %>%
#   dplyr::rename(DC_ID = ID) %>%
#   # the sorting of DC_ID is probably very important that the assigning of the
#   # verbatim codes later is done in the correct order:
#   dplyr::arrange(DC_ID)
#
#
#
# df_assigns <-
#   l_assigns_raw %>%
#   # write all the assignments in the same data frame:
#   dplyr::bind_rows(.id = "q_id") %>%
#   # gather all the assignments in two columns: i_assign is the index of the
#   # column (Zuord 1, ..., 5) and code_assign is the assigned code:
#   tidyr::gather(i_assign, code_assign, starts_with("Zuord")) %>%
#   # this removes the data where nothing was assigned. If one wants to have a
#   # stable number of variables assigned, this should be changed:
#   tidyr::drop_na(code_assign) %>%
#   # remove the substring "Zuord ":
#   dplyr::mutate(i_assign = stringr::str_remove(i_assign, "^Zuord "))
# df_assigns
#
#
# make_assigns_df <- function(verba_file, mapping_verba_sheet) {
#   verba_file_sheets <-
#     verba_file %>%
#     readxl::excel_sheets() %>%
#     # except "Codestufen", the first sheet:
#     .[-1] %>%
#     # by setting names, the map function applied later, will assign these names to
#     # the created list elements...
#     purrr::set_names()
#
#   read_assigns <- function(sheet_name){
#     readxl::read_excel(verba_file, sheet = sheet_name, col_names = TRUE, range = cellranger::cell_limits(ul = c(32, 4))) %>%
#       dplyr::select(`Orig. Variable`, ID, Antwort, matches("^Zuord "))
#   }
#
#
#   # gather & prepare all assignments ------------------------------------------
#   l_assigns_raw <-
#     verba_file_sheets %>%
#     purrr::map(~read_assigns(.x))
#
#
#   df_assigns <-
#     l_assigns_raw %>%
#     # write all the assignments in the same data frame:
#     dplyr::bind_rows(.id = "q_id") %>%
#     # add the EFA1MCG2MDG3 information & VariableZiel from the verbatim sheet in
#     # the mapping file:
#     # gather all the assignments in two columns: i_assign is the index of the
#     # column (Zuord 1, ..., 5) and code_assign is the assigned code:
#     tidyr::gather(i_assign, code_assign, starts_with("Zuord")) %>%
#     # this removes the data where nothing was assigned. If one wants to have a
#     # stable number of variables assigned, this should be changed:
#     # tidyr::drop_na(code_assign) %>%
#     # remove the substring "Zuord ":
#     dplyr::mutate(i_assign = stringr::str_remove(i_assign, "^Zuord ") %>% as.numeric()) %>%
#     select(-Antwort) %>%
#     rename(orig_var = `Orig. Variable`)
#
# }
#
#
# df_assigns <- make_assigns_df(verba_file, mapping_verba_sheet)
#
#
# # new ---------------------------------------------------------------------
#
# df_assigns
# df_assigns_compact <- df_assigns %>%
#   left_join(mapping_verba_sheet %>% select(q_id, EFA1MCG2MDG3, VariableZiel, orig_var = VariableOriginal)) %>%
#   # dplyr::mutate(val_assign = dplyr::if_else(EFA1MCG2MDG3 == 3, 1, code_assign)) %>%
#   select(-EFA1MCG2MDG3) %>%
#   group_by(q_id, VariableZiel, orig_var, i_assign, code_assign) %>%
#   summarise(ids = list(ID))
# x <- mapping_verba_sheet %>%
#   left_join(df_cats) %>%
#   left_join(df_assigns_compact)
# x %>% unnest(ids)
