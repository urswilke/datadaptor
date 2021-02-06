#' Rename variable variable orig_var in dataframe df
#'
#' @param df dataframe
#' @param orig_vars character vector of variable names in `df`
#' @param new_names character vector of new variable names (has to be of the same length as `origvars`)
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' df <- data.frame(x = 1, y = 2)
#' df <- cmd_rename(df, c("x", "y"), c("x_renamed", "y_renamed"))
#' df
cmd_rename <- function(df, orig_vars, new_names){
  # doesn't work for following functions, if it leads to duplicate names.
  # names(df)[names(df) == orig_var] <- new_name
  df %>% dplyr::rename(!!!purrr::set_names(orig_vars, new_names))
}
#' Set variable label of variable orig_var in dataframe df
#'
#' @param df dataframe
#' @param orig_var character string of (labelled) variable
#' @param new_label character string of new label
#'
#' @return modified dataframe `df` (see examples)
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
#' @param new_lab Character string of the new variable label. If not defined, the function will keep the variable label (if it already exists).
#' @param new_vals numeric vector containing the labelled values of the variable
#' @param new_labs character vector of the new value labels
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' df <- data.frame(x = 1:2)
#' df <- cmd_set_labs(df, "x", new_vals = 1:2, new_labs = c("label for 1", "label for 2"))
#' df$x
cmd_set_labs <- function(df, orig_var, new_lab = attr(df[[orig_var]], "label", exact = TRUE), new_vals, new_labs){
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
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' x <- haven::labelled(1:2, labels = c("label for 1" = 1), label = "var label")
#' df <- data.frame(x)
#' df <- cmd_add_labs(df, orig_var = "x", vals_added = 2, labs_added = c("label for 2"))
#' df$x
cmd_add_labs <- function(df, orig_var, new_lab = NULL, vals_added, labs_added){
  old_vallab_vec <- attr(df[[orig_var]], "labels")
  added_vallab_vec <- purrr::set_names(vals_added, labs_added)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)

  if(is.null(new_lab))
    varlab <-  attr(df[[orig_var]], "label", exact = TRUE)
  else
    varlab <- new_lab

  df[[orig_var]] <- haven::labelled(
    df[[orig_var]],
    labels = new_vallab_vec,
    label = varlab
  )
  df
}

#' Copy variable and value labels of a labelled variable orig_var to new_var in a dataframe df
#'
#' @param df dataframe
#' @param orig_var character string of (labelled) variable in df
#' @param new_var character string of (labelled) variable in df
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' x <- haven::labelled(1:2, "label" = "varlab1", labels = c(vallab1 = 1))
#' df <- data.frame(x, y = NA_real_)
#' df <- cmd_dic(df, orig_var = "x", new_var = "y")
#' df$y
cmd_dic <- function(df, orig_var, new_var){
  varlab <- attr(df[[orig_var]], "label", exact = TRUE)
  vallabs <- attr(df[[orig_var]], "labels", exact = TRUE)
  df[[new_var]] <- haven::labelled(
    df[[new_var]],
    labels = vallabs,
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
#' @return modified dataframe `df` (see examples)
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
    dplyr::select(!!split_var) %>%
    # TODO: find cleaner way without defining a dummy id:
    dplyr::mutate(id = dplyr::row_number(), !!split_var) %>%
    tablab::tab_all() %>%
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
  vallabs <- df[[by_var]] %>%
    attr(., "labels")
  df[new_vars$new_varnames] <- haven::labelled(
    NA_real_,
    labels = vallabs,
    label = new_vars$new_varlab
  )
  change_indices <- which(df[[split_var]] == new_vars$nv)
  df[[new_vars$new_varnames]][change_indices] <- df[[by_var]][change_indices]
  df
}



#' Create new recoded labelled variable from variable in dataframe
#'
#' @param df dataframe
#' @param new_var name of new recoded variable (character string)
#' @param orig_var name of original variable (character string)
#' @param new_lab string of variable label
#' @param orig_vals numeric vector of the values of the original variable to be recoded
#' @param new_vals numeric vector of labelled values of new recoded variable
#' @param new_labs character vector of value labels of new recoded variable
#'
#' @return modified dataframe `df` (see examples)
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
#' @param df dataframe
#' @param orig_var character string of numeric variable name to recode
#' @param new_var character string of the name of the recoded variable
#' @param new_lab new variable label
#' @param lb vector of lower bounds of intervals
#' @param ub vector of upper bounds of intervals (missing values are replaced by the corresponding values of \code{ub})
#' @param new_vals labelled values of recoded variable
#' @param new_labs value labels of recoded variable
#'
#' @details
#' The vectors lb, ub, new_vals and new_labs all need to be of the same length.
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' orig_var <- 1:5
#' df <- data.frame(orig_var)
#' lb = c(1, 3, 4)
#' ub = c(2, NA, 5)
#' new_vals <- 1:3
#' new_labs <- c("1 - 2", "3", "4 - 5")
#' df <- cmd_rec(df,
#'   orig_var = "orig_var",
#'   new_var = "new_var",
#'   lb = lb,
#'   ub = ub,
#'   new_vals = new_vals,
#'   new_labs = new_labs
#' )
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
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' cmd_comp(data.frame(x = 1:3), "y", "x * 2")
cmd_comp <- function(df, new_var, new_val) {
  # transforms numeric values from character to numeric:
  new_val <- rlang::parse_expr(new_val)
  # as.numeric() is needed if new_val is a condition which haven doesn't accept
  df %>% dplyr::mutate(!!rlang::sym(new_var) := !!new_val %>% as.numeric())
}


#' Conditional computing of a variable in a dataframe
#'
#' @param df dataframe
#' @param new_var string of the variable name
#' @param condition character string of the condition
#' @param new_val character string the new value expression  when \code{condition}
#' is fulfilled (numeric string values are transformed to numeric)
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' cmd_if(data.frame(x = 1:3), "y", "x == 3", "2")
#' # If the condition is not true, the previous values are kept, if existing:
#' cmd_if(data.frame(x = 1:3), "x", "x == 3", "2")
cmd_if <- function(df, new_var, condition, new_val) {
  if (!new_var %in% names(df)) {
    df[new_var] <- NA_real_
  }
  var_attrs <- attributes(df[[new_var]])

  manipulated_vars <- get_df_vars_of_expr_string(paste(condition, new_val), names(df)) %>%
    c(new_var) %>% unique()

  cond <- rlang::parse_expr(condition)
  val <- rlang::parse_expr(new_val)
  old_val <- rlang::sym(new_var)

  df[manipulated_vars] <-
    df[manipulated_vars] %>% dplyr::mutate(!!rlang::sym(new_var) := ifelse(is_true(!!cond), !!val, !!old_val))
  attributes(df[[new_var]]) <- var_attrs
  df
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
#' @param init_val value assigned to id values not contained in `id_list` if `var_ziel` does not exist in `df` yet
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' df <- data.frame(id_var = 1:5)
#' df <- cmd_verbatim(
#'   df,
#'   var_ziel = "new_var",
#'   val_assign = 2,
#'   varlab = "variable label",
#'   vallab = c("assigned value" = 2),
#'   id = "id_var",
#'   id_list = c(1, 3, 4)
#' )
#' df
#' df$new_var
cmd_verbatim <- function(df, var_ziel, val_assign, varlab, vallab, id = "id", id_list, init_val = NA_real_) {
  if (!var_ziel %in% names(df)) {
    df[var_ziel] <- init_val
  }
  # hack to keep variable label if it already exists:
  if (is.null(varlab)) {
    varlab <- attr(df[[var_ziel]], "label", exact = TRUE)
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

#' Merge variables from file to dataframe
#'
#' If the variables in `merge_file` are already present, they will be replaced.
#'
#' @param df dataframe to manipulate
#' @param merge_file character string of the file to merge from
#' @param id character string of the id variable to merge by
#' @param variable_names space-separated list of variable names to merge from `merge_file`
#'
#' @return manipulated dataframe `df` with the variables defined in `variable_names` added, merged by `id`
#' @export
#'
#' @examples
#' df <- data.frame(id = 1:100)
#' variable_names <- c("q1", "q2")
#' id <- "id"
#' merge_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' cmd_merge(df, merge_file, id, variable_names)
cmd_merge <- function(df, merge_file, id = "id", variable_names) {
  merge_vars <- c(id, variable_names)
  df_merge <- haven::read_sav(merge_file)
  if (is.na(variable_names)[1]) {
    variable_names <- names(df_merge)
  }
  df_merge <- df_merge %>% dplyr::select(!!id, !!!variable_names)
  if (!identical(
    sort(strip_attributes(df_merge[[id]])),
    sort(strip_attributes(df[[id]])))
  ) {
    warning("The merged dataframe doesn't contain the same id values")
    df_merge <- df_merge %>% dplyr::filter(!!id %in% df$id)
  }
  replaced_vars <- dplyr::intersect(names(df), variable_names) %>% dplyr::setdiff(id)
  df %>%
    dplyr::select(-all_of(replaced_vars)) %>%
    dplyr::full_join(df_merge, by = id) %>%
    dplyr::relocate(names(df))
}

#' Execute function defined in R script manimullating dataframe df
#'
#' @param df dataframe
#' @param r_script character string of the R script where the function is defined
#' @param fun_name character string of the R function name in the script
#'
#' @return Manipulated dataframe
#' @export
#'
#' @examples
#' df <- data.frame(k1 = 1, k2 = 2)
#' r_script <- system.file("extdata", "example_R_function.R", package = "datenanpassr")
#' fun_name <- "calc_sum_of_k_vars"
#' cmd_rfun(df, r_script, fun_name)
cmd_rfun <- function(df, r_script, fun_name) {
  if (!is.na(r_script)) {
    source(r_script, echo = FALSE)
  }

  df_mod <- do.call(fun_name, list(df))
  df_mod
}

#' Manipulate dataframe by R expression in character string
#'
#' The current state of the data is stored in a dataframe `df`. It can be
#' manipulated by a character string, which is then parsed to an R expression
#' and evaluated (see examples).
#'
#' @param df dataframe
#' @param r_code character string of the R code the dataframe is manipulated by
#'
#' @return Manipulated dataframe (the expression string is piped to `df`).
#' @export
#'
#' @examples
#' df <- data.frame(k1 = 1, k2 = 2)
#' r_code <- "df %>% dplyr::mutate(k3 = 3)"
#' cmd_r(df, r_code)
cmd_r <- function(df, r_code) {
  r_code %>% rlang::parse_expr() %>% rlang::eval_tidy()
}


#' Recode missing values of variables in dataframe
#'
#' @param df dataframe
#' @param recode_na_exceptions character vector of variables to exclude from recoding
#' @param replace_val value to replace missing values by
#' @param replace_label value label of replacing value
#'
#' @return
#' @export
#'
#' @examples
set_na_to_filter_except <- function(df, recode_na_exceptions, replace_val, replace_label) {
  df %>%
    dplyr::mutate(
      dplyr::across(
        where(is.numeric) & !c(one_of(recode_na_exceptions)),
        ~set_na_to_filter(.x, replace_val, replace_label)
      )
    )
}
