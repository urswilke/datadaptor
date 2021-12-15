
gen_command_table <- function(
  self,
  na_to_filter = TRUE,
  vectorized = FALSE,
  df_cmd = tibble::tibble(),
  data = tibble::tibble(),
  try_catch = FALSE,
  add_r_command_colum = FALSE,
  rec_fun = purrr::reduce2,
  check_id_is_unique = TRUE,
  mapping_file_attrs = list(),
  class = character()
) {
  stopifnot(is.character(mapping_file))
  stopifnot(is.logical(na_to_filter))
  stopifnot(is.logical(try_catch))
  stopifnot(is.logical(check_id_is_unique))
  stopifnot(is.logical(vectorized))
  stopifnot(is.data.frame(df_cmd))
  stopifnot(is.data.frame(data))
  stopifnot(is.list(mapping_file_attrs))
  rec_fun <- match.fun(rec_fun, c(purrr::reduce2, purrr::accumulate2))


  # TODO: move to step where mapping object is filled (to keep constructor slim)
  l_configr <- get_configr_args_list(self$mapping_file)
  id_var <- l_configr$id_var


  sheets <- self$mapping_file %>% readxl::excel_sheets()

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if (l_configr$lab_before_var_sheet == "yes" & "Variables" %in% sheets & "Label" %in% sheets) {
    sheets <- switch_sheets_vars_label(sheets)
  }

  sheet_cats <- tab_sheet_types(sheets)


  self$params <- list(
    id_var = id_var,
    sheet_cats = sheet_cats,
    mapping_file_attrs = l_configr,
    na_to_filter = na_to_filter,
    vectorized = vectorized,
    try_catch = try_catch,
    add_r_command_colum = add_r_command_colum,
    rec_fun = rec_fun,
    df_cmd = df_cmd,
    data = data
  )


  df_cmd_raw <- purrr::map2_dfr(
    sheet_cats$sheet %>%
      purrr::set_names(),
    sheet_cats$sheet_type,
    ~ generate_sheet_cmd_table(self$mapping_file, .y, .x),
    .id = "sheet"
  )

  self$params$df_cmd_raw <- df_cmd_raw
  df_cmd <- df_cmd_raw

  df_cmd_manip_string <- self$params$mapping_file_attrs$manipulate_command_table
  if (!is.na(df_cmd_manip_string)) {
    df_cmd <- apply_df_cmd_manip(df_cmd_manip_string, df_cmd)
  }
  df_cmd <- df_cmd %>%
    dplyr::rowwise() %>%
    dplyr::mutate(data = parse_cmd_block_args(.data$action, .data$data, vectorized)) %>%
    dplyr::ungroup()
  if (na_to_filter == TRUE) {
    df_cmd <- dplyr::bind_rows(
      generate_rec_na_cmd_table(self),
      df_cmd
    )
  }
  if (add_r_command_colum) {
    cmd_list <- purrr::map2(df_cmd$action, df_cmd$data, ~deparse(generate_cmd_expression(.x, .y)))
    df_cmd["R command"] <-
      tibble::tibble(a = cmd_list) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(a = list(paste(stringr::str_squish(.data$a), collapse = " "))) %>%
      tidyr::unnest(.data$a)
  }

  self$df_cmd <- df_cmd
}


apply_df_cmd_manip <- function(df_cmd_manip_string, df_cmd) {
  df_cmd <- df_cmd_manip_string %>% rlang::parse_expr() %>% rlang::eval_tidy()
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
generate_sheet_cmd_table <- function(mapping_file, sheet_cat, sheet_name) {
  switch (
    sheet_cat,
    "Variables" = mapp_var_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Label"     = mapp_vallab_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Free"      = mapp_free_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Verbatims" = mapp_verbatim_sheet_cmd_tbl(mapping_file, sheet = sheet_name)
  )

}

