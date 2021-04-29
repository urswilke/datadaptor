#' Create a summary table of the data modifications list read in from the
#' Excel mapping file
#'
#' @param mapping_file filename of the Excel mapping file
#' @param add_r_command_colum logical, whether to add a column `"R command"`
#' specifying the corresponding R command; defaults to FALSE
#' @param na_to_filter logical specifying whether a command is added whether
#' `set_na_to_filter_except()` should be run as the very first command.
#' @param vectorized logical whether groups of command blocks to calculate
#' new vectors are applied to the data in a single `dplyr::mutate()`
#' statement or whether to consecutively apply (by using `purrr::reduce()`)
#' each command expression on the whole data frame. Probably something similar as the difference between:
#' dataframe() %>% mutate(a = 1) %>% mutate(b = 2) or
#' dataframe() %>% mutate(a = 1, b = 2).
#' The second is faster. For many data operations or large datasets,
#' vectorized = TRUE should also be faster
#'
#' @return Command table containing the data of the command blocks of the Excel mapping file.
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_cmd_table(mapping_file)
#' # Add column for R command:
#' mapp_cmd_table(mapping_file, add_r_command_colum = TRUE)
mapp_cmd_table <- function(
  mapping_file,
  add_r_command_colum = FALSE,
  na_to_filter = TRUE,
  vectorized = FALSE,
  ...
) {

  mapping <- new_mapping(
    mapping_file,
    na_to_filter = na_to_filter,
    add_r_command_colum = add_r_command_colum,
    vectorized = vectorized
  )

  mapping$df_cmd <- generate_cmd_table(mapping)

  mapping
}


generate_cmd_table <- function(mapping) {
  na_to_filter <- mapping$na_to_filter
  add_r_command_colum <- mapping$add_r_command_colum
  vectorized <- mapping$vectorized
  sheet_cats <- mapping$sheet_cats
  id_var <- mapping$id_var
  df_cmd_manip_string <- mapping$mapping_file_attrs$manipulate_command_table
  df_cmd <- purrr::map2_dfr(
    sheet_cats$sheet %>%
      purrr::set_names(),
    sheet_cats$sheet_type,
    ~ generate_sheet_cmd_table(mapping$mapping_file, .y, .x),
    .id = "sheet"
  )
  if (!is.na(df_cmd_manip_string)) {
    df_cmd <- apply_df_cmd_manip(df_cmd_manip_string, df_cmd)
  }
  df_cmd <- df_cmd %>%
    dplyr::rowwise() %>%
    dplyr::mutate(data = parse_cmd_block_args(.data$action, .data$data, vectorized)) %>%
    dplyr::ungroup()
  if (na_to_filter == TRUE) {
    df_cmd <- dplyr::bind_rows(
      generate_rec_na_cmd_table(mapping),
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

  df_cmd
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
new_mapping <- function(
  mapping_file,
  na_to_filter = logical(),
  vectorized = logical(),
  df_cmd = tibble::tibble(),
  data = tibble::tibble(),
  try_catch = logical(),
  add_r_command_colum = logical(),
  rec_fun = purrr::reduce2,
  check_id_is_unique = logical(),
  mapping_file_attrs = list(),
  ...,
  class = character()) {

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
  l_configr <- get_configr_args_list(mapping_file)
  id_var <- l_configr$id_var


  sheets <- mapping_file %>% readxl::excel_sheets()

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if (l_configr$lab_before_var_sheet == "yes" & "Variables" %in% sheets & "Label" %in% sheets) {
    sheets <- switch_sheets_vars_label(sheets)
  }

  sheet_cats <- tab_sheet_types(sheets)


  structure(
    list(
      mapping_file = new_mapping_file(mapping_file, id_var),
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
    ),
    class = c("mapping", "list")
  )
}

new_mapping_file <- function(mapping_file, id_var) {
  mapping_type <- stringr::str_remove(mapping_file, ".*\\.")
  structure(
    mapping_file,
    id_var = id_var,
    class = c(mapping_type, class(mapping_file))
  )
}

is_mapping <- function(mapping_file) {
  inherits(mapping_file, "mapping")
}

as_mapping <- function(mapping, ...) {
  UseMethod("as_mapping")
}
as_mapping.default <- function(mapping, ...) {
  stop("Methods only defined for objects of type mapping or character.")
}
as_mapping.mapping <- function(mapping, ...) {
  mapping
}
as_mapping.character <- function(mapping, ...) {
  new_mapping(mapping)
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
