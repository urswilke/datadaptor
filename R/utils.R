extract_sev_lists <- function(var) {
  l_sev_parts <-
    var %>%
    stringr::str_squish() %>%
    stringr::str_extract_all("(\\{.+?\\})", simplify = T) %>%
    purrr::map(~stringr::str_remove_all(.x, "[\\{\\}]")) %>%
    stringr::str_squish() %>%
    stringr::str_split(" +", simplify = T) %>%
    tibble::as_tibble(.name_repair = "minimal")

  replace_1curly <- function(orig_str, replacement) stringr::str_replace(orig_str,  "\\{.+?\\}", replacement)
  replace_all_curlies <- function(orig_str, l_1sev_parts) purrr::reduce(l_1sev_parts, replace_1curly, .init = orig_str)
  if (!all(dim(l_sev_parts) == c(0,0))) {
    l_sev_parts %>% purrr::map_chr(~replace_all_curlies(var, .x)) %>% unname()
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
#' severalize(df_free)
severalize <- function(df_f1) {
  df_f1 %>%
    dplyr::filter_all(dplyr::any_vars(!is.na(.))) %>%
    dplyr::mutate_at(2:4, ~purrr::map(.x,~extract_sev_lists(.))) %>%
    tidyr::unnest(cols = c("X2", "X3", "X4")) %>%
    dplyr::mutate(sev_index = dplyr::row_number())
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
