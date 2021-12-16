
gen_command_table <- function(self) {
  self$gen_command_table_raw()

  df_cmd <- self$params$df_cmd_raw

  df_cmd_manip_string <- self$params$mapping_file_attrs$manipulate_command_table
  if (!is.na(df_cmd_manip_string)) {
    df_cmd <- apply_df_cmd_manip(df_cmd_manip_string, df_cmd)
  }
  df_cmd <- df_cmd %>%
    dplyr::rowwise() %>%
    dplyr::mutate(data = parse_cmd_block_args(.data$action, .data$data, self$params$vectorized)) %>%
    dplyr::ungroup()
  if (self$params$na_to_filter == TRUE) {
    df_cmd <- dplyr::bind_rows(
      generate_rec_na_cmd_table(self),
      df_cmd
    )
  }
  if (self$params$add_r_command_colum) {
    cmd_list <- purrr::map2(df_cmd$action, df_cmd$data, ~deparse(generate_cmd_expression(.x, .y)))
    df_cmd["R command"] <-
      tibble::tibble(a = cmd_list) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(a = list(paste(stringr::str_squish(.data$a), collapse = " "))) %>%
      tidyr::unnest(.data$a)
  }

  self$df_cmd <- df_cmd
}
gen_command_table_raw_ <- function(self) {
  sheets <- self$mapping_file %>% readxl::excel_sheets()

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if (self$params$mapping_file_attrs$lab_before_var_sheet == "yes" & "Variables" %in% sheets & "Label" %in% sheets) {
    sheets <- switch_sheets_vars_label(sheets)
  }

  sheet_cats <- tab_sheet_types(sheets)

  df_cmd_raw <- purrr::map2_dfr(
    sheet_cats$sheet %>%
      purrr::set_names(),
    sheet_cats$sheet_type,
    ~ generate_sheet_cmd_table(self, .y, .x),
    .id = "sheet"
  )

  self$params$df_cmd_raw <- df_cmd_raw

  invisible(self)
}

generate_rec_na_cmd_table <- function(self) {
  # generates a row of a command table with the command to recode missing to -2,
  # labelled "FILTER"
  vars_to_exclude_na_to_filter <- c(
    self$params$mapping_file_attrs$not_miss_to_filter_vars,
    self$params$id_var,
    self$params$mapping_file_attrs$added_id_var
  )
  na_rec_vec <- self$params$mapping_file_attrs$miss_replace_lab_val
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

generate_sheet_cmd_table <- function(self, sheet_cat, sheet_name) {
  switch (
    sheet_cat,
    "Variables" = mapp_var_sheet_cmd_table(self, sheet = sheet_name),
    "Label"     = mapp_vallab_sheet_cmd_table(self, sheet = sheet_name),
    "Free"      = mapp_free_sheet_cmd_table(self, sheet = sheet_name),
    "Verbatims" = mapp_verbatim_sheet_cmd_tbl(self, sheet = sheet_name)
  )

}


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
