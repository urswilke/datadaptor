switch_sheets_vars_label <- function(sheets) {
  var_index <- which(sheets == "Variables")
  lab_index <- which(sheets == "Label")
  sheets[var_index] <- "Label"
  sheets[lab_index] <- "Variables"
  sheets
}
tab_sheet_types <- function(sheets) {
  sheet_types <- c("^Variables", "^Label", "^Verbatims", "^Free")

  # vector of sheets with names defined by types:
  sheet_cats <- purrr::map(
    sheets,
    ~stringr::str_detect(.x, sheet_types)
  ) %>%
    purrr::map(
      ~ sheet_types[.x] %>%
        stringr::str_remove("\\^")
    ) %>%
    purrr::set_names(sheets)
  # remove sheets not in sheet types list:
  sheets <- sheets[purrr::map_int(sheet_cats, length) > 0]
  sheet_cats <- sheet_cats[purrr::map_int(sheet_cats, length) > 0]
  sheet_cats %>%
    purrr::map_chr(~.x) %>%
    tibble::enframe("sheet", "sheet_type")
}



apply_df_cmd_manip <- function(df_cmd_manip_string, df_cmd) {
  df_cmd <- df_cmd_manip_string %>% rlang::parse_expr() %>% rlang::eval_tidy()
}
generate_rec_na_cmd_table <- function(mapping) {
  # generates a row of a command table with the command to recode missing to -2,
  # labelled "FILTER"
  vars_to_exclude_na_to_filter <- c(
    mapping$mapping_file_attrs$not_miss_to_filter_vars,
    mapping$id_var,
    mapping$mapping_file_attrs$added_id_var
  )
  na_rec_vec <- mapping$mapping_file_attrs$miss_replace_lab_val
  tibble::tibble(
    sheet = "Config",
    action = "#RECNA",
    row = NA_character_,
    new_var = NA_character_,
    data = list(
      list(
        recode_na_exceptions = vars_to_exclude_na_to_filter,
        replace_val = unname(na_rec_vec),
        replace_label = names(na_rec_vec)
      )
    )
  )
}
generate_sheet_cmd_table <- function(mapping_file, sheet_cat, sheet_name) {
  switch (
    sheet_cat,
    "Variables" = mapp_var_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Label"     = mapp_vallab_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Free"      = mapp_free_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Verbatims" = mapp_verbatim_sheet_cmd_tbl(mapping_file, sheet = sheet_name)
  )

}
