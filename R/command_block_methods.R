#' Apply a command block to the mapping
#'
#' @param cdb command_block
#'
#' @param self mapping object
#'
#' @export
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' m <- Mapping$new(spss_file, mapping_file)
#' # Construct a command_block of the 10th line in m$cmd$df_cmd_raw:
#' cb <- m$cmd$df_cmd_raw %>%
#'   purrr::transpose() %>%
#'   .[[10]] %>%
#'   command_block() %>%
#'   parse_command_args()
#' # Generate command_blocks object:
#' cbs <- list(cb) %>%
#'   datenanpassr:::new_command_blocks(subclass = "unsafe")
#' # Apply it to the data:
#' m$modify_data(command_blocks = cbs)
#'
#' # The label of the variable in m$dat_mod was modified:
#' m$dat$q5
#' m$dat_mod$q5
apply_command <- function(cdb, self) {
  UseMethod("apply_command")
}
# see https://github.com/r-lib/tidyselect/issues/201#issuecomment-650547846:
utils::globalVariables("where")
#' @export
apply_command.cmd_recna_xcpt <- function(cdb, self) {
  xs <- cdb$args$xs
  v <- cdb$args$v
  vallab <- cdb$args$vallab

  # remove variable names not found in df:
  # TODO: think of cleaner way to do this:
  xs <- intersect(xs, names(self$dat_mod))
  self$dat_mod <- self$dat_mod %>%
    dplyr::mutate(
      dplyr::across(
        where(is.numeric) & !c(dplyr::one_of(xs)),
        ~ set_na_to_filter(.x, v, vallab)
      )
    )
}

#' @export
apply_command.cmd_write_stata <- function(cdb, self) {
  filepath <- cdb$args$filepath
  stata_index <- cdb$args$stata_index
  sheet_name <- cdb$args$sheet_name
  if (is.na(filepath)) {
    filepath <- paste0("stata_output_", sheet_name, "_", stata_index, ".dta")
  }
  xs <- cdb$args$xs
  if (is.na(xs)) {
    xs <- names(self$dat_mod)
  }
  haven::write_dta(self$dat_mod[xs], filepath)
  if (self$params$stata_harakiri) {
    browseURL(filepath)
    browser()
  }
}
#' @export
apply_command.cmd_r <- function(cdb, self) {
  ex <- cdb$args$ex
  new_df <- ex %>%
    rlang::parse_expr() %>%
    eval_in_data(self)
  self$dat_mod <- dplyr::bind_cols(self$dat_mod, new_df)
}

#' @export
apply_command.cmd_rfun <- function(cdb, self) {
  filepath <- cdb$args$filepath
  ex_fun <- cdb$args$ex_fun
  if (!is.na(filepath)) {
    source(filepath, echo = FALSE)
  }

  self$dat_mod <- do.call(ex_fun, list(self$dat_mod))
}

#' @export
apply_command.cmd_kg <- function(cdb, self) {
  split_var_name <- cdb$args$x
  by_var_name <- cdb$args$y

  split_var <- self$dat_mod[[split_var_name]]
  by_var <- self$dat_mod[[by_var_name]]
  df <- data.frame(split_var, by_var) %>% purrr::set_names(~ c(split_var_name, by_var_name))
  # by_var <- rlang::as_string(rlang::expr(by_var))
  new_vars <- prepare_newvar_table(df, split_var_name, by_var_name)
  self$dat_mod[new_vars$new_varnames] <- new_vars %>%
    purrr::transpose() %>%
    # these 2 lines would do the same
    # rowwise() %>%
    # group_split() %>%
    # add the new variables one by one to the dataframe:
    purrr::reduce(split_cat_by_cat, split_var_name, by_var_name, .init = df) %>%
    dplyr::select(-dplyr::all_of(c(split_var_name, by_var_name)))
}

#' @export
apply_command.cmd_drop <- function(cdb, self) {
  xs <- cdb$args$xs
  self$dat_mod[xs] <- NULL
}
#' @export
apply_command.cmd_verbatim <- function(cdb, self) {
  x <- cdb$args$x
  v <- as.numeric(cdb$args$v)
  varlab <- cdb$args$varlab
  vs <- cdb$args$vs
  vallabs_chr <- cdb$args$vallabs
  id <- self$params$id_var
  id_list <- cdb$args$id_list
  v0 <- cdb$args$v0
  ex_further_cond <- cdb$args$ex_further_cond
  vallabs <- purrr::set_names(vs, vallabs_chr)

  if (!x %in% names(self$dat_mod)) {
    self$dat_mod[[x]] <- v0
  }

  # keep variable label if it already exists:
  if (is.null(varlab)) {
    varlab <- attr(self$dat_mod[[x]], "label", exact = TRUE)
  }

  if (!is.na(ex_further_cond)) {
    further_ex_bool <- eval_in_data(rlang::parse_expr(ex_further_cond), self) %>%
      is_true()
  } else {
    further_ex_bool <- TRUE
  }

  self$dat_mod[[x]][self$dat_mod[[id]] %in% id_list & further_ex_bool] <- v
  self$dat_mod[[x]] <- haven::labelled(
    self$dat_mod[[x]],
    labels = vallabs,
    label = varlab
  )
}

#' @export
apply_command.cmd_verbatim_custom <- function(cdb, self) {
  x <- cdb$args$x
  v <- cdb$args$v
  varlab <- cdb$args$varlab
  vs <- cdb$args$vs
  vallabs_chr <- cdb$args$vallabs
  id <- self$params$id_var
  id_list <- cdb$args$id_list
  v0 <- cdb$args$v0
  ex_further_cond <- cdb$args$ex_further_cond
  ex_assign <- cdb$args$ex_assign
  vallabs <- purrr::set_names(vs, vallabs_chr)

  if (!x %in% names(self$dat_mod)) {
    self$dat_mod[[x]] <- v0
  }

  # keep variable label if it already exists:
  if (is.null(varlab)) {
    varlab <- attr(self$dat_mod[[x]], "label", exact = TRUE)
  }

  if (!is.na(ex_further_cond)) {
    further_ex_bool <- eval_in_data(rlang::parse_expr(ex_further_cond), self) %>%
      is_true()
  } else {
    further_ex_bool <- rep(TRUE, nrow(self$dat_mod))
  }

  if (!is.na(ex_assign)) {
    ex_assign_vec <- eval_in_data(rlang::parse_expr(ex_assign), self)
    # don't take the variable label of the verbatim coding...:
    # varlab <- attr(ex_assign_vec, "label", exact = TRUE)
    # ... only keep the existing value labels:
    vallabs <- attr(ex_assign_vec, "labels")
  } else {
    ex_assign_vec <- rep(v, nrow(self$dat_mod))
  }

  id_list_existing <- intersect(id_list, self$dat[[self$params$id_var]])
  if (length(id_list_existing) < length(id_list)) {
    warning("there are id values in the verbatim sheet not in the data")
  }
  ex_row_indices <- match(id_list_existing, self$dat[[self$params$id_var]])
  assign_indices <- intersect(which(further_ex_bool), ex_row_indices)


  self$dat_mod[assign_indices, ][[x]] <- ex_assign_vec[assign_indices]
  self$dat_mod[[x]] <- haven::labelled(
    self$dat_mod[[x]],
    labels = vallabs,
    label = varlab
  )
}

#' @export
apply_command.cmd_merge <- function(cdb, self) {
  xs <- cdb$args$xs
  filepath <- cdb$args$filepath
  id <- self$params$id_var


  # If `xs` isn't specified in Excel sheet, merge all variables in the file:
  if (length(xs) == 1 & is.na(xs[1])) {
    df_merge <- haven::read_sav(filepath)
  } else {
    df_merge <- haven::read_sav(filepath, col_select = !!c(id, xs))
  }
  id_vec <- self$dat_mod[[id]]
  if (!identical(
    sort(tablab::strip_attributes(df_merge[[id]])),
    sort(tablab::strip_attributes(id_vec))
  )
  ) {
    warning("The merged dataframe doesn't contain the same id values")
    df_merge <- df_merge[df_merge[[id]] %in% id_vec,]
  }

  # This kind of merging overwrites variables if existing:
  df_merge_sort <- tibble::tibble(id_vec) %>%
    dplyr::rename(!!id := id_vec) %>%
    dplyr::full_join(df_merge, by = id) %>%
    dplyr::select(-!!id)
  self$dat_mod <- self$dat_mod %>%
    dplyr::mutate(
      df_merge_sort
    )
}

#' @export
apply_command.cmd_rename <- function(cdb, self) {
  xs <- cdb$args$xs
  ys <- cdb$args$ys

  self$dat_mod <- self$dat_mod %>%
    dplyr::rename(!!!purrr::set_names(ys, xs))
}

#' @export
apply_command.cmd_if <- function(cdb, self) {
  x <- cdb$args$x
  ex_cond <- cdb$args$ex_cond
  ex <- cdb$args$ex

  cond <- rlang::parse_expr(ex_cond)
  val <- rlang::parse_expr(ex)

  # add double NA column to data, if x doesn't exist yet (together with
  # the attributes copying below, this keeps the variable's labels if existing):
  if (!x %in% names(self$dat_mod)) {
    self$dat_mod[[x]] <- NA_real_
  }

  test <- eval_in_data(rlang::expr(datenanpassr::is_true(!!cond)), self)
  yes <- eval_in_data(rlang::expr(!!val), self)

  if (self$params$dyn_validate) {
    dyn_validate_cmd_if(test, yes, x, self)
  }

  no <- self$dat_mod[[x]]
  attributes(yes) <- attributes(no)

  self$dat_mod[[x]] <-
    data.table::fifelse(
      test,
      yes,
      no
    )
}
dyn_validate_cmd_if <- function(test, yes, x, self) {
  stopifnot(x %in% names(self$dat_mod))
  vec <- self$dat_mod[[x]]
  stopifnot(is.logical(test))
  stopifnot(typeof(yes) == typeof(vec))
  stopifnot(typeof(yes) %in% c("double", "character"))
}

eval_in_data <- function(ex, self) {
  rlang::eval_tidy(
    ex,
    env = list2env(self$dat_mod, parent = self$params$expr_eval_env)
  )
}

#' @export
#' @importFrom rlang `%||%`
apply_command.cmd_comp <- function(cdb, self) {
  x <- cdb$args$x
  ex <- cdb$args$ex

  val <- rlang::parse_expr(ex)

  # add double NA column to data, if x doesn't exist yet (together with
  # the attributes copying below, this keeps the variable's labels if existing):
  if (!x %in% names(self$dat_mod)) {
    self$dat_mod[[x]] <- NA_real_
  }

  vec <- eval_in_data(rlang::expr(!!val), self)
  varlab <- labelled::var_label(vec) %||% labelled::var_label(self$dat_mod[[x]])
  vallabs <- labelled::val_labels(vec) %||% labelled::val_labels(self$dat_mod[[x]])
  if (is.logical(vec)) {
    vec <- as.integer(vec)
  }
  # attributes(vec) <- attributes(self$dat_mod[[x]])
  if (!is.null(varlab) | !is.null(vallabs)) {
    vec <- haven::labelled(
      vec,
      labels = vallabs,
      label = varlab
    )
  }

  self$dat_mod[[x]] <- vec
}
#' @export
apply_command.cmd_compr <- apply_command.cmd_comp

#' @export
apply_command.cmd_set_lab <- function(cdb, self) {
  x <- cdb$args$x
  varlab <- cdb$args$varlab

  vec <- self$dat_mod[[x]]
  self$dat_mod[[x]] <- haven::labelled(
    vec,
    labels = attr(vec, "labels"),
    label = varlab
  )
}

#' @export
apply_command.cmd_newlab <- apply_command.cmd_set_lab

#' @export
apply_command.cmd_set_labs <- function(cdb, self) {
  x <- cdb$args$x
  varlab <- cdb$args$varlab
  vs <- cdb$args$vs
  vallabs <- cdb$args$vallabs

  if (is.null(varlab)) {
    varlab <- attr(self$dat_mod[[x]], "label", exact = TRUE)
  }
  self$dat_mod[[x]] <- haven::labelled(
    self$dat_mod[[x]],
    labels = purrr::set_names(vs, vallabs),
    label = varlab
  )
}

#' @export
apply_command.cmd_add_labs <- function(cdb, self) {
  x <- cdb$args$x
  varlab <- cdb$args$varlab
  vs <- cdb$args$vs
  vallabs <- cdb$args$vallabs

  vec <- self$dat_mod[[x]]
  old_vallab_vec <- attr(vec, "labels")
  added_vallab_vec <- purrr::set_names(vs, vallabs)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)

  if (is.null(varlab)) {
    varlab <- attr(vec, "label", exact = TRUE)
  } else {
    varlab <- varlab
  }

  self$dat_mod[[x]] <- haven::labelled(
    vec,
    labels = new_vallab_vec,
    label = varlab
  )
  invisible(self)
}

#' @export
apply_command.cmd_newvall <- apply_command.cmd_add_labs

#' @export
apply_command.cmd_rec <- function(cdb, self) {
  y <- cdb$args$y
  varlab <- cdb$args$varlab
  if (is.na(varlab)) {
    varlab <- attr(self$dat_mod[[y]], "label", exact = TRUE)
  }

  x <- cdb$args$x
  if (is.na(x)) {
    x <- y
  }

  lb <- cdb$args$vs0
  vs <- cdb$args$vs
  ub <- cdb$args$vs2
  vallabs <- cdb$args$vallabs
  recode_df <-
    tibble::tibble(lb, ub = dplyr::coalesce(ub, lb), vs, vallabs) %>%
    dplyr::mutate(
      expr_str = paste0("(", y, " >= ", lb, " & ", y, " <= ", ub, ")")
    ) %>%
    dplyr::group_by(vs) %>%
    dplyr::summarise(
      expr_str = paste(.data$expr_str, collapse = " | "),
      vallabs = vallabs[1]
    )
  cond_statements <-
    recode_df %>%
    dplyr::select(vs, .data$expr_str) %>%
    purrr::pmap(
      function(vs, expr_str) rlang::quo(!!rlang::parse_expr(expr_str) ~ !!vs)
    )

  res_num <- rlang::expr(dplyr::case_when(!!!cond_statements)) %>% eval_in_data(self)
  if (x == y) {
    res_num <- dplyr::coalesce(res_num, self$dat_mod[[y]])
  }

  self$dat_mod[[x]] <- haven::labelled(
    res_num,
    labels = purrr::set_names(recode_df$vs, recode_df$vallabs),
    label = varlab
  )
  invisible(self)
}

#' @export
apply_command.cmd_sumvar <- function(cdb, self) {
  x <- cdb$args$x
  y <- cdb$args$y
  varlab <- cdb$args$varlab
  vs0 <- cdb$args$vs0
  vs <- cdb$args$vs
  vallabs <- cdb$args$vallabs
  if (is.na(varlab)) {
    varlab <- attr(self$dat_mod[[y]], "label", exact = TRUE)
  }

  sum_var_vals_n_labs <- tibble::tibble(vs0, vs, vallabs) %>%
    dplyr::group_by(vs) %>%
    dplyr::summarise(
      val_lists = list(vs0),
      val_labs = dplyr::first(vallabs)
    )
  cond_statements <- purrr::map2(
    sum_var_vals_n_labs$val_lists,
    sum_var_vals_n_labs$vs,
    ~ rlang::expr(!!rlang::sym(y) %in% !!.x ~ !!.y)
  )

  vec_num <- rlang::expr(dplyr::case_when(!!!cond_statements)) %>% eval_in_data(self)

  self$dat_mod[[x]] <- haven::labelled(
    vec_num,
    labels = sum_var_vals_n_labs[-2] %>% dplyr::select(2, 1) %>% tibble::deframe(),
    label = varlab
  )

  invisible(self)
}

#' @export
apply_command.cmd_dic <- function(cdb, self) {
  y <- cdb$args$y
  vec <- self$dat_mod[[y]]
  x <- cdb$args$x

  varlab <- attr(vec, "label", exact = TRUE)
  vallabs <- attr(vec, "labels", exact = TRUE)

  if (!x %in% names(self$dat_mod)) {
    self$dat_mod[[x]] <- NA_real_
  }

  self$dat_mod[[x]] <- haven::labelled(
    self$dat_mod[[x]],
    labels = vallabs,
    label = varlab
  )
  invisible(self)
}

#' @export
apply_command.cmd_autorec <- function(cdb, self) {
  x <- cdb$args$x
  vec <- self$dat_mod[[x]]
  x_labelled <- labelled::to_labelled(as.factor(vec))
  labelled::var_label(x_labelled) <- attr(vec, "label", exact = TRUE)

  self$dat_mod[[x]] <- x_labelled
  invisible(self)
}

# #STR2NUM
#' @export
apply_command.cmd_str_to_num <- function(cdb, self) {
  x <- cdb$args$x
  var <- self$dat_mod[[x]]
  self$dat_mod[[x]] <- haven::labelled(
    var %>% tablab::strip_attributes() %>% as.numeric(),
    label = attr(var, "label", exact = TRUE)
  )
  invisible(self)
}
