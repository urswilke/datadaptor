calc_sum_of_k_vars <- function(df) {
  sum_of_k_vars <- dplyr::select(df, dplyr::matches("^k")) %>% rowSums(na.rm = TRUE)
  df %>% dplyr::mutate(sum_of_k_vars)
}
