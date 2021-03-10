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

