#' Turn code blocks into multiple by replacing the curly braces by each of the parts inside
#'
#' This function turns the first line of code blocks of the "Free" sheets into
#' multiple by replacing the curly braces
#' by each of the parts inside (separated by spaces). This can help to save yourself
#' from repetitive writing without diving into something like regular expressions.
#'
#' @param df_free_raw code blocks read in by \code{mapp_free1()}
#'
#' @return Dataframe containing multiple code blocks. The number of returned code blocks
#'  corresponds to the number of space separated parts in the curly brackets.
#'  The part embraced by the curly braces of the
#'  initial code block is replaced by each of the space separated parts.
#' @export
#'
#' @examples
#' # Minimal example:
#' df_curly <- data.frame(
#'   X1 = "#IF",
#'   X2 = "q{2 3} == 1",
#'   X3 = "kq{5 6} = {7 8}",
#'   X4 = NA_character_,
#'   row = "1"
#' )
#' curliply(df_curly)
#'
#' # Extensive example:
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' df_free_raw <- datenanpassr:::mapp_free_sheet_cmd_table_raw(mapping_file)
#' curliply(df_free_raw)
#' # For reference, open the "Free1" sheet in the Excel file via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
curliply <- function(df_free_raw) {
  l <- df_free_raw %>%
    dplyr::mutate(raw_index = cumsum(is_true(stringr::str_detect(.data$X1, "^#")))) %>%
    dplyr::group_by(.data$raw_index) %>%
    dplyr::mutate(
      row = paste(row, collapse = ", "),
      is_curly_group = dplyr::if_any(.fns = ~stringr::str_detect(.x[1], "\\{")) %>% is_true()
    ) %>%
    dplyr::group_split()
  is_curly_group <- l %>% purrr::map_lgl(~.x$is_curly_group[1])
  if (sum(is_curly_group) > 0) {
    l[is_curly_group] <- l[is_curly_group] %>%
      purrr::map(~collapse_multi_row_blocks(.x, raw_index)) %>%
      purrr::map_dfr(curliply_block) %>%
      dplyr::add_count(row) %>%
      dplyr::mutate(curly_index = ifelse(.data$n == 1, NA_integer_, .data$curly_index)) %>%
      dplyr::select(-.data$n) %>%
      dplyr::group_by(.data$raw_index) %>%
      dplyr::group_split() %>%
      purrr::map(
        function(x) {
          dplyr::rowwise(x) %>%
            dplyr::group_split() %>%
            purrr::map_dfr(explode_multi_row_blocks) %>%
            tidyr::fill(.data$curly_index) %>%
            tidyr::unite(row, c("row", "curly_index"), na.rm = TRUE)
        }
      )
  }
  l %>%
    dplyr::bind_rows() %>%
    dplyr::select(-is_curly_group)
}

extract_curly_lists <- function(var) {
  l_curly_parts <-
    var %>%
    stringr::str_squish() %>%
    stringr::str_extract_all("(\\{.+?\\})", simplify = T) %>%
    purrr::map(~stringr::str_remove_all(.x, "[\\{\\}]")) %>%
    stringr::str_squish() %>%
    stringr::str_split(" +", simplify = T) %>%
    tibble::as_tibble(.name_repair = "minimal")

  replace_1curly <- function(orig_str, replacement) stringr::str_replace(orig_str,  "\\{.+?\\}", replacement)
  replace_all_curlies <- function(orig_str, l_1curly_parts) purrr::reduce(l_1curly_parts, replace_1curly, .init = orig_str)
  if (!all(dim(l_curly_parts) == c(0,0))) {
    l_curly_parts %>% purrr::map_chr(~replace_all_curlies(var, .x)) %>% unname()
  }
  else {
    var
  }
}

curliply_block <- function(df_free) {
  df_free %>%
    dplyr::mutate_at(2:4, ~purrr::map(.x, ~extract_curly_lists(.))) %>%
    tidyr::unnest(cols = c("X2", "X3", "X4")) %>%
    dplyr::mutate(curly_index = dplyr::row_number())
}


collapse_multi_row_blocks <- function(df, raw_index) {
  df %>%
    dplyr::slice(1) %>%
    dplyr::mutate(further_rows = list(df %>% dplyr::slice(-1)))
}
explode_multi_row_blocks <- function(df) {
  dplyr::bind_rows(
    df %>% dplyr::select(-.data$further_rows),
    df %>% dplyr::pull(.data$further_rows)
  )
}



merge_vallabs <- function(old_vallab_vec, added_vallab_vec) {
  if (!is.null(old_vallab_vec)) {
    df_new_labels <- old_vallab_vec %>% tibble::enframe()
  }
  else {
    df_new_labels <- tibble::tibble(name = character(), value = numeric())
  }
  dplyr::full_join(
    added_vallab_vec %>%
      tibble::enframe(),
    df_new_labels,
    by = c("name", "value")
  ) %>%
    dplyr::distinct(.data$value, .keep_all = T) %>%
    dplyr::arrange(.data$value) %>%
    tibble::deframe()
}

# https://github.com/r-lib/vctrs/issues/23
# is FALSE for NA; works for vectors
is_true <- function(x) Vectorize(isTRUE)(x)




get_configr_args_list <- function(mapping_file) {
  df_config <- mapp_configr(mapping_file)
  l_configr <- df_config %>%
    dplyr::mutate(value = as.list(.data$value)) %>%
    dplyr::select(.data$item, .data$value) %>%
    tibble::deframe()

  l_configr$miss_replace_lab_val <- purrr::set_names(
    l_configr$miss_rec_val %>% as.numeric(),
    l_configr$miss_rec_lab
  )
  l_configr[c("miss_rec_val","miss_rec_lab")] <- NULL

  l_configr$not_miss_to_filter_vars <-
    l_configr$not_miss_to_filter_vars %>%
    stringr::str_split("[, ;]+") %>%
    unlist() %>% dplyr::setdiff(NA)

  l_configr
}


# Function to replace windows backslashes to slashes and replace relative
# filepaths by absolutes, based on the directory of the mapping file:
adapt_filepath <- function(file_path, mapping_file) {
  file_path <- file_path %>%
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


get_df_vars_of_expr_string <- function(expr_string, vars_in_df) {
  expr_string %>% sourcetools::tokenize_string() %>%
    dplyr::filter(.data$type == "symbol", .data$value %in% vars_in_df) %>%
    dplyr::pull(.data$value)
}

#' Remove attributes from a vector
#'
#' @param x vector
#'
#' @return x with attributes removed
#' @export
#'
#' @examples
#' x <- haven::labelled(1:3, label = "variable_label")
#' strip_attributes(x)
strip_attributes <- function(x) { attributes(x) <- NULL; x }
