#' Apply a command block to the data
#'
#' see `vignette("command_blocks")`
#'
#' @param cdb `command_block` object
#' @param mapping mapping object
#' @param ... Arguments passed to method
#'
#' @export
#' @examples
#' # see vignette("command_blocks")
apply_command <- function(cdb, mapping, ...) {
  UseMethod("apply_command")
}

# thanks to
# https://mirai-solutions.ch/techguides/advanced-usage-and-consistent-documentation.html#using-rdname-and-describein
# We can collect all the roxxygen `@param`s in one place:
#' @name apply_command_args
#' @rdname apply_command
#' @param x,xs,y,ys character string (vector) of variable names in
#'   `mapping$dat_mod`
#' @param v,v0,vs,vs0,vs2 Numeric value(s)
#' @param vallab,vallabs Value label(s)
#' @param varlab Character string containing a variable label
#' @param ex,exs,ex_cond,ex_fun,ex_further_cond,ex_assign,exs_fns_names,ex_names Character strings
#'   containing valid R expressions. They will be evaluated in
#'   `mapping$opts$da$expr_eval_env` (see `get_mapping_options()`), except `exs`
#'   which contains a list of expressions evaluated in the global environment.
#' @param filepath Character string containing valid file path
#' @param coal Character string containing either `"xy"` or `"yx"`.
#'   This determines if `powerjoin::coalesce_xy()` or `powerjoin::coalesce_yx()` is used
#'   when merging data with variables that already exist.
#' @param id Character string of the variable name of the id variable in
#'   `mapping$dat`.
#' @param id_list Vector of id values in `mapping$dat_mod[id]`.
#'
NULL
# see https://github.com/r-lib/tidyselect/issues/201#issuecomment-650547846:
globalVariables("where")
#' @describeIn apply_command Replace missing values of the labelled variables in
#'   `mapping$dat_mod` (except those specified in `xs`) with the value `v`,
#'   labelled `vallab`.
#' @export
apply_command.cmd_recna_xcpt <- function(cdb, mapping, xs, v, vallab, ...) {
  have_na_lgl <- mapping$dat_mod |> map_lgl(anyNA)
  vars_to_add_filter <- have_na_lgl[have_na_lgl] |>
    names() |>
    setdiff(xs)
  mapping$dat_mod <- mapping$dat_mod |>
    mutate(
      across(
        where(is.numeric) & c(one_of(vars_to_add_filter)),
        ~ set_na_to_filter(.x, v, vallab)
      )
    )
}

#' @describeIn apply_command Execute R code
#' @export
apply_command.cmd_r <- function(cdb, mapping, exs, ...) {
  exs |>
    parse_exprs() |>
    map(eval)
}

#' @describeIn apply_command Execute the function named `ex_fun` and
#'   defined in the R script named `filepath`.
#' @export
apply_command.cmd_rfun <- function(cdb, mapping, filepath, ex_fun, ...) {
  if (!is.na(filepath)) {
    source(filepath, echo = FALSE)
  }

  mapping$dat_mod <- do.call(ex_fun, list(mapping$dat_mod))
}

#' @describeIn apply_command Split variable
#'
#' @export
apply_command.cmd_kg <- function(cdb, mapping, x, y, ...) {
  split_var <- mapping$dat_mod[[x]]
  by_var <- mapping$dat_mod[[y]]
  df <- data.frame(split_var, by_var) |> set_names(~ c(x, y))
  # by_var <- as_string(expr(by_var))
  new_vars <- prepare_newvar_table(df, x, y)
  mapping$dat_mod[new_vars$new_varnames] <- new_vars |>
    transpose() |>
    # these 2 lines would do the same
    # rowwise() |>
    # group_split() |>
    # add the new variables one by one to the dataframe:
    reduce(split_cat_by_cat, x, y, .init = df) |>
    select(-all_of(c(x, y)))
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_drop <- function(cdb, mapping, xs, ...) {
  mapping$dat_mod[xs] <- NULL
}
#' @describeIn apply_command
#'
#' @export
apply_command.cmd_select <- function(cdb, mapping, exs, ...) {
  exs_ex <- parse_exprs(exs)
  mapping$dat_mod <- mapping$dat_mod |> select(!!!exs_ex)
}
#' @describeIn apply_command
#'
#' @export
apply_command.cmd_across <- function(
  cdb,
  mapping,
  exs,
  ex_fun,
  exs_fns_names,
  ex_names,
  ...
) {
  exs_ex <- parse_expr(exs)
  ex_fun <- ex_fun |>
    map(parse_expr) |>
    map(\(x) eval_in_data(x, mapping))
  if (!is.null(exs_fns_names)) {
    stopifnot(length(ex_fun) == length(exs_fns_names))
    names(ex_fun) <- exs_fns_names
  }
  # in order to prevent the function name suffix when passing an unnamed list to
  # across()
  if (length(ex_fun) == 1 & is.null(exs_fns_names)) {
    ex_fun <- ex_fun[[1]]
  }
  mapping$dat_mod <- mapping$dat_mod |>
    mutate(across(!!exs_ex, ex_fun, .names = ex_names))
}
#' @describeIn apply_command
#'
#' @export
apply_command.cmd_filter <- function(cdb, mapping, exs, ...) {
  exs_ex <- parse_exprs(exs)
  mapping$dat_mod <- mapping$dat_mod |> filter(!!!exs_ex)
}
#' @describeIn apply_command
#'
#' @export
apply_command.cmd_verbatim <- function(
    cdb, mapping, x, v, varlab, vs,
    vallabs, id_list, v0, ex_further_cond,
    id = mapping$opts$da$id_var, ...) {
  vallabs_named <- set_names(vs, vallabs)

  if (!x %in% names(mapping$dat_mod)) {
    mapping$dat_mod[[x]] <- v0
  }

  # keep variable label if it already exists:
  if (is.null(varlab)) {
    varlab <- attr(mapping$dat_mod[[x]], "label", exact = TRUE)
  }

  if (!is.na(ex_further_cond)) {
    further_ex_bool <- eval_in_data(
      parse_expr(ex_further_cond),
      mapping
    ) |>
      is_true_vec()
  } else {
    further_ex_bool <- TRUE
  }

  mapping$dat_mod[[x]][mapping$dat_mod[[id]] %in% id_list & further_ex_bool] <- v
  mapping$dat_mod[[x]] <- labelled(
    mapping$dat_mod[[x]],
    labels = vallabs_named,
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_verbatim_custom <- function(
    cdb, mapping, x, varlab, vs, vallabs,
    id_list, v0, ex_further_cond, ex_assign,
    id = mapping$opts$da$id_var, ...) {
  if (!x %in% names(mapping$dat_mod)) {
    mapping$dat_mod[[x]] <- v0
  }

  # keep variable label if it already exists:
  if (is.null(varlab)) {
    varlab <- attr(mapping$dat_mod[[x]], "label", exact = TRUE)
  }

  if (!is.na(ex_further_cond)) {
    further_ex_bool <- eval_in_data(parse_expr(ex_further_cond), mapping) |>
      is_true_vec()
  } else {
    further_ex_bool <- rep(TRUE, nrow(mapping$dat_mod))
  }

  ex_assign_vec <- eval_in_data(parse_expr(ex_assign), mapping)
  # don't take the variable label of the verbatim coding...:
  # varlab <- attr(ex_assign_vec, "label", exact = TRUE)
  # ... only keep the existing value labels:
  vallabs_named <- attr(ex_assign_vec, "labels")

  id_list_existing <- intersect(id_list, mapping$dat[[id]])
  if (length(id_list_existing) < length(id_list)) {
    warning("there are id values in the verbatim sheet not in the data")
  }
  ex_row_indices <- match(id_list_existing, mapping$dat[[id]])
  assign_indices <- intersect(which(further_ex_bool), ex_row_indices)


  mapping$dat_mod[assign_indices, ][[x]] <- ex_assign_vec[assign_indices]
  mapping$dat_mod[[x]] <- labelled(
    mapping$dat_mod[[x]],
    labels = vallabs_named,
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_merge <- function(
    cdb, mapping, xs, filepath, id, coal, ...) {
  # if id var is not set, take global id var
  if (is.na(id)) {
    id <- mapping$opts$da$id_var
  }
  df_merge <- mapping$read_data(filepath)

  # If `xs` is specified in Excel sheet, keep only variables in `xs`:
  if (!is.na(xs[1])) {
    df_merge <- df_merge[c(id, xs)]
  }

  coalesce_fun <- if (coal %in% "yx") {
    coalesce_yx
  } else {
    coalesce_xy
  }

  mapping$dat_mod <- power_full_join(
    mapping$dat_mod,
    df_merge,
    by = id,
    conflict = coalesce_fun
  ) |>
    relocate(all_of(names(mapping$dat_mod)))
  attr(mapping$dat_mod, "DC_dataset_origin") <-
    attr(mapping$dat_mod, "DC_dataset_origin") |>
    append(attr(df_merge, "DC_dataset_origin"))
}
#' @describeIn apply_command
#'
#' @export
apply_command.cmd_addfile <- function(
    cdb, mapping, filepath, ...) {
  df_newcases <- read_sav(filepath)
  mapping$dat_mod <- bind_rows(
    mapping$dat_mod,
    df_newcases
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_rename_varsheet <- function(cdb, mapping, xs, ys, ...) {
  mapping$dat_mod <- mapping$dat_mod |>
    rename(!!!set_names(ys, xs))
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_rename <- apply_command.cmd_rename_varsheet

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_if <- function(cdb, mapping, x, ex_cond, ex, ...) {
  cond <- parse_expr(ex_cond)
  val <- parse_expr(ex)

  # add double NA column to data, if x doesn't exist yet (together with
  # the attributes copying below, this keeps the variable's labels if existing):
  if (!x %in% names(mapping$dat_mod)) {
    mapping$dat_mod[[x]] <- NA_real_
  }

  test <- eval_in_data(expr(datadaptor::is_true_vec(!!cond)), mapping)
  yes <- eval_in_data(expr(!!val), mapping)

  no <- mapping$dat_mod[[x]]

  res <- ifelse(test, yes, no)
  attributes(res) <- attributes(no)
  mapping$dat_mod[[x]] <- res
}

eval_in_data <- function(ex, mapping) {
  e <- list2env(mapping$dat_mod, envir = mapping$opts$da$expr_eval_env)
  e[["dat_mod"]] <- mapping$dat_mod
  eval_tidy(
    ex,
    env = e
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_comp <- function(cdb, mapping, x, ex, ...) {
  val <- parse_expr(ex)

  # add double NA column to data, if x doesn't exist yet (together with
  # the attributes copying below, this keeps the variable's labels if existing):
  if (!x %in% names(mapping$dat_mod)) {
    mapping$dat_mod[[x]] <- NA_real_
  }

  vec <- eval_in_data(expr(!!val), mapping)
  varlab <- var_label(vec) %||% var_label(mapping$dat_mod[[x]])
  vallabs <- val_labels(vec) %||% val_labels(mapping$dat_mod[[x]])
  if (is.logical(vec)) {
    vec <- as.numeric(vec)
  }
  # attributes(vec) <- attributes(mapping$dat_mod[[x]])
  if (!is.null(varlab) | !is.null(vallabs)) {
    vec <- labelled(
      vec,
      labels = vallabs,
      label = varlab
    )
  }

  mapping$dat_mod[[x]] <- vec
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_debug <- function(cdb, mapping, ...) {
  browser()
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_set_lab <- function(cdb, mapping, x, varlab, ...) {
  # faster execution if variable is already of type labelled:
  if (is.labelled(mapping$dat_mod[[x]])) {
    attr(mapping$dat_mod[[x]], "label") <- varlab
    # break function execution:
    return(NULL)
  }

  vec <- mapping$dat_mod[[x]]
  mapping$dat_mod[[x]] <- labelled(
    vec,
    labels = attr(vec, "labels"),
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_newlab <- apply_command.cmd_set_lab

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_rmval <- function(cdb, mapping, x, y, vs, varlab, ...) {
  vec <- mapping$dat_mod[[y]]
  vallabs <- attr(vec, "labels")
  vec[vec %in% vs] <- NA_real_
  vallabs_mod <- vallabs[!vallabs %in% vs]
  if (is.null(varlab)) {
    varlab <- attr(vec, "label", exact = TRUE)
  }
  mapping$dat_mod[[x]] <- labelled(
    vec,
    labels = vallabs_mod,
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_set_labs <- function(
  cdb,
  mapping,
  x,
  varlab,
  vs,
  vallabs,
  ...
) {
  if (is.null(varlab)) {
    varlab <- attr(mapping$dat_mod[[x]], "label", exact = TRUE)
  }
  mapping$dat_mod[[x]] <- labelled(
    mapping$dat_mod[[x]],
    labels = set_names(vs, vallabs),
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_add_labs <- function(
    cdb, mapping, x, varlab = NULL, vs, vallabs, ...) {
  vec <- mapping$dat_mod[[x]]
  old_vallab_vec <- attr(vec, "labels")
  added_vallab_vec <- set_names(vs, vallabs)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)

  if (is.null(varlab)) {
    varlab <- attr(vec, "label", exact = TRUE)
  }

  mapping$dat_mod[[x]] <- labelled(
    vec,
    labels = new_vallab_vec,
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_newvall <- apply_command.cmd_add_labs

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_rec <- function(
    cdb, mapping, x, y, varlab, vs0, vs, vs2, vallabs, ...) {
  if (is.na(varlab)) {
    varlab <- attr(mapping$dat_mod[[y]], "label", exact = TRUE)
  }

  if (is.na(x) || x == "") {
    x <- y
  }

  lb <- vs0
  vs <- vs
  ub <- vs2

  recode_df <-
    tibble(lb, ub = coalesce(ub, lb), vs, vallabs) |>
    mutate(
      expr_str = paste0("(", y, " >= ", lb, " & ", y, " <= ", ub, ")")
    ) |>
    group_by(vs) |>
    summarise(
      expr_str = paste(.data$expr_str, collapse = " | "),
      vallabs = vallabs[1]
    )
  cond_statements <-
    recode_df |>
    select(vs, "expr_str") |>
    pmap(
      function(vs, expr_str) quo(!!parse_expr(expr_str) ~ !!vs)
    )

  res_num <- expr(dplyr::case_when(!!!cond_statements)) |>
    eval_in_data(mapping)
  if (x == y) {
    res_num <- coalesce(res_num, mapping$dat_mod[[y]])
  }

  vallabs_rec <- set_names(
    recode_df$vs,
    recode_df$vallabs
  )[!is.na(recode_df$vallabs)]

  mapping$dat_mod[[x]] <- labelled(
    res_num,
    labels = vallabs_rec,
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_sumvar <- function(
    cdb, mapping, x, y, varlab, vs0, vs, vallabs, ...) {
  if (is.na(varlab)) {
    varlab <- attr(mapping$dat_mod[[y]], "label", exact = TRUE)
  }

  sum_var_vals_n_labs <- tibble(vs, vallabs) |>
    group_by(vs) |>
    summarise(
      val_labs = first(vallabs)
    )

  vec_num <- vs[match(mapping$dat_mod[[y]], vs0)]

  mapping$dat_mod[[x]] <- labelled(
    vec_num,
    labels = sum_var_vals_n_labs$vs |>
      set_names(sum_var_vals_n_labs$val_labs),
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_dic <- function(cdb, mapping, x, y, ...) {
  vec <- mapping$dat_mod[[y]]

  varlab <- attr(vec, "label", exact = TRUE)
  vallabs <- attr(vec, "labels", exact = TRUE)

  if (!x %in% names(mapping$dat_mod)) {
    mapping$dat_mod[[x]] <- NA_real_
  }

  mapping$dat_mod[[x]] <- labelled(
    mapping$dat_mod[[x]],
    labels = vallabs,
    label = varlab
  )
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_autorec <- function(cdb, mapping, x, ...) {
  vec <- mapping$dat_mod[[x]]
  x_labelled <- to_labelled(as.factor(vec))
  var_label(x_labelled) <- attr(vec, "label", exact = TRUE)

  mapping$dat_mod[[x]] <- x_labelled
}

#' @describeIn apply_command
#'
#' @export
apply_command.cmd_str_to_num <- function(cdb, mapping, x, ...) {
  var <- mapping$dat_mod[[x]]
  mapping$dat_mod[[x]] <- labelled(
    var |> strip_attributes() |> as.numeric(),
    label = attr(var, "label", exact = TRUE)
  )
}
