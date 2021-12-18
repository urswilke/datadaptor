command_block_rcrd <- function(command_blocks) {
  command_blocks %>%
    transpose() %>%
    new_rcrd(class = "command_block_rcrd")
}



#' @export
format.command_block_rcrd <- function(x, ..., formatter = cmd_block_formatter) {
  x_valid <- which(!is.na(x))

  sheet <- field(x, "sheet") %>% abbreviate(6)
  action <- field(x, "action") %>% abbreviate(6)
  new_var <- field(x, "new_var")
  max_var_len <- map_int(new_var, nchar) %>% max()
  new_var <- new_var %>% str_pad(max_var_len, side = "right")
  args <- field(x, "args")

  ret <- cmd_block_args_formatter(sheet, action, args)
  # It's important to keep NA in the vector!
  ret
}


cmd_block_args_formatter <- function(sheet, action, args) {
  df_long <- tibble(sheet, action, args) %>%
    mutate(row = row_number()) %>%
    unnest(args) %>%
    mutate(enframe(args))

  ret <- df_long %>%
    rowwise() %>%
    mutate(value = paste(value, collapse = ", ")) %>%
    group_by(row) %>%
    summarise(
      paste0(
        # cli::col_grey(abbreviate(sheet[1], 6)),
        # cli::col_grey(abbreviate(action[1], 6)),
        # cli::col_grey(abbreviate(name, 6)),
        # cli::col_grey(": "),
        # value %>% str_trunc(16),
        # collapse = cli::col_grey("; ")
        abbreviate(name, 6),
        ": ",
        value %>% str_trunc(16),
        collapse = "; "
      )
    ) %>%
    pull() %>%
    paste(abbreviate(sheet, 6), abbreviate(action, 6), .) %>%
    str_pad(max(nchar(.)), side = "right")
  format(ret, justify = "right")
}

#' @export
vec_ptype_abbr.command_block_rcrd <- function(x) {
  "cmdblk"
}

#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.command_block_rcrd <- function(x, ...) {
  out <- format(x)
  pillar::new_pillar_shaft_simple(out, align = "right", min_width = 24)
}

#' @export
print.command_blocks <- function(x, ...) {
  print(command_block_rcrd(x), ...)
}
