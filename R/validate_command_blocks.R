#' S3 method to validate `"command_block"`s
#'
#' See `?Mapping`
#'
#' @param cdb `"command_block"` object
#'
#' @export
validate_command_block <- function(cdb) {
  UseMethod("validate_command_block")
}

#' @rdname command_block
#' @export
validate_command_block.command_block <- function(cdb) {
  new_validated_command_block(cdb)
}
new_validated_command_block <- function(cdb) {
  argnames <- cdb$args %>% names()

  v_names      <- argnames %>% stringr::str_subset("^vs?\\d?$")
  vallab_names <- argnames %>% stringr::str_subset("^vallabs?$")
  ex_names     <- argnames %>% stringr::str_subset("^ex_")
  var_names    <- argnames %>% stringr::str_subset("^[xy]s?$")
  varlab_names <- argnames %>% stringr::str_subset("^varlab$")
  stopifnot(
    all(purrr::map_lgl(cdb$args[v_names], is.numeric))
  )
  stopifnot(
    all(purrr::map_lgl(cdb$args[vallab_names], is.character))
  )
  stopifnot(
    all(purrr::map_lgl(cdb$args[ex_names], is.character))
  )
  stopifnot(
    all(purrr::map_lgl(cdb$args[var_names], is.character))
  )
  stopifnot(
    all(purrr::map_lgl(cdb$args[varlab_names], ~ is.null(.x) || is.character(.x)))
  )


  class(cdb) <- c("validated", class(cdb))
  cdb
}

#' @export
validate_command_block.cmd_if <- function(cdb) {
  x <- cdb$args$x
  ex_cond <- cdb$args$ex_cond
  ex <- cdb$args$ex

  stopifnot(all(!purrr::map_lgl(list(x, ex_cond, ex), is.na)))
  lens <- lengths(list(x, ex_cond, ex)) %>% unique()
  stopifnot(lens == 1)
  NextMethod(cdb)
}
