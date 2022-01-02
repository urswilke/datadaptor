#' Construct command block record
#'
#' When a command_blocks object is printed, it is transform into a `"command_block_rcrd"`.
#'
#' @param command_blocks command_blocks object
#'
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' m <- Mapping$new(spss_file, mapping_file)
#' rcrd <- m$cmd_tbl$command_blocks %>% command_block_rcrd()
#' rcrd
#' # This results in the same print:
#' m$cmd_tbl$command_blocks
command_block_rcrd <- function(command_blocks) {
  command_blocks %>%
    purrr::transpose() %>%
    vctrs::new_rcrd(class = "command_block_rcrd")
}



#' @param x command_block object
#' @param ... not needed for now
#' @export
#' @rdname command_block_rcrd
format.command_block_rcrd <- function(x, ...) {
  x_valid <- which(!is.na(x))

  sheet <- vctrs::field(x, "sheet") %>% abbreviate(6)
  action <- vctrs::field(x, "action") %>% abbreviate(6)
  new_var <- vctrs::field(x, "new_var")
  max_var_len <- purrr::map_int(new_var, nchar) %>% max()
  new_var <- new_var %>% stringr::str_pad(max_var_len, side = "right")
  args <- vctrs::field(x, "args")

  ret <- cmd_block_args_formatter(sheet, action, args)
  ret
}


cmd_block_args_formatter <- function(sheet, action, args) {
  df_long <- dplyr::tibble(sheet, action, args) %>%
    dplyr::mutate(row = dplyr::row_number()) %>%
    tidyr::unnest(args) %>%
    dplyr::mutate(tibble::enframe(args))

  ret <- df_long %>%
    dplyr::rowwise() %>%
    dplyr::mutate(value = paste(.data$value, collapse = ", ")) %>%
    dplyr::group_by(row) %>%
    dplyr::summarise(
      paste0(
        # cli::col_grey(abbreviate(sheet[1], 6)),
        # cli::col_grey(abbreviate(action[1], 6)),
        # cli::col_grey(abbreviate(name, 6)),
        # cli::col_grey(": "),
        # value %>% str_trunc(16),
        # collapse = cli::col_grey("; ")
        abbreviate(.data$name, 6),
        ": ",
        .data$value %>% stringr::str_trunc(16),
        collapse = "; "
      )
    ) %>%
    dplyr::pull() %>%
    paste(abbreviate(sheet, 6), abbreviate(action, 6), .) %>%
    stringr::str_pad(max(nchar(.)), side = "right")
  format(ret, justify = "right")
}

#' @rdname command_block_rcrd
#' @export
vec_ptype_abbr.command_block_rcrd <- function(x) {
  "cmdblk"
}

#' @rdname command_block_rcrd
#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.command_block_rcrd <- function(x, ...) {
  out <- format(x)
  pillar::new_pillar_shaft_simple(out, align = "right", min_width = 24)
}

#' @rdname command_blocks
#' @param x command_block object
#' @param ... not needed for now
#' @export
print.command_blocks <- function(x, ...) {
  print(command_block_rcrd(x), ...)
}
