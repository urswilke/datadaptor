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
