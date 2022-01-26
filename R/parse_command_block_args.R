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
#' (cdb_raw <- m$cmd_tbl$command_blocks_raw[[10]])
#' cdb <- parse_command_args(cdb_raw)
#' cdb$args
#' cdbs <- m$cmd_tbl
#'
#' # Generate a `command_blocks` object with all unique types of
#' # `command_block`s  in the mapping file
#' (unique_cmd_tbl <- m$cmd_tbl[!duplicated(cdbs$action), ])
#'
#' # Generate/print a list of all args sub-elements:
#' (args_overview <- setNames(
#'   purrr::map(unique_cmd_tbl$command_blocks, "args"),
#'   unique_cmd_tbl$action
#' ))
#'
#' # Show a table of all `arg`s, and an example of their type & length
#' # for all command block types `cmd`:
#' args_tbl <- tibble::tibble(
#'   cmd = unique_cmd_tbl$action,
#'   example = args_overview
#' ) %>%
#'   tidyr::unnest_longer(example, indices_to = "arg") %>%
#'   .[c(1, 3, 2)]
#'
#' print(args_tbl, n = 1000)
#'
#' args_tbl %>%
#'   dplyr::group_by(
#'     arg_class = arg %>%
#'     str_remove("\\d$") %>%
#'     str_remove("s$")
#'   ) %>%
#'   group_by(cmd) %>%
#'   mutate(arg = paste(arg, collapse = " ")) %>%
#'   mutate(example = unname(example)) %>%
#'   pivot_wider(
#'     names_from = arg_class,
#'     values_from = example,
#'     values_fn = list
#'   ) %>%
#'   print(n = 100)
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
    ex = d$X2
  )
  cdb
}
#' @export
parse_command_args.cmd_rfun <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    filepath = d$X2,
    ex_fun = d$X3
  )
  cdb
}
#' @export
parse_command_args.cmd_kg <- function(cdb) {
  d <- cdb$raw

  cdb$args <- list(
    x = d$X3[1],
    y = d$X2[1]
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
  vallabs_named <- d$vallab[[1]]

  cdb$args <- list(
    x = d$x,
    v = d$ex_assign,
    varlab = d$varlab[[1]],
    vs = unname(vallabs_named),
    vallabs = names(vallabs_named),
    id_list = d$id_list[[1]],
    v0 = d$init_val,
    ex_further_cond = d$ex_further_cond,
    ex_assign = d$ex_assign
  )

  cdb
}
#' @export
parse_command_args.cmd_merge <- function(cdb) {
  d <- cdb$raw

  varnames_vec <- d$X4[1] %>%
    stringr::str_trim() %>%
    stringr::str_split(" ", simplify = TRUE) %>%
    as.vector()

  cdb$args <- list(
    xs = varnames_vec,
    filepath = d$X2,
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
    x = assignment[1],
    ex = assignment[2],
    ex_cond = cdb$raw$X2
  )
  cdb
}
#' @export
parse_command_args.cmd_comp <- function(cdb) {
  cdb$args <- list(
    x = cdb$raw$X2[1],
    ex = cdb$raw$X3[1]
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
    varlab = d$new_label[1]
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
    vs0 = d$X2[-1] %>% as.numeric(),
    vs2 = d$X3[-1] %>% as.numeric(),
    vs = d$X4[-1] %>% as.numeric(),
    vallabs = d$X5[-1],
    varlab = d$X4[1]
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
    x = d$X3[1]
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
