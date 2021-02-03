#' Turn code blocks into multiple by replacing the curly braces by each of the parts inside
#'
#' This function turns the first line of code blocks of the "Free" sheets into
#' multiple by replacing the curly braces
#' by each of the parts inside (separated by spaces). This can help to save yourself
#' from repetitive writing without diving into something like regular expressions.
#'
#' @param df_free code blocks read in by \code{mapp_free1()}
#'
#' @return
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
curliply <- function(df_free) {
  df_free %>%
    dplyr::mutate(raw_index = cumsum(is_true(stringr::str_detect(X1, "^#")))) %>%
    dplyr::group_by(raw_index) %>%
    dplyr::mutate(row = paste(row, collapse = ", ")) %>%
    dplyr::group_split() %>%
    purrr::map_dfr(~collapse_multi_row_blocks(.x, raw_index)) %>%
    dplyr::rowwise() %>%
    dplyr::group_split() %>%
    purrr::map_dfr(curliply_block) %>%
    dplyr::add_count(row) %>%
    dplyr::mutate(curly_index = ifelse(n == 1, NA_integer_, curly_index)) %>%
    dplyr::select(-n) %>%
    dplyr::rowwise() %>%
    dplyr::group_split() %>%
    purrr::map_dfr(explode_multi_row_blocks) %>%
    # when collapsing the multiline statements (using
    # collapse_multi_row_blocks()), the index counting the number of curliply_block
    # items doesn't exist yet. Therefore, it is filled to the whole multiline
    # command blocks with the following fill():
    dplyr::group_by(raw_index) %>%
    tidyr::fill(curly_index) %>%
    tidyr::unite(row, c("row", "curly_index"), na.rm = TRUE)
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
    df %>% dplyr::select(-further_rows),
    df %>% dplyr::pull(further_rows)
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
    dplyr::distinct(value, .keep_all = T) %>%
    dplyr::arrange(value) %>%
    tibble::deframe()
}

# https://github.com/r-lib/vctrs/issues/23
# is FALSE for NA; works for vectors
is_true <- Vectorize(isTRUE)


get_id_var <- function(mapping_file) {
  mapp_configr(mapping_file) %>% dplyr::filter(item == "id_var") %>% dplyr::pull(value)
}

get_lab_before_var <- function(mapping_file) {
  mapp_configr(mapping_file) %>% dplyr::filter(item == "Excecute before variable sheet?") %>% dplyr::pull(value)
}

get_na_to_filter_rec <- function(mapping_file) {
  df_config <- mapp_configr(mapping_file)
  rec_val <- df_config %>%
    dplyr::filter(item == "missing values recoded to") %>%
    dplyr::pull(value) %>%
    as.numeric()
  rec_lab <- df_config %>%
    dplyr::filter(item == "missing values labelled by") %>%
    dplyr::pull(value)
  purrr::set_names(rec_val, rec_lab)
}

get_vars_to_exclude_na_to_filter <- function(mapping_file) {
  mapp_configr(mapping_file) %>%
    dplyr::filter(item == "variables not recoded to FILTER") %>%
    dplyr::pull(value) %>%
    stringr::str_split("[, ;]+") %>%
    unlist()
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
    dplyr::filter(type == "symbol", value %in% vars_in_df) %>%
    dplyr::pull(value)
}

strip_attributes <- function(x) { attributes(x) <- NULL; x }
