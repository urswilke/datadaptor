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
  class(cdb) <- c("validated", class(cdb))
  cdb
}

#' @export
validate_command_block.cmd_if <- function(cdb) {
  x <- cdb$args$x
  ex_cond <- cdb$args$ex_cond
  ex <- cdb$args$ex

  stopifnot(all(!purrr::map_lgl(list(x, ex_cond, ex), is.na)))
  stopifnot(all(purrr::map_lgl(list(x, ex_cond, ex), is.character)))
  lens <- lengths(list(x, ex_cond, ex)) %>% unique()
  stopifnot(lens == 1)
  new_validated_command_block(cdb)
}
