# idx <- 1:10
# l <- list(var = paste0("v", idx + 1), val = rlang::parse_exprs(paste0("v", idx, " + 1")))
# df <- data.frame(v1 = 1:10)
# 2^8
# f <- function(df, var, val) {
#   dplyr::mutate(df, !!var := !!val)
# }
# df_mod <- purrr::reduce2(l$var, l$val, f, .init = df) %>% tibble::as_tibble()
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
df_cmd <- datenanpassr::mapp_cmd_table(mapping_file)
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")


cmd_comp <- function(x, comp_expr, env = rlang::caller_env()) {
  # new_val_e <- rlang::parse_expr(comp_expr)
  # x_e <- rlang::ensym(x)
  varlab <- labelled::var_label(x)
  vallabs <- labelled::val_labels(x)

  # as.numeric() is needed if new_val is a condition (resulting in a logical
  # vector) which haven::write_sav doesn't accept:
  x <- comp_expr %>%
    rlang::parse_expr() %>%
    # rlang::eval_tidy()
    rlang::eval_tidy(env = env)
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
df <- haven::read_sav(spss_file)
df$x <- haven::labelled(NA_real_, labels = c(zero = 0))
df_comp <- df_cmd %>% filter(action == "#COMP")
exprrrss <- paste0(
  "cmd_comp(",
  df_comp$new_var,
  ", '",
  df_comp$data %>% map(pluck, "new_val"),
  "')") %>%
  rlang::parse_exprs()

missing_cols <- names(df) %>% setdiff(df_comp$new_var, .)
df[missing_cols] <- NA_real_
mutate(
  df,
  !!!set_names(
    exprrrss,
    df_comp$new_var
  )
)


# #IF ---------------------------------------------------------------------
cmd_if <- function(new_var, new_val, condition, env = rlang::caller_env()) {
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




df <- haven::read_sav(spss_file)
# df$x <- haven::labelled(NA_real_, labels = c(zero = 0))
df_comp <- df_cmd %>% filter(action == "#IF")
df_comp$data[[2]]$condition <- "q2 == 1"
exprrrss <- paste0(
  "cmd_if(",
  df_comp$new_var,
  ", '",
  df_comp$data %>% map(pluck, "new_val"),
  "', '",
  df_comp$data %>% map(pluck, "condition"),
  "')") %>%
  rlang::parse_exprs()

missing_cols <- names(df) %>% setdiff(df_comp$new_var, .)
df[missing_cols] <- NA_real_
mutate(
  df,
  !!!set_names(
    exprrrss,
    df_comp$new_var
  )
)




# #KG ---------------------------------------------------------------------

#' Split variable in dataframe into multiple according to the values of another variable
#'
#' Create a set of variables for each value of split_var. The resulting variables
#' are equal to by_var if split_var is equal to the respective value and NA otherwise.
#'
#' @param df data frame
#' @param split_var variable to split by
#' @param by_var variable to be splitted
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' cmd_kg(data.frame(a = 1:3, b = c(3, 3, 4)), "b", "a")
cmd_kg <- function(
  split_var,
  by_var
) {
  # capture the argument names passed to the function; see here:
  # https://stackoverflow.com/a/10520832
  # the tilde has to be removed when cmd_kg is called from a function passing double curly operator {{ }}...:
  # this is very hacky! TODO: find cleaner way
  split_var_name <- deparse(substitute(split_var)) %>% str_remove_all("~")
  by_var_name <- deparse(substitute(by_var)) %>% str_remove_all("~")
  df <- data.frame(split_var, by_var) %>% set_names(~c(split_var_name, by_var_name))
  # by_var <- rlang::as_string(rlang::expr(by_var))
  new_vars <- prepare_newvar_table(df, split_var_name, by_var_name)
  new_vars %>%
    purrr::transpose() %>%
    # these 2 lines would do the same
    # rowwise() %>%
    # group_split() %>%
    # add the new variables one by one to the dataframe:
    purrr::reduce(split_cat_by_cat, split_var_name, by_var_name, .init = df) %>%
    select(-all_of(c(split_var_name, by_var_name)))
}
prepare_newvar_table <- function(df, split_var_name, by_var_name) {
  var2lab <- attr(df[[by_var_name]], "label", exact = TRUE)
  new_varlabs <-
    df %>%
    dplyr::select(!!split_var_name) %>%
    # TODO: find cleaner way without defining a dummy id:
    dplyr::mutate(id = dplyr::row_number(), !!split_var_name) %>%
    tablab::tab_all() %>%
    tidyr::drop_na(.data$nv) %>%
    # tidyr::unite("new_varlab", .data$varlab, .data$vallab, sep = " - ") %>%
    dplyr::mutate(new_varlab = paste0(.data$vallab, ": ", var2lab)) %>%
    dplyr::select(.data$nv, .data$new_varlab)

  new_varnames <- paste0(
    by_var_name,
    "x",
    split_var_name,
    "k",
    new_varlabs$nv,
    "0"
  ) %>% stringr::str_replace("-", "minus")
  new_vars <- new_varlabs %>% dplyr::mutate(new_varnames)
  new_vars
}
split_cat_by_cat <- function(df, new_vars, split_var_name, by_var_name) {
  vallabs <- attr(df[[by_var_name]], "labels")

  df[new_vars$new_varnames] <- haven::labelled(
    NA_real_,
    labels = vallabs,
    label = new_vars$new_varlab
  )
  change_indices <- which(df[[split_var_name]] == new_vars$nv)
  df[[new_vars$new_varnames]][change_indices] <- df[[by_var_name]][change_indices]
  df
}



df <- haven::read_sav(spss_file)
# df$x <- haven::labelled(NA_real_, labels = c(zero = 0))
df_comp <- df_cmd %>% filter(action == "#KG")
df_comp$data[[1]]$split_var <- "q2"
df_comp$data[[1]]$by_var <- "q1"
exprrrss <- paste0(
  "cmd_kg(",
  df_comp$data %>% map(pluck, "split_var"),
  ", ",
  df_comp$data %>% map(pluck, "by_var"),
  # ", '",
  # df_comp$data %>% map(pluck, "split_var"),
  # "', '",
  # df_comp$data %>% map(pluck, "by_var"),
  # "'",
  ")") %>%
  rlang::parse_exprs()

mutate(
  df,
  !!!exprrrss
)
