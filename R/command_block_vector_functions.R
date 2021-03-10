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

