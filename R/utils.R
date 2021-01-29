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

#' Turn one line of code into multiple replacing the curly braces by each of the parts
#'
#' This function turns one line of code of an "#IF" or "#COMP" block into
#' multiple replacing the curly braces
#' by each of the parts inside (separated by spaces).
#'
#' @param df_f1 code blocks read in by \code{mapp_free1()}
#'
#' @return
#' @export
#'
#' @examples
#' df_free <- data.frame(X1 = "#IF", X2 = "q{2 3} == 1", X3 = "kq{5 6} = {7 8}")
#' curliply_block(df_free)
curliply_block <- function(df_f1) {
  df_f1 %>%
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
