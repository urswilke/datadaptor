#' Replace NA values by `replace_val` labelled by `replace_label`
#'
#' @param x numeric variable
#' @param replace_val numeric value, NAs are replaced by; defaults to -2
#' @param replace_label character value, value label `replace_val` will be
#' labelled by; defaults to "FILTER"
#'
#' @return `x` where NAs are replaced by `replace_val` with added label
#'   `replace_label`
#' @export
#'
#' @examples
#' x <- haven::labelled(c(1, NA), labels = c("value label of 1" = 1))
#' set_na_to_filter(x)
set_na_to_filter <- function(x, replace_val = -2, replace_label = "FILTER") {
  old_vallab_vec <- attr(x, "labels")
  added_vallab_vec <- purrr::set_names(replace_val, replace_label)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)
  x[is.na(x)] <- replace_val
  haven::labelled(
    x,
    labels = new_vallab_vec,
    label = attr(x, "label", exact = TRUE)
  )
}

prepare_newvar_table <- function(df, split_var, by_var) {
  var2lab <- attr(df[[by_var]], "label", exact = TRUE)
  new_varlabs <-
    df |>
    dplyr::select(!!split_var) |>
    # TODO: find cleaner way without defining a dummy id:
    dplyr::mutate(id = dplyr::row_number(), !!split_var) |>
    tablab::tab_all() |>
    tidyr::drop_na("nv") |>
    # tidyr::unite("new_varlab", .data$varlab, .data$vallab, sep = " - ") |>
    dplyr::mutate(new_varlab = paste0(.data$vallab, ": ", var2lab)) |>
    dplyr::select(dplyr::all_of(c("nv", "new_varlab")))

  new_varnames <- paste0(
    by_var,
    "x",
    split_var,
    "k",
    new_varlabs$nv,
    "0"
  ) |> stringr::str_replace("-", "minus")
  new_vars <- new_varlabs |> dplyr::mutate(new_varnames)
  new_vars
}
split_cat_by_cat <- function(df, new_vars, split_var, by_var) {
  vallabs <- attr(df[[by_var]], "labels")

  df[new_vars$new_varnames] <- haven::labelled(
    NA_real_,
    labels = vallabs,
    label = new_vars$new_varlab
  )
  change_indices <- which(df[[split_var]] == new_vars$nv)
  df[[new_vars$new_varnames]][change_indices] <- df[[by_var]][change_indices]
  df
}
