#' @export
parse_command_args <- function(x) {
  UseMethod("parse_command_args")
}
#' @export
parse_command_args.cmd_recna_xcpt <- function(x) {
  d <- x$raw

  x$args <- list(
    recode_na_exceptions = d$recode_na_exceptions,
    replace_val = d$replace_val,
    replace_label = d$replace_label
  )
  x
}
#' @export
parse_command_args.cmd_r <- function(x) {
  d <- x$raw

  x$args <- list(
    r_code = d$X2
  )
  x
}
#' @export
parse_command_args.cmd_rfun <- function(x) {
  d <- x$raw

  x$args <- list(
    r_script = d$X2,
    fun_name = d$X3
  )
  x
}
#' @export
parse_command_args.cmd_kg <- function(x) {
  d <- x$raw

  x$args <- list(
    split_var = d$X3[1],
    by_var = d$X2[1]
  )
  x
}
#' @export
parse_command_args.cmd_drop <- function(x) {
  d <- x$raw

  x$args <- list(
    orig_vars = d$vars[[1]]
  )
  x
}
#' @export
parse_command_args.cmd_verbatim <- function(x) {
  d <- x$raw

  x$args <- list(
    var_ziel = d$var_ziel,
    val_assign = d$val_assign,
    varlab = d$varlab[[1]],
    vallab = d$vallab[[1]],
    id_list = d$id_list[[1]],
    init_val = d$init_val
  )
  x
}
#' @export
parse_command_args.cmd_merge <- function(x) {
  d <- x$raw

  x$args <- list(
    variable_names = d$X4[1] %>% stringr::str_split(" ", simplify = T) %>% as.vector(),
    merge_file = d$X2,
    id = d$X3[1]
  )
  x
}
#' @export
parse_command_args.cmd_rename <- function(x) {
  d <- x$raw

  x$args <- list(
    orig_vars = d$vars[[1]],
    new_names = d$new_names[[1]]
  )
  x
}
#' @export
parse_command_args.cmd_if <- function(x) {
  assignment <- x$raw$X3 %>%
    stringr::str_split("=") %>%
    unlist() %>%
    stringr::str_squish()

  x$args <- list(
    new_var   = assignment[1],
    new_val   = assignment[2],
    condition = x$raw$X2
  )
  x
}
#' @export
parse_command_args.cmd_comp <- function(x) {
  x$args <- list(
    new_var   = x$raw$X2[1],
    new_val   = x$raw$X3[1]
  )
  x
}
#' @export
parse_command_args.cmd_compr <- parse_command_args.cmd_comp

#' @export
parse_command_args.cmd_set_lab <- function(x) {
  x$args <- list(
    orig_var = x$raw$X2[1],
    new_lab = x$raw$X3[1]
  )
  x
}

#' @export
parse_command_args.cmd_newlab <- function(x) {
  d <- x$raw

  x$args <- list(
    orig_var = d$var[1],
    new_label = d$new_label[1]
  )
  x
}
#' @export
parse_command_args.cmd_set_labs <- function(x) {
  varlab <- x$raw$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }

  x$args <- list(
    orig_var = x$raw$X2[1],
    new_lab = varlab,
    new_vals = x$raw$X2[-1] %>% as.numeric(),
    new_labs = x$raw$X3[-1]
  )
  x
}
#' @export
parse_command_args.cmd_add_labs <- function(x) {
  d <- x$raw
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  x$args <- list(
    orig_var = d$X2[1],
    new_lab = varlab,
    vals_added = d$X2[-1] %>% as.numeric(),
    labs_added = d$X3[-1]
  )
  x
}
#' @export
parse_command_args.cmd_newvall <- function(x) {
  d <- x$raw

  x$args <- list(
    orig_var = d$var[1],
    vals_added = d$nv %>% as.numeric(),
    labs_added = d$new_label
  )
  x
}
#' @export
parse_command_args.cmd_rec <- function(x) {
  d <- x$raw
  x$args <- list(
    # use orig_var if new_var is NA (empty in Excel file):
    orig_var = d$X2[1],
    new_var = d$X3[1],
    new_lab = d$X4[1],
    lb = d$X2[-1] %>% as.numeric(),
    ub = d$X3[-1] %>% as.numeric(),
    new_vals = d$X4[-1] %>% as.numeric(),
    new_labs = d$X5[-1]
  )
  x
}

#' @export
parse_command_args.cmd_sumvar <- function(x) {
  d <- x$raw

  x$args <- list(
    # use orig_var if new_var is NA (empty in Excel file):
    new_var = paste0("k", d$var[1]),
    orig_var = d$var[1],
    new_lab = d$sum_var_label[1],
    orig_vals = d$nv %>% as.numeric(),
    new_vals = d$sum_var_value %>% as.numeric(),
    new_labs = d$sum_var_vallab
  )
  x
}

#' @export
parse_command_args.cmd_dic <- function(x) {
  d <- x$raw

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
parse_command_args.cmd_autorec <- function(x) {
  d <- x$raw
  x$args <- list(
    var = d$var
  )

  x
}

#' @export
parse_command_args.cmd_str_to_num <- function(x) {
  d <- x$raw
  x$args <- list(
    var = d$var
  )
  x
}
