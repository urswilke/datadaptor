#' Rename variable variable orig_var in dataframe df
#'
#' @param df dataframe
#' @param orig_vars character vector of variable names in `df`
#' @param new_names character vector of new variable names (has to be of the same length as `origvars`)
#' @param change_log logical whether to log changes (using the {tidylog} package); defaults to FALSE.
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' df <- data.frame(x = 1, y = 2)
#' df <- cmd_rename(df, c("x", "y"), c("x_renamed", "y_renamed"))
#' df
cmd_rename <- function(df, orig_vars, new_names, change_log = FALSE){
  if (change_log) {
    rename <- tidylog::rename
  }
  else {
    rename <- dplyr::rename
  }

  # doesn't work for following functions, if it leads to duplicate names.
  # names(df)[names(df) == orig_var] <- new_name
  df %>% rename(!!!purrr::set_names(orig_vars, new_names))
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
#' df <- cmd_set_lab_df(df, "x", "I'm the variable label")
#' df$x
cmd_set_lab_df <- function(df, orig_var, new_label){
  assign("orig_var_obj", df[[orig_var]])
  df %>% dplyr::mutate(!!orig_var := cmd_set_lab(orig_var_obj, new_label))
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
#' df <- cmd_set_labs_df(df, "x", new_vals = 1:2, new_labs = c("label for 1", "label for 2"))
#' df$x
cmd_set_labs_df <- function(df, orig_var, new_lab = NULL, new_vals, new_labs){
  assign("orig_var_obj", df[[orig_var]])
  df %>% dplyr::mutate(!!orig_var := cmd_set_labs(orig_var_obj, new_lab, new_vals, new_labs))
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
#' df <- cmd_add_labs_df(df, orig_var = "x", vals_added = 2, labs_added = c("label for 2"))
#' df$x
cmd_add_labs_df <- function(df, orig_var, new_lab = NULL, vals_added, labs_added){
  assign("orig_var_obj", df[[orig_var]])
  df %>% dplyr::mutate(!!orig_var := cmd_add_labs(orig_var_obj, new_lab, vals_added, labs_added))
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
#' df <- cmd_dic_df(df, orig_var = "x", new_var = "y")
#' df$y
cmd_dic_df <- function(df, orig_var, new_var){
  assign("orig_var_obj", df[[orig_var]])
  assign("new_var_obj", df[[new_var]])
  df %>% dplyr::mutate(!!new_var := cmd_dic(orig_var_obj, new_var_obj))
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
#' cmd_kg_df(data.frame(a = 1:3, b = c(3, 3, 4)), "b", "a")
cmd_kg_df <- function(df, split_var, by_var) {
  # BIG MESS!!! here the two variable names (passed to the function as strings and
  # which live inside df) are transformed to objects:
  assign(split_var, df[[split_var]])
  assign(by_var, df[[by_var]])
  # pass the objects names to cmd_kg. There they will be transformed back to strings...:
  df %>% dplyr::mutate(cmd_kg(!!rlang::sym(split_var), !!rlang::sym(by_var)))
  # TODO: clean up this mess!

}
prepare_newvar_table <- function(df, split_var, by_var) {
  var2lab <- attr(df[[by_var]], "label", exact = TRUE)
  new_varlabs <-
    df %>%
    dplyr::select(!!split_var) %>%
    # TODO: find cleaner way without defining a dummy id:
    dplyr::mutate(id = dplyr::row_number(), !!split_var) %>%
    tablab::tab_all() %>%
    tidyr::drop_na(.data$nv) %>%
    # tidyr::unite("new_varlab", .data$varlab, .data$vallab, sep = " - ") %>%
    dplyr::mutate(new_varlab = paste0(.data$vallab, ": ", var2lab)) %>%
    dplyr::select(.data$nv, .data$new_varlab)

  new_varnames <- paste0(
    by_var,
    "x",
    split_var,
    "k",
    new_varlabs$nv,
    "0"
  ) %>% stringr::str_replace("-", "minus")
  new_vars <- new_varlabs %>% dplyr::mutate(new_varnames)
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



#' Autorecode character variable in dataframe
#'
#' @param df dataframe
#' @param var name of character variable to auto-recode (character string)
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' x <- haven::labelled(LETTERS[3:1], label = "variable label")
#' df <- data.frame(x)
#' df <- cmd_autorec_df(df, "x")
#' df
#' df$x
cmd_autorec_df <- function(df, var) {
  assign("var_obj", df[[var]])
  df %>% dplyr::mutate(!!var := cmd_autorec(var_obj))
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
#' df <- cmd_sumvar_df(df, "new_var", "orig_var", new_lab, orig_vals, new_vals, new_labs)
#' df
#' df$new_var
cmd_sumvar_df <- function(df, new_var, orig_var, new_lab = NULL, orig_vals, new_vals, new_labs) {
  df %>% dplyr::mutate(
    !!new_var := cmd_sumvar(
      !!rlang::sym(orig_var),
      new_lab,
      orig_vals,
      new_vals,
      new_labs
    )
  )
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
#' df <- cmd_rec_df(df,
#'   orig_var = "orig_var",
#'   new_var = "new_var",
#'   lb = lb,
#'   ub = ub,
#'   new_vals = new_vals,
#'   new_labs = new_labs
#' )
#' df
#' df$new_var
cmd_rec_df <- function(df, orig_var, new_var, new_lab = NULL, lb, ub, new_vals, new_labs) {
  df %>% dplyr::mutate(
    !!new_var := cmd_rec(
      !!rlang::sym(orig_var),
      new_lab,
      lb,
      ub,
      new_vals,
      new_labs
    )
  )
}

#' Compute numeric variable in data frame according to string expression
#'
#' @param df dataframe
#' @param new_var string of the variable name
#' @param new_val expression string
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' cmd_comp_df(data.frame(x = 1:3), "y", "x * 2")
#' cmd_comp_df(data.frame(x = haven::labelled(1:3, label = "variable label")), "x", "x * 2")
cmd_comp_df <- function(df, new_var, new_val) {
  if (!new_var %in% names(df)) {
    df[new_var] <- NA_real_
  }
  df %>% dplyr::mutate(!!new_var := cmd_comp(x = !!rlang::sym(new_var), comp_expr = new_val))

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
#' cmd_compr_df(data.frame(x = LETTERS[3:1]), "y", "x %>% as.factor()")
#' # (When saving factors to an SPSS file by haven::write_sav they will be tranformed
#' # to type haven::labelled)
cmd_compr_df <- function(df, new_var, new_val) {
  if (!new_var %in% names(df)) {
    df[new_var] <- NA_real_
  }

  df %>% dplyr::mutate(!!new_var := cmd_compr(new_var, new_val))
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
#' cmd_if_df(data.frame(x = 1:3), "y", "x == 3", "2")
#' # If the condition is not true, the previous values are kept, if existing:
#' cmd_if_df(data.frame(x = 1:3), "x", "x == 3", "2")
cmd_if_df <- function(df, new_var, condition, new_val) {
  if (!new_var %in% names(df)) {
    df[new_var] <- NA_real_
  }

  df %>% dplyr::mutate(!!new_var := cmd_if(!!rlang::sym(new_var), condition, new_val))
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
#' @param init_val value assigned to id values not contained in
#' `id_list` if `var_ziel` does not exist in `df` yet
#'
#' @return modified dataframe `df` (see examples)
#' @export
#'
#' @examples
#' df <- data.frame(id_var = 1:5)
#' df <- cmd_verbatim_df(
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
cmd_verbatim_df <- function(df, var_ziel, val_assign, varlab, vallab, id = "id", id_list, init_val = NA_real_) {
  if (!var_ziel %in% names(df)) {
    df[var_ziel] <- init_val
  }
  var_ziel_obj <- df[[var_ziel]]
  id_var_obj <- df[[id]]
  df %>% dplyr::mutate(!!var_ziel := cmd_verbatim(var_ziel_obj, val_assign, varlab, vallab, id_var_obj, id_list, init_val))
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
#' cmd_merge_df(df, merge_file, id, variable_names)
cmd_merge_df <- function(df, merge_file, id = "id", variable_names) {
  # prevent scoping rules from using a variable called "id" from df instead of
  # the object passed as the function argument:
  id_var_name <- id
  df %>% dplyr::mutate(cmd_merge(merge_file, id_var_name, variable_names))
  # merge_vars <- c(id, variable_names)
  # df_merge <- haven::read_sav(merge_file)
  # if (is.na(variable_names)[1]) {
  #   variable_names <- names(df_merge)
  # }
  # df_merge <- df_merge %>% dplyr::select(!!id, !!!variable_names)
  # if (!identical(
  #   sort(strip_attributes(df_merge[[id]])),
  #   sort(strip_attributes(df[[id]])))
  # ) {
  #   warning("The merged dataframe doesn't contain the same id values")
  #   df_merge <- df_merge %>% dplyr::filter(!!id %in% df$id)
  # }
  # replaced_vars <- dplyr::intersect(names(df), variable_names) %>% dplyr::setdiff(id)
  # df %>%
  #   dplyr::select(-dplyr::all_of(replaced_vars)) %>%
  #   dplyr::full_join(df_merge, by = id) %>%
  #   dplyr::relocate(names(df))
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
#' # To create a new named variable in `df`, wrap the output in a data.frame()
#' r_code <- "data.frame(k3 = 3)"
#' cmd_r_df(df, r_code)
cmd_r_df <- function(df, r_code) {
  df %>% dplyr::mutate(cmd_r(r_code))
}

utils::globalVariables(c("where"))

#' #' Recode missing values of variables in dataframe
#' #'
#' #' @param df dataframe
#' #' @param recode_na_exceptions character vector of variables to exclude from recoding
#' #' @param replace_val value to replace missing values by
#' #' @param replace_label value label of replacing value
#' #'
#' #' @return Dataframe where `set_na_to_filter()` is run on all numeric variables
#' #' (except those in `recode_na_exceptions`)
#' #' `replace_val` and `replace_label` are the arguments passed to `set_na_to_filter()`.
#' #' @export
#' #'
#' #' @examples
#' #' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' #' df <- haven::read_sav(spss_file)
#' #' set_na_to_filter_except(
#' #'   df,
#' #'   c("q1", "q2"),
#' #'   -2,
#' #'   "I'm the label for the missing value replacement"
#' #' )
#' set_na_to_filter_except <- function(df, recode_na_exceptions, replace_val, replace_label, change_log = FALSE) {
#'   # remove variable names not found in df:
#'   # TODO: think of cleaner way to do this:
#'   recode_na_exceptions <- intersect(recode_na_exceptions, names(df))
#'   if (change_log) {
#'     mutate <- tidylog::mutate
#'   }
#'   else {
#'     mutate <- dplyr::mutate
#'   }
#'
#'   df %>%
#'     mutate(
#'       dplyr::across(
#'         where(is.numeric) & !c(dplyr::one_of(recode_na_exceptions)),
#'         ~set_na_to_filter(.x, replace_val, replace_label)
#'       )
#'     )
#' }
