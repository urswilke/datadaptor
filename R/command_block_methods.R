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
  recode_na_exceptions <- cdb$args$recode_na_exceptions
  replace_val <- cdb$args$replace_val
  replace_label <- cdb$args$replace_label

  # remove variable names not found in df:
  # TODO: think of cleaner way to do this:
  recode_na_exceptions <- intersect(recode_na_exceptions, names(self$dat_mod))
  self$dat_mod <- self$dat_mod %>%
    dplyr::mutate(
      dplyr::across(
        where(is.numeric) & !c(dplyr::one_of(recode_na_exceptions)),
        ~ set_na_to_filter(.x, replace_val, replace_label)
      )
    )
}

#' @export
apply_command.cmd_r <- function(cdb, self) {
  r_code <- cdb$args$r_code
  new_df <- r_code %>%
    rlang::parse_expr() %>%
    eval_in_data(self)
  self$dat_mod <- dplyr::bind_cols(self$dat_mod, new_df)
}

#' @export
apply_command.cmd_rfun <- function(cdb, self) {
  r_script <- cdb$args$r_script
  fun_name <- cdb$args$fun_name
  if (!is.na(r_script)) {
    source(r_script, echo = FALSE)
  }

  self$dat_mod <- do.call(fun_name, list(self$dat_mod))
}

#' @export
apply_command.cmd_kg <- function(cdb, self) {
  split_var_name <- cdb$args$split_var
  by_var_name <- cdb$args$by_var

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
  orig_vars <- cdb$args$orig_vars
  self$dat_mod[orig_vars] <- NULL
}

#' @export
apply_command.cmd_verbatim <- function(cdb, self) {
  var_ziel <- cdb$args$var_ziel
  val_assign <- cdb$args$val_assign
  varlab <- cdb$args$varlab
  vallab <- cdb$args$vallab
  id <- self$params$id_var
  id_list <- cdb$args$id_list
  init_val <- cdb$args$init_val

  if (!var_ziel %in% names(self$dat_mod)) {
    self$dat_mod[[var_ziel]] <- init_val
  }

  # hack to keep variable label if it already exists:
  if (is.null(varlab)) {
    varlab <- attr(var_ziel, "label", exact = TRUE)
  }

  self$dat_mod[[var_ziel]][self$dat_mod[[id]] %in% id_list] <- val_assign
  self$dat_mod[[var_ziel]] <- haven::labelled(
    self$dat_mod[[var_ziel]],
    labels = vallab,
    label = varlab
  )
}

#' @export
apply_command.cmd_merge <- function(cdb, self) {
  variable_names <- cdb$args$variable_names
  merge_file <- cdb$args$merge_file
  id <- cdb$args$id

  merge_vars <- c(id, variable_names)
  df_merge <- haven::read_sav(merge_file)
  if (is.na(variable_names)[1]) {
    variable_names <- names(df_merge)
  }
  df_merge <- df_merge %>% dplyr::select(!!id, !!!variable_names)
  id_vec <- self$dat_mod[[id]]
  if (!identical(
    sort(tablab::strip_attributes(df_merge[[id]])),
    sort(tablab::strip_attributes(id_vec))
  )
  ) {
    warning("The merged dataframe doesn't contain the same id values")
    df_merge <- df_merge %% dplyr::filter(!!rlang::sym(id) %in% id_vec)
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
  orig_vars <- cdb$args$orig_vars
  new_names <- cdb$args$new_names

  self$dat_mod <- self$dat_mod %>%
    dplyr::rename(!!!purrr::set_names(orig_vars, new_names))
}

#' @export
apply_command.cmd_if <- function(cdb, self) {
  new_var <- cdb$args$new_var
  condition <- cdb$args$condition
  new_val <- cdb$args$new_val

  cond <- rlang::parse_expr(condition)
  val <- rlang::parse_expr(new_val)

  # add double NA column to data, if new_var doesn't exist yet (together with
  # the attributes copying below, this keeps the variable's labels if existing):
  if (!new_var %in% names(self$dat_mod)) {
    self$dat_mod[[new_var]] <- NA_real_
  }

  test <- eval_in_data(rlang::expr(datenanpassr::is_true(!!cond)), self)
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
#' @importFrom rlang `%||%`
apply_command.cmd_comp <- function(cdb, self) {
  new_var <- cdb$args$new_var
  new_val <- cdb$args$new_val

  val <- rlang::parse_expr(new_val)

  # add double NA column to data, if new_var doesn't exist yet (together with
  # the attributes copying below, this keeps the variable's labels if existing):
  if (!new_var %in% names(self$dat_mod)) {
    self$dat_mod[[new_var]] <- NA_real_
  }

  vec <- eval_in_data(rlang::expr(!!val), self)
  varlab <- labelled::var_label(vec) %||% labelled::var_label(self$dat_mod[[new_var]])
  vallabs <- labelled::val_labels(vec) %||% labelled::val_labels(self$dat_mod[[new_var]])
  if (is.logical(vec)) {
    vec <- as.integer(vec)
  }
  # attributes(vec) <- attributes(self$dat_mod[[new_var]])
  if (!is.null(varlab) | !is.null(vallabs)) {
    vec <- haven::labelled(
      vec,
      labels = vallabs,
      label = varlab
    )
  }

  self$dat_mod[[new_var]] <- vec
}
#' @export
apply_command.cmd_compr <- apply_command.cmd_comp

#' @export
apply_command.cmd_set_lab <- function(cdb, self) {
  orig_var <- cdb$args$orig_var
  new_lab <- cdb$args$new_lab

  vec <- self$dat_mod[[orig_var]]
  self$dat_mod[[orig_var]] <- haven::labelled(
    vec,
    labels = attr(vec, "labels"),
    label = new_lab
  )
}

#' @export
apply_command.cmd_newlab <- apply_command.cmd_set_lab

#' @export
apply_command.cmd_set_labs <- function(cdb, self) {
  orig_var <- cdb$args$orig_var
  new_lab <- cdb$args$new_lab
  new_vals <- cdb$args$new_vals
  new_labs <- cdb$args$new_labs

  if (is.null(new_lab)) {
    new_lab <- attr(self$dat_mod[[orig_var]], "label", exact = TRUE)
  }
  self$dat_mod[[orig_var]] <- haven::labelled(
    self$dat_mod[[orig_var]],
    labels = purrr::set_names(new_vals, new_labs),
    label = new_lab
  )
}

#' @export
apply_command.cmd_add_labs <- function(cdb, self) {
  orig_var <- cdb$args$orig_var
  new_lab <- cdb$args$new_lab
  vals_added <- cdb$args$vals_added
  labs_added <- cdb$args$labs_added

  vec <- self$dat_mod[[orig_var]]
  old_vallab_vec <- attr(vec, "labels")
  added_vallab_vec <- purrr::set_names(vals_added, labs_added)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)

  if (is.null(new_lab)) {
    varlab <- attr(vec, "label", exact = TRUE)
  } else {
    varlab <- new_lab
  }

  self$dat_mod[[orig_var]] <- haven::labelled(
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
  orig_var <- cdb$args$orig_var
  new_lab <- cdb$args$new_lab
  if (is.na(new_lab)) {
    new_lab <- attr(self$dat_mod[[orig_var]], "label", exact = TRUE)
  }

  new_var <- cdb$args$new_var
  if (is.na(new_var)) {
    new_var <- orig_var
  }

  lb <- cdb$args$lb
  ub <- cdb$args$ub
  new_vals <- cdb$args$new_vals
  new_labs <- cdb$args$new_labs
  recode_df <-
    tibble::tibble(lb, ub = dplyr::coalesce(ub, lb), new_vals, new_labs) %>%
    dplyr::mutate(
      expr_str = paste0("(", orig_var, " >= ", lb, " & ", orig_var, " <= ", ub, ")")
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

  res_num <- rlang::expr(dplyr::case_when(!!!cond_statements)) %>% eval_in_data(self)
  if(new_var == orig_var) {
    res_num <- dplyr::coalesce(res_num, self$dat_mod[[orig_var]])
  }

  self$dat_mod[[new_var]] <- haven::labelled(
    res_num,
    labels = purrr::set_names(recode_df$new_vals, recode_df$new_labs),
    label = new_lab
  )
  invisible(self)
}

#' @export
apply_command.cmd_sumvar <- function(cdb, self) {
  new_var <- cdb$args$new_var
  orig_var <- cdb$args$orig_var
  new_lab <- cdb$args$new_lab
  orig_vals <- cdb$args$orig_vals
  new_vals <- cdb$args$new_vals
  new_labs <- cdb$args$new_labs
  if (is.null(new_lab)) {
    new_lab <- attr(self$dat_mod[[orig_var]], "label", exact = TRUE)
  }

  sum_var_vals_n_labs <- tibble::tibble(orig_vals, new_vals, new_labs) %>%
    dplyr::group_by(new_vals) %>%
    dplyr::summarise(
      val_lists = list(orig_vals),
      val_labs = dplyr::first(new_labs)
    )
  cond_statements <- purrr::map2(
    sum_var_vals_n_labs$val_lists,
    sum_var_vals_n_labs$new_vals,
    ~ rlang::expr(!!rlang::sym(orig_var) %in% !!.x ~ !!.y)
  )

  vec_num <- rlang::expr(dplyr::case_when(!!!cond_statements)) %>% eval_in_data(self)

  self$dat_mod[[new_var]] <- haven::labelled(
    vec_num,
    labels = sum_var_vals_n_labs[-2] %>% dplyr::select(2, 1) %>% tibble::deframe(),
    label = new_lab
  )

  invisible(self)
}

#' @export
apply_command.cmd_dic <- function(cdb, self) {
  orig_var <- cdb$args$orig_var
  vec <- self$dat_mod[[orig_var]]
  new_var <- cdb$args$new_var

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

#' @export
apply_command.cmd_autorec <- function(cdb, self) {
  var_name <- cdb$args$var
  vec <- self$dat_mod[[var_name]]
  x_labelled <- labelled::to_labelled(as.factor(vec))
  labelled::var_label(x_labelled) <- attr(vec, "label", exact = TRUE)

  self$dat_mod[[var_name]] <- x_labelled
  invisible(self)
}

# #STR2NUM
#' @export
apply_command.cmd_str_to_num <- function(cdb, self) {
  var_name <- cdb$args$var
  var <- self$dat_mod[[var_name]]
  self$dat_mod[[var_name]] <- haven::labelled(
    var %>% tablab::strip_attributes() %>% as.numeric(),
    label = attr(var, "label", exact = TRUE)
  )
  invisible(self)
}
