#' Compute numeric variable in data frame according to string expression
#'
#' @param x variable; if variable exists and is manipulated in `comp_expr`,
#' then the label attributes are preserved.
#' @param comp_expr expression string
#' @param env environment where `comp_expr` is to be evaluated
#'
#' @return variable calculated according to the expression
#' @export
#'
#' @examples
#' x <- haven::labelled(1:3, labels= c(a = 1), label = "var label")
#' y <- 6:4
#' comp_expr <-  "2 * x - 4 * y"
#' cmd_comp(x, comp_expr)
cmd_comp <- function(x, comp_expr, env = rlang::caller_env()) {
  varlab <- labelled::var_label(x)
  vallabs <- labelled::val_labels(x)

  x <- comp_expr %>%
    rlang::parse_expr() %>%
    # rlang::eval_tidy()
    rlang::eval_tidy(env = env)
  # as.numeric() is needed if new_val is a condition (resulting in a logical
  # vector) which haven::write_sav doesn't accept:
  if (is.logical(x)) {
    x <- as.numeric(x)
  }
  # write back labels if they existed before:
  if (!is.null(varlab) | !is.null(vallabs)) {
    x <- haven::labelled(
      x,
      labels = vallabs,
      label = varlab
    )
  }
  x
}


#' Conditional computing of a variable in a dataframe
#'
#' @param new_var string of the variable name
#' @param condition character string of the condition
#' @param new_val character string the new value expression  when \code{condition}
#' is fulfilled (numeric string values are transformed to numeric)
#'
#' @return variable calculated according to the conditional expression
#' @export
#'
#' @examples
#' x <- 1:3
#' cmd_if(x, "x == 3", "2")
#' # If the condition is not true, the previous values are kept, if existing:
#' cmd_if(data.frame(x = 1:3), "x", "x == 3", "2")
cmd_if <- function(new_var, condition, new_val, env = rlang::caller_env()) {
  var_attrs <- attributes(new_var)

  # manipulated_vars <- get_df_vars_of_expr_string(paste(condition, new_val), names(df)) %>%
  #   c(new_var) %>% unique()
  #
  cond <- rlang::parse_expr(condition)
  val <- rlang::parse_expr(new_val)
  old_val <- new_var

  x <- rlang::expr(ifelse(datenanpassr:::is_true(!!cond), !!val, !!old_val)) %>%
    # rlang::eval_tidy()
    rlang::eval_tidy(env = env)

  # dplyr::mutate(!!rlang::sym(new_var) := ifelse(is_true(!!cond), !!val, !!old_val))
  attributes(x) <- var_attrs
  x
}


#' Split variable into multiple for each of the values of another variable
#'
#' Create a set of variables for each value of split_var. The resulting variables
#' are equal to by_var if split_var is equal to the respective value and NA otherwise.
#'
#' @param split_var variable to split by
#' @param by_var variable to be splitted
#'
#' @return dataframe with the resulting variables (see examples)
#' @export
#'
#' @examples
#' a <- 1:3
#' b <- c(3, 3, 4))
#' cmd_kg(b, a)
cmd_kg <- function(
  split_var,
  by_var
) {
  # capture the argument names passed to the function; see here:
  # https://stackoverflow.com/a/10520832
  # the tilde has to be removed when cmd_kg is called from a function passing double curly operator {{ }}...:
  # this is very hacky! TODO: find cleaner way
  split_var_name <- deparse(substitute(split_var)) %>% stringr::str_remove_all("~")
  by_var_name <- deparse(substitute(by_var)) %>% stringr::str_remove_all("~")
  df <- data.frame(split_var, by_var) %>% purrr::set_names(~c(split_var_name, by_var_name))
  # by_var <- rlang::as_string(rlang::expr(by_var))
  new_vars <- prepare_newvar_table(df, split_var_name, by_var_name)
  new_vars %>%
    purrr::transpose() %>%
    # these 2 lines would do the same
    # rowwise() %>%
    # group_split() %>%
    # add the new variables one by one to the dataframe:
    purrr::reduce(split_cat_by_cat, split_var_name, by_var_name, .init = df) %>%
    dplyr::select(-dplyr::all_of(c(split_var_name, by_var_name)))
}


#' Set variable label of variable orig_var
#'
#' @param orig_var character string of (labelled) variable
#' @param new_label character string of new label
#'
#' @return modified variable `orig_var` (see examples)
#' @export
#'
#' @examples
#' x <- 1
#' cmd_set_lab(x, "I'm the variable label")
cmd_set_lab <- function(orig_var, new_label){
  haven::labelled(
    orig_var,
    labels = attr(orig_var, "labels"),
    label = new_label
  )
}


#' Set value labels of labelled variable var
#'
#' @param orig_var character string of (labelled) variable in df
#' @param new_lab Character string of the new variable label. If not defined, the function will keep the variable label (if it already exists).
#' @param new_vals numeric vector containing the labelled values of the variable
#' @param new_labs character vector of the new value labels
#'
#' @return modified variable `orig_var` (see examples)
#' @export
#'
#' @examples
#' x <- 1:2
#' cmd_set_labs(x, new_vals = 1:2, new_labs = c("label for 1", "label for 2"))
cmd_set_labs <- function(orig_var, new_lab = NULL, new_vals, new_labs){
  if (is.null(new_lab)) {
    new_lab <- attr(orig_var, "label", exact = TRUE)
  }
  haven::labelled(
    orig_var,
    labels = purrr::set_names(new_vals, new_labs),
    label = new_lab
  )
}


#' Add value labels to variable orig_var
#'
#' @param orig_var variable
#' @param new_lab new variable label
#' @param vals_added values added
#' @param labs_added value labels added
#'
#' @return modified variable `orig_var` (see examples)
#' @export
#'
#' @examples
#' x <- haven::labelled(1:2, labels = c("label for 1" = 1), label = "var label")
#' cmd_add_labs(x, vals_added = 2, labs_added = c("label for 2"))
cmd_add_labs <- function(orig_var, new_lab = NULL, vals_added, labs_added){
  old_vallab_vec <- attr(orig_var, "labels")
  added_vallab_vec <- purrr::set_names(vals_added, labs_added)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)

  if(is.null(new_lab))
    varlab <-  attr(orig_var, "label", exact = TRUE)
  else
    varlab <- new_lab

  haven::labelled(
    orig_var,
    labels = new_vallab_vec,
    label = varlab
  )
}


#' Copy variable and value labels of a labelled variable orig_var to new_var
#'
#' @param orig_var character string of (labelled) variable in df
#' @param new_var character string of (labelled) variable in df
#'
#' @return modified variable `new_var` (see examples)
#' @export
#'
#' @examples
#' x <- haven::labelled(1:2, "label" = "varlab1", labels = c(vallab1 = 1))
#' y <- 2:1
#' cmd_dic(x, y)
cmd_dic <- function(orig_var, new_var){
  varlab <- attr(orig_var, "label", exact = TRUE)
  vallabs <- attr(orig_var, "labels", exact = TRUE)
  haven::labelled(
    new_var,
    labels = vallabs,
    label = varlab
  )
}


#' Autorecode character variable
#'
#' @param var character variable to auto-recode
#'
#' @return modified variable `var` (see examples)
#' @export
#'
#' @examples
#' x <- haven::labelled(LETTERS[3:1], label = "variable label")
#' cmd_autorec(x)
cmd_autorec <- function(var) {
  x_labelled <- labelled::to_labelled(as.factor(var))
  labelled::var_label(x_labelled) <- attr(var, "label", exact = TRUE)

  x_labelled
}


#' Create new recoded labelled variable from variable
#'
#' @param orig_var original variable to be recoded
#' @param new_lab string of variable label
#' @param orig_vals numeric vector of the values of the original variable to be recoded
#' @param new_vals numeric vector of labelled values of new recoded variable
#' @param new_labs character vector of value labels of new recoded variable
#'
#' @return recoded variable (see examples)
#' @export
#'
#' @examples
#' orig_var <- 1:5
#' new_vals <- new_vals <- c(1, 1, 2, 3, 3)
#' new_labs <- c("1 - 2", "3", "4 - 5")
#' new_lab <- "new variable label"
#' orig_vals <- 1:5
#' new_labs <- c("1-2 summ", NA, "3 summ.", "4-5 summ", NA)
#' cmd_sumvar(orig_var, new_lab, orig_vals, new_vals, new_labs)
cmd_sumvar <- function(orig_var, new_lab = NULL, orig_vals, new_vals, new_labs, env = rlang::caller_env()) {
  sum_var_vals_n_labs <- tibble::tibble(orig_vals, new_vals, new_labs) %>%
    dplyr::group_by(new_vals) %>%
    dplyr::summarise(val_lists = list(orig_vals),
                     val_labs = dplyr::first(new_labs))
  cond_statements <- purrr::map2(
    sum_var_vals_n_labs$val_lists,
    sum_var_vals_n_labs$new_vals,
    ~ rlang::quo(orig_var %in% !!.x ~ !!.y)
  )



  x <- rlang::expr(dplyr::case_when(!!!cond_statements)) %>% rlang::eval_tidy(env = env)
  haven::labelled(
    x,
    labels = sum_var_vals_n_labs[-2] %>% dplyr::select(2, 1) %>% tibble::deframe(),
    label = new_lab
  )
}


#' Recode variable
#'
#' @param orig_var character string of numeric variable name to recode
#' @param new_lab new variable label
#' @param lb vector of lower bounds of intervals
#' @param ub vector of upper bounds of intervals (missing values are replaced by the corresponding values of \code{ub})
#' @param new_vals labelled values of recoded variable
#' @param new_labs value labels of recoded variable
#'
#' @details
#' The vectors lb, ub, new_vals and new_labs all need to be of the same length.
#'
#' @return Recoded variable (see examples)
#' @export
#'
#' @examples
#' orig_var <- 1:5
#' lb = c(1, 3, 4)
#' ub = c(2, NA, 5)
#' new_vals <- 1:3
#' new_labs <- c("1 - 2", "3", "4 - 5")
#' cmd_rec(
#'   orig_var = "orig_var",
#'   lb = lb,
#'   ub = ub,
#'   new_vals = new_vals,
#'   new_labs = new_labs
#' )
cmd_rec <- function(orig_var, new_lab = NULL, lb, ub, new_vals, new_labs, env = rlang::caller_env()) {
  recode_df <-
    tibble::tibble(lb, ub = dplyr::coalesce(ub, lb), new_vals, new_labs) %>%
    dplyr::mutate(
      expr_str = paste0("(orig_var >= ", lb, " &  orig_var <= ", ub, ")")
    ) %>%
    dplyr::group_by(new_vals) %>%
    dplyr::summarise(
      expr_str = paste(expr_str, collapse = " | "),
      new_labs = new_labs[1]
    )
  cond_statements <-
    recode_df %>%
    dplyr::select(new_vals, expr_str) %>%
    purrr::pmap(
      function(new_vals, expr_str) rlang::quo(!!rlang::parse_expr(expr_str) ~ !!new_vals)
    )


  x <- rlang::expr(dplyr::case_when(!!!cond_statements)) %>% rlang::eval_tidy(env = env)

  haven::labelled(
    x,
    labels = purrr::set_names(recode_df$new_vals, recode_df$new_labs),
    label = new_lab
  )
}


#' Compute variable according to string expression
#'
#' @param new_var string of the variable name
#' @param new_val expression string
#'
#' @return resulting variable (see examples)
#' @export
#'
#' @examples
#' x <- LETTERS[3:1]
#' cmd_compr(x, "x %>% as.factor()")
#' # (When saving factors to an SPSS file by haven::write_sav they will be tranformed
#' # to type haven::labelled)
cmd_compr <- function(new_var, new_val, env = rlang::caller_env()) {
  # transforms numeric values from character to numeric:
  new_val <- rlang::parse_expr(new_val)
  # as.numeric() is needed if new_val is a condition which haven doesn't accept
  rlang::eval_tidy(new_val, env = env)
}


#' Assign a value to a variable at specified ids
#'
#' @param var_ziel name of the variable to modify / be created (character string)
#' @param val_assign assigned value
#' @param varlab variable label (character string)
#' @param vallab value labels (named list)
#' @param id name of the id variable in df (character string)
#' @param id_list list of the id values to be matched
#' @param init_val value assigned to id values not contained in `id_list` if `var_ziel` does not exist in `df` yet
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' cmd_verbatim(
#'   val_assign = 2,
#'   varlab = "variable label",
#'   vallab = c("assigned value" = 2),
#'   id = "id_var",
#'   id_list = c(1, 3, 4)
#' )
cmd_verbatim <- function(var_ziel, val_assign, varlab, vallab, id_var, id_list, init_val = NA_real_) {
  # hack to keep variable label if it already exists:
  if (is.null(varlab)) {
    varlab <- attr(var_ziel, "label", exact = TRUE)
  }
  var_ziel[id_var %in% id_list] <- val_assign
  haven::labelled(
    var_ziel,
    labels = vallab,
    label = varlab
  )
}
