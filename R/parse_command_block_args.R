#' Parse command block arguments to named list
#'
#' Depending of the subclass of the command block, the method is chosen.
#'
#' @param cdb_raw `raw` data field of a `command_block`
#'
#' @return The command block is returned with an added list element `cdb$args`,
#'   containing the named arguments, passed to the `apply_command()` method.
#'
#' @export
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' m <- Mapping$new(spss_file, mapping_file)
#' (cdb <- command_block(m$cmd$df_cmd_raw[10, ]))
#' # Under the hood the command_block() generator calls
#' # parse_command_args() and adds its result to the args field:
#' parse_command_args(structure(cdb$raw[[1]], class = class(cdb)))
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
#' ) |>
#'   tidyr::unnest_longer(example, indices_to = "arg") |>
#'   .[c(1, 3, 2)]
#'
#' print(args_tbl, n = 1000)
#'
#' args_tbl |>
#'   dplyr::group_by(
#'     arg_class = arg |>
#'       stringr::str_remove("\\d$") |>
#'       stringr::str_remove("s$")
#'   ) |>
#'   dplyr::group_by(cmd) |>
#'   dplyr::mutate(arg = paste(arg, collapse = " ")) |>
#'   dplyr::mutate(example = unname(example)) |>
#'   tidyr::pivot_wider(
#'     names_from = arg_class,
#'     values_from = example,
#'     values_fn = list
#'   ) |>
#'   print(n = 100)
parse_command_args <- function(cdb_raw) {
  UseMethod("parse_command_args")
}
#' @export
parse_command_args.cmd_recna_xcpt <- function(cdb_raw) {
  list(
    xs = cdb_raw$xs,
    v = cdb_raw$replace_val,
    vallab = cdb_raw$replace_label
  )
}
#' @export
parse_command_args.cmd_r <- function(cdb_raw) {
  list(
    ex = cdb_raw$X2
  )
}
#' @export
parse_command_args.cmd_rfun <- function(cdb_raw) {
  list(
    filepath = cdb_raw$X2,
    ex_fun = cdb_raw$X3
  )
}
#' @export
parse_command_args.cmd_kg <- function(cdb_raw) {
  list(
    x = cdb_raw$X3[1],
    y = cdb_raw$X2[1]
  )
}
#' @export
parse_command_args.cmd_drop <- function(cdb_raw) {
  list(
    xs = cdb_raw$vars[[1]]
  )
}
#' @export
parse_command_args.cmd_verbatim <- function(cdb_raw) {
  vallabs_named <- cdb_raw$vallab[[1]]

  list(
    x = cdb_raw$x,
    v = as.numeric(cdb_raw$ex_assign),
    varlab = cdb_raw$varlab[[1]],
    vs = unname(vallabs_named),
    vallabs = names(vallabs_named),
    id_list = cdb_raw$id_list[[1]],
    v0 = cdb_raw$init_val,
    ex_further_cond = cdb_raw$ex_further_cond,
    ex_assign = cdb_raw$ex_assign
  )
}
#' @export
parse_command_args.cmd_verbatim_custom <- function(cdb_raw) {
  vallabs_named <- cdb_raw$vallab[[1]]

  list(
    x = cdb_raw$x,
    varlab = cdb_raw$varlab[[1]],
    vs = unname(vallabs_named),
    vallabs = names(vallabs_named),
    id_list = cdb_raw$id_list[[1]],
    v0 = cdb_raw$init_val,
    ex_further_cond = cdb_raw$ex_further_cond,
    ex_assign = cdb_raw$ex_assign
  )
}
#' @export
parse_command_args.cmd_merge <- function(cdb_raw) {
  varnames_vec <- cdb_raw$X4[1] |>
    stringr::str_trim() |>
    stringr::str_split(" ", simplify = TRUE) |>
    as.vector()

  list(
    xs = varnames_vec,
    filepath = cdb_raw$X2,
    id = cdb_raw$X3[1]
  )
}
#' @export
parse_command_args.cmd_addfile <- function(cdb_raw) {
  list(
    filepath = cdb_raw$X2
  )
}
#' @export
parse_command_args.cmd_rmval <- function(cdb_raw) {
  varlab <- cdb_raw$X4[1]
  x <- cdb_raw$X3[1]
  y <- cdb_raw$X2[1]
  if (is.na(x)) {
    x <- y
  }
  if (is.na(varlab)) {
    varlab <- NULL
  }
  list(
    x  = x,
    y  = y,
    vs = as.numeric(cdb_raw$X2[-1]),
    varlab = varlab
  )
}
#' @export
parse_command_args.cmd_rename_varsheet <- function(cdb_raw) {
  list(
    xs = cdb_raw$new_names[[1]],
    ys = cdb_raw$vars[[1]]
  )
}
#' @export
parse_command_args.cmd_rename <- function(cdb_raw) {
  list(
    xs = cdb_raw$X3,
    ys = cdb_raw$X2
  )
}
#' @export
parse_command_args.cmd_if <- function(cdb_raw) {
  assignment <- cdb_raw$X3 |>
    stringr::str_split("=") |>
    unlist() |>
    stringr::str_squish()

  list(
    x = assignment[1],
    ex = assignment[2],
    ex_cond = cdb_raw$X2
  )
}
#' @export
parse_command_args.cmd_comp <- function(cdb_raw) {
  list(
    x = cdb_raw$X2[1],
    ex = cdb_raw$X3[1]
  )
}
#' @export
parse_command_args.cmd_compr <- parse_command_args.cmd_comp

#' @export
parse_command_args.cmd_set_lab <- function(cdb_raw) {
  list(
    x = cdb_raw$X2[1],
    varlab = cdb_raw$X3[1]
  )
}

#' @export
parse_command_args.cmd_newlab <- function(cdb_raw) {
  list(
    x = cdb_raw$var[1],
    varlab = cdb_raw$new_label[1]
  )
}
#' @export
parse_command_args.cmd_set_labs <- function(cdb_raw) {
  varlab <- cdb_raw$X3[1]
  if (is.na(varlab) | varlab == "") {
    varlab <- NULL
  }

  list(
    x = cdb_raw$X2[1],
    varlab = varlab,
    vs = cdb_raw$X2[-1] |> as.numeric(),
    vallabs = cdb_raw$X3[-1]
  )
}
#' @export
parse_command_args.cmd_add_labs <- function(cdb_raw) {
  varlab <- cdb_raw$X3[1]
  if (is.na(varlab) | varlab == "") {
    varlab <- NULL
  }
  list(
    x = cdb_raw$X2[1],
    varlab = varlab,
    vs = cdb_raw$X2[-1] |> as.numeric(),
    vallabs = cdb_raw$X3[-1]
  )
}
#' @export
parse_command_args.cmd_newvall <- function(cdb_raw) {
  list(
    x = cdb_raw$var[1],
    vs = cdb_raw$nv |> as.numeric(),
    vallabs = cdb_raw$new_label
  )
}
#' @export
parse_command_args.cmd_rec <- function(cdb_raw) {
  list(
    y = cdb_raw$X2[1],
    x = cdb_raw$X3[1],
    vs0 = cdb_raw$X2[-1] |> as.numeric(),
    vs2 = cdb_raw$X3[-1] |> as.numeric(),
    vs = cdb_raw$X4[-1] |> as.numeric(),
    vallabs = cdb_raw$X5[-1],
    varlab = cdb_raw$X4[1]
  )
}

#' @export
parse_command_args.cmd_sumvar <- function(cdb_raw) {
  list(
    x = paste0("k", cdb_raw$var[1]),
    y = cdb_raw$var[1],
    varlab = cdb_raw$sum_var_label[1],
    vs0 = cdb_raw$nv |> as.numeric(),
    vs = cdb_raw$sum_var_value |> as.numeric(),
    vallabs = cdb_raw$sum_var_vallab
  )
}

#' @export
parse_command_args.cmd_dic <- function(cdb_raw) {
  varlab <- cdb_raw$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  list(
    y = cdb_raw$X2[1],
    x = cdb_raw$X3[1]
  )
}

#' @export
parse_command_args.cmd_autorec <- function(cdb_raw) {
  list(
    x = cdb_raw$var
  )
}

#' @export
parse_command_args.cmd_str_to_num <- function(cdb_raw) {
  list(
    x = cdb_raw$var
  )
}
