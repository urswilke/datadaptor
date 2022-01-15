#' Parse command block arguments to named list
#'
#' Depending of the subclass of the command block, the method is chosen.
#'
#' @param cdb command block
#'
#' @return The command block is returned with an added list element `cdb$args`,
#'   containing the named arguments, passed to the `apply_command()` method.
#'
#' @export
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' m <- Mapping$new(spss_file, mapping_file)
#' m$cmd$df_cmd_raw[10,] %>%
#'   command_block() %>%
#'   parse_command_args()
parse_command_args <- function(cdb) {
  UseMethod("parse_command_args")
}
#' @export
parse_command_args.cmd_recna_xcpt <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    xs = d$xs,
    v = d$replace_val,
    vallab = d$replace_label
  )
  cdb
}
#' @export
parse_command_args.cmd_r <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    r_code = d$X2
  )
  cdb
}
#' @export
parse_command_args.cmd_rfun <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    r_script = d$X2,
    fun_name = d$X3
  )
  cdb
}
#' @export
parse_command_args.cmd_kg <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    split_var = d$X3[1],
    by_var = d$X2[1]
  )
  cdb
}
#' @export
parse_command_args.cmd_drop <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    xs = d$vars[[1]]
  )
  cdb
}
#' @export
parse_command_args.cmd_verbatim <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    x = d$x,
    v = d$val_assign,
    varlab = d$varlab[[1]],
    vallabs = d$vallab[[1]],
    id_list = d$id_list[[1]],
    v0 = d$init_val
  )
  cdb
}
#' @export
parse_command_args.cmd_merge <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    xs = d$X4[1] %>% stringr::str_split(" ", simplify = T) %>% as.vector(),
    merge_file = d$X2,
    id = d$X3[1]
  )
  cdb
}
#' @export
parse_command_args.cmd_rename <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    xs = d$new_names[[1]],
    ys = d$vars[[1]]
  )
  cdb
}
#' @export
parse_command_args.cmd_if <- function(cdb) {
  assignment <- cdb$raw$X3 %>%
    stringr::str_split("=") %>%
    unlist() %>%
    stringr::str_squish()

  cdb$args <- list(
    x   = assignment[1],
    e   = assignment[2],
    condition = cdb$raw$X2
  )
  cdb
}
#' @export
parse_command_args.cmd_comp <- function(cdb) {
  cdb$args <- list(
    x   = cdb$raw$X2[1],
    e   = cdb$raw$X3[1]
  )
  cdb
}
#' @export
parse_command_args.cmd_compr <- parse_command_args.cmd_comp

#' @export
parse_command_args.cmd_set_lab <- function(cdb) {
  cdb$args <- list(
    x = cdb$raw$X2[1],
    varlab = cdb$raw$X3[1]
  )
  cdb
}

#' @export
parse_command_args.cmd_newlab <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    x = d$var[1],
    new_label = d$new_label[1]
  )
  cdb
}
#' @export
parse_command_args.cmd_set_labs <- function(cdb) {
  varlab <- cdb$raw$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }

  cdb$args <- list(
    x = cdb$raw$X2[1],
    varlab = varlab,
    vs = cdb$raw$X2[-1] %>% as.numeric(),
    vallabs = cdb$raw$X3[-1]
  )
  cdb
}
#' @export
parse_command_args.cmd_add_labs <- function(cdb) {
  d <- cdb$raw
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  cdb$args <- list(
    x = d$X2[1],
    varlab = varlab,
    vs = d$X2[-1] %>% as.numeric(),
    vallabs = d$X3[-1]
  )
  cdb
}
#' @export
parse_command_args.cmd_newvall <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    x = d$var[1],
    vs = d$nv %>% as.numeric(),
    vallabs = d$new_label
  )
  cdb
}
#' @export
parse_command_args.cmd_rec <- function(cdb) {
  d <- cdb$raw
  cdb$args <- list(
    y = d$X2[1],
    x = d$X3[1],
    varlab = d$X4[1],
    lb = d$X2[-1] %>% as.numeric(),
    ub = d$X3[-1] %>% as.numeric(),
    vs = d$X4[-1] %>% as.numeric(),
    vallabs = d$X5[-1]
  )
  cdb
}

#' @export
parse_command_args.cmd_sumvar <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    x = paste0("k", d$var[1]),
    y = d$var[1],
    varlab = d$sum_var_label[1],
    vs0 = d$nv %>% as.numeric(),
    vs = d$sum_var_value %>% as.numeric(),
    vallabs = d$sum_var_vallab
  )
  cdb
}

#' @export
parse_command_args.cmd_dic <- function(cdb) {
  d <- cdb$raw

  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  cdb$args <- list(
    y = d$X2[1],
    x  = d$X3[1]
  )
  cdb
}

#' @export
parse_command_args.cmd_autorec <- function(cdb) {
  d <- cdb$raw
  cdb$args <- list(
    x = d$var
  )

  cdb
}

#' @export
parse_command_args.cmd_str_to_num <- function(cdb) {
  d <- cdb$raw
  cdb$args <- list(
    x = d$var
  )
  cdb
}
