#' Set variable label of variable orig_var in dataframe df
#'
#' @param df dataframe
#' @param orig_var character string of (labelled) variable
#' @param new_label character string of new label
#'
#' @return
#' @export
#'
#' @examples
#' df <- data.frame(x = 1)
#' df <- cmd_set_lab(df, "x", "I'm the variable label")
#' df$x
cmd_set_lab <- function(df, orig_var, new_label){
  df[[orig_var]] <- haven::labelled(
    df[[orig_var]],
    labels = attr(df[[orig_var]], "labels"),
    label = new_label
  )
  df
}

#' Set value labels of labelled variable var in dataframe df
#'
#' @param df dataframe
#' @param orig_var character string of (labelled) variable in df
#' @param new_label character string of new label
#'
#' @return
#' @export
#'
#' @examples
#' df <- data.frame(x = 1:2)
#' df <- cmd_set_labs(df, "x", new_vals = 1:2, new_labs = c("value for 1", "value for 2"))
#' df$x
cmd_set_labs <- function(df, orig_var, new_lab = attr(orig_var, "label", exact = TRUE), new_vals, new_labs){
  df[[orig_var]] <- haven::labelled(
    df[[orig_var]],
    labels = purrr::set_names(new_vals, new_labs),
    label = new_lab
  )
  df
}

#' Add value labels to variable orig_var in dataframe df
#'
#' @param df dataframe
#' @param orig_var variable
#' @param new_lab new variable label
#' @param vals_added values added
#' @param labs_added value labels added
#'
#' @return
#' @export
#'
#' @examples
#' x <- haven::labelled(1:2, labels = c("value for 1" = 1), label = "var label")
#' df <- data.frame(x)
#' df <- cmd_add_labs(df, orig_var = "x", vals_added = 2, labs_added = c("value for 2"))
#' df$x
cmd_add_labs <- function(df, orig_var, new_lab = NULL, vals_added, labs_added){
  labs <- c(attr(df[[orig_var]], "labels") %>% names(), labs_added)
  vals <- c(attr(df[[orig_var]], "labels") %>% unname(), vals_added)
  if(is.null(new_lab))
    varlab <-  attr(df[[orig_var]], "label", exact = TRUE)
  else
    varlab <- new_lab

  df[[orig_var]] <- haven::labelled(
    df[[orig_var]],
    labels = purrr::set_names(vals, labs),
    label = varlab
  )
  df
}


kg_mix <- function(df, var1, var2) {
  var_kg <- paste(var1, var2, sep = "_")
  var_kg_factor <- df %>%
    dplyr::transmute(!!var_kg := forcats::fct_cross(!!rlang::sym(var1) %>% forcats::as_factor(), !!rlang::sym(var2) %>% forcats::as_factor())) %>% dplyr::pull()
  labels_vec <- var_kg_factor %>% levels() %>% purrr::set_names(1:length(.), .)
  var_kg_labelled <- haven::labelled_spss(var_kg_factor, labels = labels_vec)

  df %>%
    dplyr::mutate(!!var_kg := var_kg_labelled)
}

#' Split variable in dataframe into multiple according to the values of another variable
#'
#' Create a set of variables for each value of split_var. The resulting variables
#' are equal to by_var if split_var is equal to the respective value and NA otherwise.
#'
#' @param df data frame
#' @param split_var variable to split by
#' @param by_var variable to be splitted
#'
#' @return
#' @export
#'
#' @examples
#' cmd_kg(data.frame(a = 1:3, b = c(3, 3, 4)), "b", "a")
cmd_kg <- function(df, split_var, by_var) {
  new_vars <- prepare_newvar_table(df, split_var, by_var)
  new_vars %>%
    purrr::transpose() %>%
    # these 2 lines would do the same
    # rowwise() %>%
    # group_split() %>%
    # add the new variables one by one to the dataframe:
    purrr::reduce(split_cat_by_cat, split_var, by_var, .init = df)
}
prepare_newvar_table <- function(df, split_var, by_var) {
  var2lab <- attr(df[[by_var]], "label", exact = TRUE)
  new_varlabs <-
    df %>%
    dplyr::mutate(id = dplyr::row_number(), !!split_var) %>%
    tablab::tab_all() %>%
    dplyr::filter(var == split_var) %>%
    tidyr::drop_na(nv) %>%
    tidyr::unite(new_varlab, varlab, vallab, sep = " - ") %>%
    dplyr::mutate(new_varlab = paste0(new_varlab, ": ", var2lab)) %>%
    dplyr::select(nv, new_varlab)

  new_varnames <- paste0(
    by_var,
    "x",
    split_var,
    "_",
    new_varlabs$nv
  ) %>% stringr::str_replace("-", "minus")
  new_vars <- new_varlabs %>% dplyr::mutate(new_varnames)
  new_vars
}
split_cat_by_cat <- function(df, new_vars, split_var, by_var) {
  new_vec <- df %>% dplyr::transmute(x = ifelse(!!rlang::sym(split_var) == new_vars$nv, !!rlang::sym(by_var), NA)
  ) %>% dplyr::pull()
  vallabs <- df %>%
    dplyr::pull(!!rlang::sym(by_var)) %>%
    attr(., "labels")
  new_vec <- haven::labelled(new_vec, labels = vallabs, label = new_vars$new_varlab)
  df %>% dplyr::mutate(
    !!rlang::sym(new_vars$new_varnames) := new_vec)

}



#' Create new recoded labelled variable from variable in dataframe
#'
#' @param df dataframe
#' @param new_var name of new recoded variable (character string)
#' @param orig_var name of original variable (character string)
#' @param new_lab string of variable label
#' @param orig_vals
#' @param new_vals numeric vector of labelled values of new recoded variable
#' @param new_labs character vector of value labels of new recoded variable
#'
#' @return
#' @export
#'
#' @examples
#' orig_var <- 1:5
#' new_vals <- new_vals <- c(1, 1, 2, 3, 3)
#' new_labs <- c("1 - 2", "3", "4 - 5")
#' new_lab <- "new variable label"
#' orig_vals <- 1:5
#' new_labs <- c("1-2 summ", NA, "3 summ.", "4-5 summ", NA)
#' df <- data.frame(orig_var)
#' df <- cmd_sumvar(df, "new_var", "orig_var", new_lab, orig_vals, new_vals, new_labs)
#' df
#' df$new_var
cmd_sumvar <- function(df, new_var, orig_var, new_lab = NULL, orig_vals, new_vals, new_labs) {
  sum_var_vals_n_labs <- tibble::tibble(orig_vals, new_vals, new_labs) %>%
    dplyr::group_by(new_vals) %>%
    dplyr::summarise(val_lists = list(orig_vals),
                     val_labs = dplyr::first(new_labs))
  cond_statements <- purrr::map2(
    sum_var_vals_n_labs$val_lists,
    sum_var_vals_n_labs$new_vals,
    ~ rlang::quo(!!rlang::sym(orig_var) %in% !!.x ~ !!.y)
  )



  df <- df %>%
    dplyr::mutate(
      !!rlang::sym(new_var) := dplyr::case_when(!!!cond_statements)
    )
  df[new_var] <- haven::labelled(
    df[[new_var]],
    labels = sum_var_vals_n_labs[-2] %>% dplyr::select(2, 1) %>%  tibble::deframe(),
    label = new_lab
  )
  df
}


#' Recode variable
#'
#' @param orig_var numeric variable to recode
#' @param new_lab new variable label
#' @param lb vector of lower bounds of intervals
#' @param ub vector of upper bounds of intervals (missing values are replaced by the corresponding values of \code{ub})
#' @param new_vals labelled values of recoded variable
#' @param new_labs value labels of recoded variable
#'
#' @details
#' The vectors lb, ub, new_vals and new_labs all need to be of the same length.
#'
#' @return
#' @export
#'
#' @examples
#' orig_var <- 1:5
#' df <- data.frame(orig_var)
#' lb = c(1, 3, 4)
#' ub = c(2, NA, 5)
#' new_vals <- 1:3
#' new_labs <- c("1 - 2", "3", "4 - 5")
#' df <- cmd_rec(df, orig_var = "orig_var", new_var = "new_var", lb = lb, ub = ub, new_vals = new_vals, new_labs = new_labs)
#' df
#' df$new_var
cmd_rec <- function(df, orig_var, new_var, new_lab = NULL, lb, ub, new_vals, new_labs) {
  rec_vecs <-
    list(lb, dplyr::coalesce(ub, lb), new_vals)

  cond_statements <-
    purrr::pmap(
      rec_vecs,
      function(x,y,z) rlang::quo(!!rlang::sym(orig_var) >= !!x & !!rlang::sym(orig_var) <= !!y  ~ !!z)
    )

  df <- df %>%
    dplyr::mutate(!!rlang::sym(new_var) := dplyr::case_when(!!!cond_statements))

  df[new_var] <- haven::labelled(
    df[[new_var]],
    labels = purrr::set_names(new_vals, new_labs),
    label = new_lab
  )
  df
}

#' Compute variable in data frame according to string expression
#'
#' @param df dataframe
#' @param new_var string of the variable name
#' @param new_val expression string
#'
#' @return
#' @export
#'
#' @examples
#' cmd_comp(data.frame(x = 1:3), "y", "x * 2")
cmd_comp <- function(df, new_var, new_val) {
  # transforms numeric values from character to numeric:
  new_val <- rlang::parse_expr(new_val)

  df %>% dplyr::mutate(!!rlang::sym(new_var) := !!new_val)
}


#' Conditional computing of a variable in a dataframe
#'
#' @param df dataframe
#' @param new_var string of the variable name
#' @param condition character string of the condition
#' @param new_val character string the new value expression  when \code{condition}
#' is fulfilled (numeric string values are transformed to numeric)
#'
#' @return
#' @export
#'
#' @examples
#' cmd_if(data.frame(x = 1:3), "y", "x == 3", "2")
cmd_if <- function(df, new_var, condition, new_val) {
  cond <- rlang::parse_expr(condition)
  val <- rlang::parse_expr(new_val)

  df %>% dplyr::mutate(!!rlang::sym(new_var) := ifelse(!!cond, !!val, NA_real_))
}

#' Assign a value to a variable in a dataframe at specified ids
#'
#' @param df dataframe
#' @param var_ziel name of the variable to modify / be created (character string)
#' @param val_assign assigned value
#' @param varlab variable label (character string)
#' @param vallab value labels (named list)
#' @param id name of the id variable in df (character string)
#' @param id_list list of the id values to be matched
#'
#' @return modified dataframe
#' @export
#'
#' @examples
#' df <- data.frame(id = 1:5)
#' df <- cmd_verba(
#'   df,
#'   var_ziel = "new_var",
#'   val_assign = 2,
#'   varlab = "variable label",
#'   vallab = c("assigned value" = 2),
#'   id_list = c(1, 3, 4)
#' )
#' df
#' df$new_var
cmd_verba <- function(df, var_ziel, val_assign, varlab, vallab, id = "id", id_list) {
  if (!var_ziel %in% names(df)) {
    df[var_ziel] <- NA_real_
  }
  df[[var_ziel]][df[[id]] %in% id_list] <- val_assign
  y <- haven::labelled(
    df[[var_ziel]],
    labels = vallab,
    label = varlab
  )
  df[[var_ziel]] <- y
  df
}

