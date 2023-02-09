#' Replace NA values by `miss_rec_val` labelled by `miss_rec_lab`
#'
#' @param x numeric variable
#' @param miss_rec_val numeric value, NAs are replaced by; defaults to -2
#' @param miss_rec_lab character value, value label `miss_rec_val` will be
#' labelled by; defaults to "FILTER"
#'
#' @return `x` where NAs are replaced by `miss_rec_val` with added label
#'   `miss_rec_lab`
#' @export
#' @keywords internal
#'
#' @examples
#' x <- haven::labelled(c(1, NA), labels = c("value label of 1" = 1))
#' x
#' set_na_to_filter(x)
set_na_to_filter <- function(x, miss_rec_val = -2, miss_rec_lab = "FILTER") {
  old_vallab_vec <- attr(x, "labels")
  added_vallab_vec <- set_names(miss_rec_val, miss_rec_lab)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)
  x[is.na(x)] <- miss_rec_val
  labelled(
    x,
    labels = new_vallab_vec,
    label = attr(x, "label", exact = TRUE)
  )
}

prepare_newvar_table <- function(df, split_var, by_var) {
  var2lab <- attr(df[[by_var]], "label", exact = TRUE)

  df_counts <- df |>
    select(!!split_var) |>
    tab_counts(values_drop_na = TRUE)
  df_vallabs <- df |>
    select(!!split_var) |>
    tab_vallabs()
  new_varlabs <-
    df_counts |>
    full_join(df_vallabs, by = c("var", "double" = "nv")) |>
    mutate(new_varlab = paste0(.data$vallab, ": ", var2lab)) |>
    select(c("nv" = "double", "new_varlab"))

  new_varnames <- paste0(
    by_var,
    "x",
    split_var,
    "k",
    new_varlabs$nv,
    "0"
  ) |> str_replace("-", "minus")
  new_vars <- new_varlabs |> mutate(new_varnames)
  new_vars
}
split_cat_by_cat <- function(df, new_vars, split_var, by_var) {
  vallabs <- attr(df[[by_var]], "labels")

  df[new_vars$new_varnames] <- labelled(
    NA_real_,
    labels = vallabs,
    label = new_vars$new_varlab
  )
  change_indices <- which(df[[split_var]] == new_vars$nv)
  df[[new_vars$new_varnames]][change_indices] <- df[[by_var]][change_indices]
  df
}
