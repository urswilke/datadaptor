#' Constructor of mapping objects
#'
#' @param mapping filename of the Excel mapping file
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
#' @param df_cmd Table of commands (generated with `mapp_cmd_table()`); defaults to NULL.
#' @param data Dataset that is modified with the commands of `df_cmd`; defaults to NULL.
#' @param try_catch logical; if TRUE, command blocks of the mapping file
#'   that error out will be skipped; possible errors are attached to the
#'   dataframe as a character vector of length of all the commands in the
#'   command table; in combination with `rec_fun` = `purrr::accumulate2` this
#'   can be used to examine intermediate results, in order to find the reason
#'   for the error. Alternatively, run the script created by
#'   `translate_to_r_script()`.
#' @param rec_fun function either purrr::reduce2 or purrr::accumulate2; see
#'   Value section
#' @param check_id_is_unique logical whether to check that the specified id
#'   variable (in sheet "configr") is unique; defaults to TRUE.
#' @param vectorized logical whether groups of command blocks to calculate
#' new vectors are applied to the data in a single `dplyr::mutate()`
#' statement or whether to consecutively apply (by using `purrr::reduce()`)
#' each command expression on the whole data frame. Probably something similar as the difference between:
#' dataframe() %>% mutate(a = 1) %>% mutate(b = 2) or
#' dataframe() %>% mutate(a = 1, b = 2).
#' The second is faster. For many data operations or large datasets,
#' vectorized = TRUE should also be faster
#' @param mapping_file_attrs Parameter list that is read in from the "configr" sheet in `mapping_file`.
#' @param ... Parameters passed to subclass constructors.
#' @param class Class attribute to create a subclass.
#'
#' @return A list object of type mapping.
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' new_mapping(mapping_file)
new_mapping <- function(
  mapping,
  na_to_filter = TRUE,
  vectorized = FALSE,
  df_cmd = NULL,
  data = NULL,
  try_catch = FALSE,
  add_r_command_colum = FALSE,
  rec_fun = purrr::reduce2,
  check_id_is_unique = TRUE,
  mapping_file_attrs = list(),
  ...,
  class = character()) {

  stopifnot(is.character(mapping))
  stopifnot(is.logical(na_to_filter))
  stopifnot(is.logical(try_catch))
  stopifnot(is.logical(check_id_is_unique))
  stopifnot(is.logical(vectorized))
  stopifnot(is.null(df_cmd) | is.data.frame(df_cmd))
  stopifnot(is.null(data)   | is.data.frame(data))
  stopifnot(is.list(mapping_file_attrs))
  rec_fun <- match.fun(rec_fun, c(purrr::reduce2, purrr::accumulate2))


  # TODO: move to step where mapping object is filled (to keep constructor slim)
  l_configr <- get_configr_args_list(mapping)
  id_var <- l_configr$id_var


  sheets <- mapping %>% readxl::excel_sheets()

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if (l_configr$lab_before_var_sheet == "yes" & "Variables" %in% sheets & "Label" %in% sheets) {
    sheets <- switch_sheets_vars_label(sheets)
  }

  sheet_cats <- tab_sheet_types(sheets)


  structure(
    list(
      mapping_file = new_mapping_file(mapping, id_var),
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


is_mapping <- function(mapping_file) {
  inherits(mapping_file, "mapping")
}

#' @rdname new_mapping
#' @export
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
  new_mapping(mapping, ...)
}




