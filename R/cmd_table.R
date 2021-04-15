#' Create a summary table of the data modifications list read in from the
#' Excel mapping file
#'
#' @param mapping_file filename of the Excel mapping file
#' @param add_r_command_colum logical, whether to add a column `"R command"`
#' @param translate_xlsm logical, whether to translate from Wolf's format
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
  translate_xlsm = FALSE,
  na_to_filter = TRUE,
  vectorized = FALSE
) {
  # The class is set to the file ending:
  mapping_type <- stringr::str_remove(mapping_file, ".*\\.")
  mapping_type <- match.arg(mapping_type, c("xlsx", "xlsm"))

  mapping_file <- new_mapping_file_subclass(
    mapping_file,
    na_to_filter,
    vectorized,
    subclass = mapping_type
  )

  df_cmd <- generate_cmd_table(
    mapping_file,
    na_to_filter = na_to_filter,
    add_r_command_colum = add_r_command_colum,
    vectorized = vectorized
  )
  attr(mapping_file, "df_cmd") <- df_cmd


  mapping_file
}


generate_cmd_table <- function(mapping_file,
                               na_to_filter,
                               add_r_command_colum,
                               vectorized) {
  sheet_cats <- attr(mapping_file, "sheet_cats")
  id_var <- attr(mapping_file, "id_var")
  df_cmd_manip_string <- attr(mapping_file, "mapping_file_attrs")$configr$manipulate_command_table
  df_cmd <- purrr::map2_dfr(
    sheet_cats$sheet %>%
      purrr::set_names(),
    sheet_cats$sheet_type,
    ~ generate_sheet_cmd_table(mapping_file, .y, .x),
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
    df_cmd <- add_rec_na_to_cmd_table(mapping_file, df_cmd, id_var)
  }
  if (add_r_command_colum) {
    cmd_list <- purrr::map2(df_cmd$action, df_cmd$data, ~deparse(generate_cmd_expression(.x, .y)))
    df_cmd["R command"] <-
      tibble::tibble(a = cmd_list) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(a = list(paste(stringr::str_squish(.data$a), collapse = " "))) %>%
      tidyr::unnest(.data$a)
  }

  # attr(df_cmd, "vectorized") = vectorized
  # attr(df_cmd, "id_var") <- id_var
  # attr(df_cmd, "mapping_file") <- mapping_file
  # class(df_cmd) <- c("cmd_table", class(df_cmd))
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
new_mapping_file <- function(
  mapping_file,
  na_to_filter = logical(),
  vectorized = logical(),
  ...,
  class = character()) {
  if (is_mapping_file(mapping_file)) {
    return(mapping_file)
  }

  stopifnot(file.exists(mapping_file))
  stopifnot(is.logical(na_to_filter))
  stopifnot(is.logical(vectorized))

  set_configr_args(mapping_file)
  id_var <- datenanpassr.env$configr$id_var


  sheets <- mapping_file %>% readxl::excel_sheets()

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if (datenanpassr.env$configr$lab_before_var_sheet == "yes" & "Variables" %in% sheets & "Label" %in% sheets) {
    sheets <- switch_sheets_vars_label(sheets)
  }

  sheet_cats <- tab_sheet_types(sheets)


  structure(
    mapping_file,
    id_var = id_var,
    sheet_cats = sheet_cats,
    mapping_file_attrs = datenanpassr.env %>% as.list(),
    na_to_filter = na_to_filter,
    vectorized = vectorized,
    df_cmd = tibble::tibble(),
    ...,
    class = c(class, "mapping_file")
  )
}

is_mapping_file <- function(mapping_file) {
  inherits(mapping_file, "mapping_file")
}

new_mapping_file_subclass <- function(mapping_file, ..., subclass) {
  new_mapping_file(mapping_file, ..., class = subclass)
}


apply_df_cmd_manip <- function(df_cmd_manip_string, df_cmd) {
  df_cmd <- df_cmd_manip_string %>% rlang::parse_expr() %>% rlang::eval_tidy()
}
add_rec_na_to_cmd_table <- function(mapping_file, df_cmd, id_var) {
  vars_to_exclude_na_to_filter <- c(
    datenanpassr.env$configr$not_miss_to_filter_vars,
    id_var,
    datenanpassr.env$configr$added_id_var
  )
  na_rec_vec <- datenanpassr.env$configr$miss_replace_lab_val
  dplyr::bind_rows(
    tibble::tibble(
      sheet = "Config",
      action = "#RECNA",
      row = NA_character_,
      new_var = NA_character_,
      data = list(list(
        recode_na_exceptions = vars_to_exclude_na_to_filter,
        replace_val = unname(na_rec_vec),
        replace_label = names(na_rec_vec)
      ))
    ),
    df_cmd
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

generate_cmd_expression <- function(action, data) {
  # Hack to prevent R CMD CHECK note
  # "no visible binding for global variable ‘df’":
  df <- NULL

  switch (
    action,
    "#RECNA"  = rlang::expr(set_na_to_filter_except(df, !!!data)),
    "#MERGE"  = rlang::expr(cmd_merge_df(df, !!!data)),
    "#RFUN"   = rlang::expr(cmd_rfun(df, !!!data)),
    "#R"      = rlang::expr(cmd_r_df(df, !!!data)),
    "#IF"     = rlang::expr(cmd_if_df(df, !!!data)),
    "#COMP"   = rlang::expr(cmd_comp_df(df, !!!data)),
    # TODO: find cleaner way to deal with this!
    "#COMPR"  = rlang::expr(cmd_compr_df(df, !!!data)),
    "#REC"    = rlang::expr(cmd_rec_df(df, !!!data)),
    "#NEWVALL"= rlang::expr(cmd_add_labs_df(df, !!!data)),
    "#AUTOREC"= rlang::expr(cmd_autorec_df(df, !!!data)),
    "#STR2NUM"= rlang::expr(cmd_str_to_num_df(df, !!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar_df(df, !!!data)),
    "#RENAME" = rlang::expr(cmd_rename(df, !!!data)),
    "#DROP"   = rlang::expr(cmd_drop(df, !!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab_df(df, !!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab_df(df, !!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs_df(df, !!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs_df(df, !!!data)),
    "#DIC"    = rlang::expr(cmd_dic_df(df, !!!data)),
    "#KG"     = rlang::expr(cmd_kg_df(df, !!!data)),
    "#verbatim"  = rlang::expr(cmd_verbatim_df(df, !!!data)),
    stop("Invalid action command")
  )
}
