#' @export
new_command_block <- function(x, ..., subclass = character()) {
  structure(
    x,
    ...,
    class = c(subclass, "command_block")
  )
}
#' @export
command_block_factory <- function(x) {
  subclass <- switch (x$action,
    "#IF"      = "cmd_if",
    "#COMP"    = "cmd_comp",
    "#VARL"    = "cmd_set_lab",
    "#VALL"    = "cmd_set_labs",
    "#REC"     = "cmd_rec",
    "#SUMVAR"  = "cmd_sumvar",
    "#AVALL"   = "cmd_add_labs",
    "#DIC"     = "cmd_dic",
    "#AUTOREC" = "cmd_autorec",
    "#STR2NUM" = "cmd_str_to_num",
    "#RENAME"  = "cmd_rename",
    "#MERGE"   = "cmd_merge",
    "#RFUN"    = ,
    "#R"       = ,
    "#COMPR"   = ,
    "#NEWVALL" = ,
    "#DROP"    = ,
    "#NEWLAB"  = ,
    "#KG"      = ,
    "#verbatim"= ,
  )
  new_command_block(x, subclass = subclass)
}


#' @export
apply_command <- function(x, self) {
  UseMethod("apply_command")
}
#' @export
parse_command_args <- function(x) {
  UseMethod("parse_command_args")
}
#' @export
parse_command_args.cmd_merge <- function(x) {
  d <- x$data

  x$args <- list(
    variable_names  = d$X4[1] %>% stringr::str_split(" ", simplify = T) %>% as.vector(),
    merge_file  = d$X2,
    id = d$X3[1]
  )
  x
}
#' @export
apply_command.cmd_merge <- function(x, self) {
  variable_names <- x$args$variable_names
  merge_file <- x$args$merge_file
  id <- x$args$id


  id_var_name <- id
  merge_vars <- c(id_var_name, variable_names)
  df_merge <- haven::read_sav(merge_file)
  if (is.na(variable_names)[1]) {
    variable_names <- names(df_merge)
  }
  df_merge <- df_merge %>% dplyr::select(!!id_var_name, !!!variable_names)
  id_var <- rlang::sym(id_var_name) %>% eval_in_data(self)
  if (!identical(
    sort(strip_attributes(df_merge[[id_var_name]])),
    sort(strip_attributes(id_var))
  )
  ) {
    warning("The merged dataframe doesn't contain the same id values")
    df_merge <- df_merge %>% dplyr::filter(!!rlang::sym(id_var_name) %in% id_var)
  }






  self$dat_mod <- self$dat_mod %>%
    dplyr::mutate(
      tibble::tibble(id_var) %>%
        dplyr::rename(!!id_var_name := id_var) %>%
        dplyr::full_join(df_merge, by = id_var_name) %>%
        dplyr::select(-!!id_var_name)
    )


}








#' @export
parse_command_args.cmd_rename <- function(x) {
  d <- x$data

  x$args <- list(
    orig_vars = d$vars[[1]],
    new_names = d$new_names[[1]]
  )
  x
}
#' @export
apply_command.cmd_rename <- function(x, self) {
  orig_vars <- x$args$orig_vars
  new_names <- x$args$new_names

  self$dat_mod <- self$dat_mod %>%
    dplyr::rename(!!!purrr::set_names(orig_vars, new_names))


}







#' @export
parse_command_args.cmd_if <- function(x) {
  assignment <- x$data$X3 %>% stringr::str_split("=") %>% unlist() %>% stringr::str_squish()

  x$args <- list(
    new_var   = assignment[1],
    new_val   = assignment[2],
    condition = x$data$X2
  )
  x
}
#' @export
apply_command.cmd_if <- function(x, self) {
  new_var <- x$args$new_var
  condition <- x$args$condition
  new_val <- x$args$new_val

  cond <- rlang::parse_expr(condition)
  val <- rlang::parse_expr(new_val)

  # add double NA column to data, if new_var doesn't exist yet (together with
  # the attributes copying below, this keeps the variable's labels if existing):
  if (!new_var %in% names(self$dat_mod)) {
    self$dat_mod[[new_var]] <- NA_real_
  }



  test <- eval_in_data(rlang::expr(datenanpassr:::is_true(!!cond)), self)
  yes <- eval_in_data(rlang::expr(!!val), self)
  no <- self$dat_mod[[new_var]]
  attributes(yes) <- attributes(no)

  self$dat_mod[[new_var]] <-
    data.table::fifelse(
      test,
      yes,
      no
    )

}
eval_in_data <- function(e, self) {
  rlang::eval_tidy(
    e,
    env = list2env(self$dat_mod, parent = baseenv())
  )
}


#' @export
parse_command_args.cmd_comp <- function(x) {
  x$args <- list(
    new_var   = x$data$X2[1],
    new_val   = x$data$X3[1]
  )
  x
}

#' @export
apply_command.cmd_comp <- function(x, self) {
  new_var <- x$args$new_var
  new_val <- x$args$new_val

  val <- rlang::parse_expr(new_val)

  # add double NA column to data, if new_var doesn't exist yet (together with
  # the attributes copying below, this keeps the variable's labels if existing):
  if (!new_var %in% names(self$dat_mod)) {
    self$dat_mod[[new_var]] <- NA_real_
  }



  vec <- eval_in_data(rlang::expr(!!val), self)
  attributes(vec) <- attributes(self$dat_mod[[new_var]])

  self$dat_mod[[new_var]] <- vec

}

#' @export
parse_command_args.cmd_set_lab <- function(x) {
  x$args <- list(
    orig_var   = x$data$X2[1],
    new_lab   = x$data$X3[1]
  )
  x
}

#' @export
apply_command.cmd_set_lab <- function(x, self) {
  orig_var <- x$args$orig_var
  new_lab <- x$args$new_lab

  vec <- self$dat_mod[[orig_var]]
  self$dat_mod[[orig_var]] <- haven::labelled(
    vec,
    labels = attr(vec, "labels"),
    label = new_lab
  )

}


#' @export
parse_command_args.cmd_set_labs <- function(x) {

  varlab <- x$data$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }

  x$args <- list(
    orig_var  = x$data$X2[1],
    new_lab  = varlab,
    new_vals = x$data$X2[-1] %>% as.numeric(),
    new_labs = x$data$X3[-1]
  )
  x
}

#' @export
apply_command.cmd_set_labs <- function(x, self) {
  orig_var <- x$args$orig_var
  new_lab <- x$args$new_lab
  new_vals <- x$args$new_vals
  new_labs <- x$args$new_labs

  if (is.null(new_lab)) {
    new_lab <- attr(orig_var, "label", exact = TRUE)
  }
  self$dat_mod[[orig_var]] <- haven::labelled(
    self$dat_mod[[orig_var]],
    labels = purrr::set_names(new_vals, new_labs),
    label = new_lab
  )
}



#' @export
parse_command_args.cmd_add_labs <- function(x) {
  d <- x$data
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  x$args <- list(
    orig_var  = d$X2[1],
    new_lab  = varlab,
    vals_added = d$X2[-1] %>% as.numeric(),
    labs_added = d$X3[-1]
  )
  x
}


#' @export
apply_command.cmd_add_labs <- function(x, self) {
  orig_var <- x$args$orig_var
  new_lab <- x$args$new_lab
  vals_added <- x$args$vals_added
  labs_added <- x$args$labs_added

  vec <- self$dat_mod[[orig_var]]
  old_vallab_vec <- attr(vec, "labels")
  added_vallab_vec <- purrr::set_names(vals_added, labs_added)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)

  if(is.null(new_lab))
    varlab <-  attr(vec, "label", exact = TRUE)
  else
    varlab <- new_lab

  self$dat_mod[[orig_var]] <- haven::labelled(
    vec,
    labels = new_vallab_vec,
    label = varlab
  )
  invisible(self)

}

# #REC
#' @export
parse_command_args.cmd_rec <- function(x) {
  d <- x$data
  x$args <- list(
    # use orig_var if new_var is NA (empty in Excel file):
    orig_var = d$X2[1],
    new_var = d$X3[1],
    new_lab = d$X4[1],
    lb  = d$X2[-1] %>% as.numeric(),
    ub  = d$X3[-1] %>% as.numeric(),
    new_vals = d$X4[-1] %>% as.numeric(),
    new_labs = d$X5[-1]
  )
  x
}


#' @export
apply_command.cmd_rec <- function(x, self) {
  orig_var_name <- x$args$orig_var
  new_lab <- x$args$new_lab
  if (is.null(new_lab)) {
    new_lab <- attr(self$dat_mod[[orig_var]], "label", exact = TRUE)
  }
  new_var <- x$args$new_var

  lb <- x$args$lb
  ub <- x$args$ub
  new_vals <- x$args$new_vals
  new_labs <- x$args$new_labs
  orig_var_name <- x$args$orig_var
  recode_df <-
    tibble::tibble(lb, ub = dplyr::coalesce(ub, lb), new_vals, new_labs) %>%
    dplyr::mutate(
      expr_str = paste0("(", orig_var_name, " >= ", lb, " & ", orig_var_name, " <= ", ub, ")")
    ) %>%
    dplyr::group_by(new_vals) %>%
    dplyr::summarise(
      expr_str = paste(.data$expr_str, collapse = " | "),
      new_labs = new_labs[1]
    )
  cond_statements <-
    recode_df %>%
    dplyr::select(new_vals, .data$expr_str) %>%
    purrr::pmap(
      function(new_vals, expr_str) rlang::quo(!!rlang::parse_expr(expr_str) ~ !!new_vals)
    )


  x <- rlang::expr(dplyr::case_when(!!!cond_statements)) %>% eval_in_data(self)

  self$dat_mod[[new_var]] <- haven::labelled(
    x,
    labels = purrr::set_names(recode_df$new_vals, recode_df$new_labs),
    label = new_lab
  )
  invisible(self)

}


# #SUMMARY VARIABLE
#' @export
parse_command_args.cmd_sumvar <- function(x) {
  d <- x$data

  x$args <- list(
    # use orig_var if new_var is NA (empty in Excel file):
    new_var = paste0("k", d$var[1]),
    orig_var = d$var[1],
    new_lab = d$sum_var_label[1],
    orig_vals  = d$nv %>% as.numeric(),
    new_vals = d$sum_var_value %>% as.numeric(),
    new_labs = d$sum_var_vallab
  )
  x
}


#' @export
apply_command.cmd_sumvar <- function(x, self) {
  new_var <- x$args$new_var
  orig_var <- x$args$orig_var
  new_lab <- x$args$new_lab
  orig_vals <- x$args$orig_vals
  new_vals <- x$args$new_vals
  new_labs <- x$args$new_labs
  if (is.null(new_lab)) {
    new_lab <- attr(self$dat_mod[[orig_var]], "label", exact = TRUE)
  }

  sum_var_vals_n_labs <- tibble::tibble(orig_vals, new_vals, new_labs) %>%
    dplyr::group_by(new_vals) %>%
    dplyr::summarise(val_lists = list(orig_vals),
                     val_labs = dplyr::first(new_labs))
  cond_statements <- purrr::map2(
    sum_var_vals_n_labs$val_lists,
    sum_var_vals_n_labs$new_vals,
    ~ rlang::expr(!!rlang::sym(orig_var) %in% !!.x ~ !!.y)
  )

  x <- rlang::expr(dplyr::case_when(!!!cond_statements)) %>% eval_in_data(self)

  self$dat_mod[[new_var]] <- haven::labelled(
    x,
    labels = sum_var_vals_n_labs[-2] %>% dplyr::select(2, 1) %>% tibble::deframe(),
    label = new_lab
  )

  invisible(self)

}








# #DIC
#' @export
parse_command_args.cmd_dic <- function(x) {
  d <- x$data

  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  x$args <- list(
    orig_var = d$X2[1],
    new_var  = d$X3[1]
  )
  x
}


#' @export
apply_command.cmd_dic <- function(x, self) {
  orig_var <- x$args$orig_var
  vec <- self$dat_mod[[orig_var]]
  new_var <- x$args$new_var

  varlab <- attr(vec, "label", exact = TRUE)
  vallabs <- attr(vec, "labels", exact = TRUE)

  if (!new_var %in% names(self$dat_mod)) {
    self$dat_mod[[new_var]] <- NA_real_
  }


  self$dat_mod[[new_var]] <- haven::labelled(
    self$dat_mod[[new_var]],
    labels = vallabs,
    label = varlab
  )
  invisible(self)

}







# #AUTOREC
#' @export
parse_command_args.cmd_autorec <- function(x) {
  d <- x$data
  x$args <- list(
    var = d$var
  )

  x
}


#' @export
apply_command.cmd_autorec <- function(x, self) {
  var_name <- x$args$var
  vec <- self$dat_mod[[var_name]]
  x_labelled <- labelled::to_labelled(as.factor(vec))
  labelled::var_label(x_labelled) <- attr(vec, "label", exact = TRUE)

  self$dat_mod[[var_name]] <- x_labelled
  invisible(self)
}



# #STR2NUM
#' @export
parse_command_args.cmd_str_to_num <- function(x) {
  d <- x$data
  x$args <- list(
    var = d$var
  )
  x
}


#' @export
apply_command.cmd_str_to_num <- function(x, self) {
  var_name <- x$args$var
  var <- self$dat_mod[[var_name]]
  self$dat_mod[[var_name]] <- haven::labelled(
    var %>% strip_attributes() %>% as.numeric(),
    label = attr(var, "label", exact = TRUE)
  )
  invisible(self)
}













#' #' Split variable into multiple for each of the values of another variable
#' #'
#' #' Create a set of variables for each value of split_var. The resulting variables
#' #' are equal to by_var if split_var is equal to the respective value and NA otherwise.
#' #'
#' #' @param split_var variable to split by
#' #' @param by_var variable to be splitted
#' #'
#' #' @return dataframe with the resulting variables (see examples)
#' #' @export
#' #'
#' #' @examples
#' #' a <- 1:3
#' #' b <- c(3, 3, 4)
#' #' cmd_kg(b, a)
#' cmd_kg <- function(
#'   split_var,
#'   by_var
#' ) {
#'   # capture the argument names passed to the function; see here:
#'   # https://stackoverflow.com/a/10520832
#'   # the tilde has to be removed when cmd_kg is called from a function passing double curly operator {{ }}...:
#'   # this is very hacky! TODO: find cleaner way
#'   split_var_name <- deparse(substitute(split_var)) %>% stringr::str_remove_all("~")
#'   by_var_name <- deparse(substitute(by_var)) %>% stringr::str_remove_all("~")
#'   df <- data.frame(split_var, by_var) %>% purrr::set_names(~c(split_var_name, by_var_name))
#'   # by_var <- rlang::as_string(rlang::expr(by_var))
#'   new_vars <- prepare_newvar_table(df, split_var_name, by_var_name)
#'   new_vars %>%
#'     purrr::transpose() %>%
#'     # these 2 lines would do the same
#'     # rowwise() %>%
#'     # group_split() %>%
#'     # add the new variables one by one to the dataframe:
#'     purrr::reduce(split_cat_by_cat, split_var_name, by_var_name, .init = df) %>%
#'     dplyr::select(-dplyr::all_of(c(split_var_name, by_var_name)))
#' }
#'
#'
#' #' Compute variable according to string expression
#' #'
#' #' @param x variable
#' #' @param comp_expr expression string
#' #' @param env environment where the function is evaluated (should probably not be touched)
#' #'
#' #' @return resulting variable (see examples)
#' #' @export
#' #'
#' #' @examples
#' #' x <- LETTERS[3:1]
#' #' cmd_compr(x, "x %>% as.factor()")
#' #' # (When saving factors to an SPSS file by haven::write_sav they will be tranformed
#' #' # to type haven::labelled)
#' cmd_compr <- function(x, comp_expr, env = rlang::caller_env()) {
#'   # transforms numeric values from character to numeric:
#'   comp_expr_expr <- rlang::parse_expr(comp_expr)
#'   rlang::eval_tidy(comp_expr_expr, env = env)
#' }
#'
#'
#' #' Assign a value to a variable at specified ids
#' #'
#' #' @param var_ziel name of the variable to modify / be created (character string)
#' #' @param val_assign assigned value
#' #' @param varlab variable label (character string)
#' #' @param vallab value labels (named list)
#' #' @param id_var id variable
#' #' @param id_list list of the id values to be matched
#' #' @param init_val value assigned to id values not contained in `id_list` if `var_ziel` does not exist in `df` yet
#' #' @param env environment where the function is evaluated (should probably not be touched)
#' #'
#' #' @return modified dataframe `df` (see examples)
#' #' @export
#' #'
#' #' @examples
#' #' x <- 4:6
#' #' id_var <- 1:3
#' #' cmd_verbatim(
#' #'   x,
#' #'   val_assign = 2,
#' #'   varlab = "variable label",
#' #'   vallab = c("assigned value" = 2),
#' #'   id_var = id_var,
#' #'   id_list = c(1, 3, 4)
#' #' )
#' cmd_verbatim <- function(var_ziel, val_assign, varlab, vallab, id_var, id_list, init_val = NA_real_, env = rlang::caller_env()) {
#'   if (!exists(deparse(substitute(var_ziel)), envir = env)) {
#'     var_ziel <- rep(init_val, length(id_var))
#'   }
#'
#'   # hack to keep variable label if it already exists:
#'   if (is.null(varlab)) {
#'     varlab <- attr(var_ziel, "label", exact = TRUE)
#'   }
#'
#'   var_ziel[id_var %in% id_list] <- val_assign
#'   haven::labelled(
#'     var_ziel,
#'     labels = vallab,
#'     label = varlab
#'   )
#' }
#'
#'
#' #' Merge variables from file to id variable
#' #'
#' #' If the variables in `merge_file` are already present, they will be replaced.
#' #'
#' #' @param merge_file character string of the file to merge from
#' #' @param id_var_name character string of the id variable to merge by
#' #' @param variable_names character vector of variable names to merge from `merge_file`
#' #' @param env environment where the function is evaluated (should probably not be touched)
#' #'
#' #' @return dataframe `df` with the variables defined in `variable_names` added, merged by `id`
#' #' @export
#' #'
#' #' @examples
#' #' variable_names <- c("q1", "q2")
#' #' id_var_name <- "id"
#' #' id <- 1:100 %>% as.numeric()
#' #' merge_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' #' cmd_merge(merge_file, id_var_name, variable_names)
#' cmd_merge <- function(merge_file, id_var_name, variable_names, env = rlang::caller_env()) {
#'   merge_vars <- c(id_var_name, variable_names)
#'   df_merge <- haven::read_sav(merge_file)
#'   if (is.na(variable_names)[1]) {
#'     variable_names <- names(df_merge)
#'   }
#'   df_merge <- df_merge %>% dplyr::select(!!id_var_name, !!!variable_names)
#'   id_var <- rlang::sym(id_var_name) %>% rlang::eval_tidy(env = env)
#'   if (!identical(
#'     sort(strip_attributes(df_merge[[id_var_name]])),
#'     sort(strip_attributes(id_var))
#'     )
#'   ) {
#'     warning("The merged dataframe doesn't contain the same id values")
#'     df_merge <- df_merge %>% dplyr::filter(!!rlang::sym(id_var_name) %in% id_var)
#'   }
#'   tibble::tibble(id_var) %>%
#'     dplyr::rename(!!id_var_name := id_var) %>%
#'     dplyr::full_join(df_merge, by = id_var_name) %>%
#'     dplyr::select(-!!id_var_name)
#' }
#'
#' #' Execute function defined in R script manimullating dataframe df
#' #'
#' #' @param df dataframe
#' #' @param r_script character string of the R script where the function is defined
#' #' @param fun_name character string of the R function name in the script
#' #'
#' #' @return Manipulated dataframe
#' #' @export
#' #'
#' #' @examples
#' #' df <- data.frame(k1 = 1, k2 = 2)
#' #' r_script <- system.file("extdata", "example_R_function.R", package = "datenanpassr")
#' #' fun_name <- "calc_sum_of_k_vars"
#' #' cmd_rfun(df, r_script, fun_name)
#' cmd_rfun <- function(df, r_script, fun_name) {
#'   if (!is.na(r_script)) {
#'     source(r_script, echo = FALSE)
#'   }
#'
#'   df_mod <- do.call(fun_name, list(df))
#'   df_mod
#' }
#'
#' #' Manipulate dataframe by R expression in character string
#' #'
#' #' The current state of the data is stored in a dataframe `df`. It can be
#' #' manipulated by a character string, which is then parsed to an R expression
#' #' and evaluated (see examples).
#' #'
#' #' @param r_code character string of the R code the dataframe is manipulated by
#' #'
#' #' @return object resulting of `r_code` being parsed and evaluated
#' #' @export
#' #'
#' #' @examples
#' #' v1 <- 1:3
#' #' v2 <- 2:0
#' #' r_code <- "3 * v1 - 2 * v2"
#' #' cmd_r(r_code)
#' #' # You can also generate objects based on multiple expressions
#' #' # (separated by semicolons and surrounded by curly braces):
#' #' r_code <- "{v3 = 3 * v1 - 2 * v2; ifelse(v1 == 1, NA, v3)}"
#' #' cmd_r(r_code)
#' #' # In order to generate named variables  in a data.frame(),
#' #' # wrap the output of `r_code` in a data.frame():
#' #' r_code <- "{v3 = 3 * v1 - 2 * v2; v3 = ifelse(v1 == 1, NA, v3); data.frame(v3)}"
#' #' df <- data.frame(v1, v2)
#' #' df %>% dplyr::mutate(cmd_r(r_code))
#' cmd_r <- function(r_code) {
#'   r_code %>% rlang::parse_expr() %>% rlang::eval_tidy()
#' }
#'
#'
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
#' set_na_to_filter_except <- function(df, recode_na_exceptions, replace_val, replace_label) {
#'   # remove variable names not found in df:
#'   # TODO: think of cleaner way to do this:
#'   recode_na_exceptions <- intersect(recode_na_exceptions, names(df))
#'   df %>%
#'     dplyr::mutate(
#'       dplyr::across(
#'         where(is.numeric) & !c(dplyr::one_of(recode_na_exceptions)),
#'         ~set_na_to_filter(.x, replace_val, replace_label)
#'       )
#'     )
#' }
#'
#'
#' #' Replace NA values by `replace_val` labelled by `replace_label`
#' #'
#' #' @param var numeric variable
#' #' @param replace_val numeric value, NAs are replaced by; defaults to -2
#' #' @param replace_label character value, value label `replace_val` will be
#' #' labelled by; defaults to "FILTER"
#' #'
#' #' @return `var` where NAs are replaced by `replace_val` with added label `replace_label`
#' #' @export
#' #'
#' #' @examples
#' #' x <- haven::labelled(c(1, NA), labels = c("value label of 1" = 1))
#' #' set_na_to_filter(x)
#' set_na_to_filter <- function(var, replace_val = -2, replace_label = "FILTER") {
#'   old_vallab_vec <- attr(var, "labels")
#'   added_vallab_vec <- purrr::set_names(replace_val, replace_label)
#'   new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)
#'   var[is.na(var)] <- replace_val
#'   haven::labelled(
#'     var,
#'     labels = new_vallab_vec,
#'     label = attr(var, "label", exact = TRUE)
#'   )
#' }
