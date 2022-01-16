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
  condition <- cdb$args$condition
  e <- cdb$args$e

  stopifnot(all(purrr::map_lgl(list(x, condition, e), is.character)))
  lens <- lengths(list(x, condition, e)) %>% unique()
  stopifnot(lens == 1)
  new_validated_command_block(cdb)

}
