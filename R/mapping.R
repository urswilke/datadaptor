

#' @export
Mapping <- R6::R6Class(
  "Mapping",
  public = list(
     dat = NULL,
     mapping_file = NULL,
     dat_mod = NULL,
     params = NULL,
     initialize = function(
       dat = NULL,
       mapping_file
     ) {
       initialize_dat(self, dat)

       self$mapping_file = mapping_file
       set_default_parameters(self)
     },
     apply_cmd_s3 = function(x) {
       apply_command(x, self)
       invisible(self)
     },
     apply_cmd_s3_safe = function(x) {
       cmd_index <- self$params$cmd_index + 1
       self$params$cmd_index <- cmd_index
       tryCatch(
         {
           err_msg <- NA_character_
           apply_command(x, self)
         },
         error = function(e) {
           err_msg <- geterrmessage()[1]
           self$params$error_list[cmd_index] <- err_msg
           message(
             paste(
               "Error in command",
               cmd_index,
               ": ",
               err_msg)
           )
         }
       )

       invisible(self)
     },
     apply_all_s3_cmds = function() {
       gen_command_blocks_raw(self)
       gen_command_blocks(self)

       apply_command_method <- self$apply_cmd_s3
       if (self$params$try_catch) {
         apply_command_method <- self$apply_cmd_s3_safe
         self$params$cmd_index <- 0
         self$params$error_list <- vector("character", length(self$params$command_blocks))
       }

       purrr::walk(self$params$command_blocks, apply_command_method)
       if (self$params$try_catch) {
         add_error_list_to_command_blocks(self)
       }
       invisible(self)
     },
     gen_command_table_raw = function() {
       load_configr_params(self)
       gen_command_table_raw_(self)
       invisible(self)
     }
  )
)

# HACKY - would be easier to add to data.frame format
# as in self$params$df_cmd_raw instead of self$params$command_blocks:
add_error_list_to_command_blocks <- function(self) {
  command_blocks <- self$params$command_blocks
  error_list <- self$params$error_list
  command_blocks_mod <- purrr::map2(
    self$params$command_blocks,
    self$params$error_list,
    ~{.x$error = .y; .x}
  )
  class(command_blocks_mod) <- class(command_blocks)
  self$params$command_blocks <- command_blocks_mod
  invisible(self)
}

gen_command_blocks_raw <- function(self) {

  if (self$params$na_to_filter == TRUE) {
    self$params$df_cmd_raw <- dplyr::bind_rows(
      generate_rec_na_cmd_table(self),
      self$params$df_cmd_raw
    )
  }
  self$params$command_blocks_raw <- self$params$df_cmd_raw %>%
    dplyr::rowwise() %>%
    dplyr::transmute(cmd = list(command_block_factory(dplyr::cur_data()))) %>%
    dplyr::pull()
  invisible(self)
}

new_command_blocks <- function(command_blocks) {
  class(command_blocks) <- c("command_blocks", "list")

  command_blocks
}

gen_command_blocks <- function(self) {
  command_blocks <- purrr::map(self$params$command_blocks_raw, parse_command_args) %>%
    new_command_blocks()

  self$params$command_blocks <- command_blocks

  invisible(self)
}

#' @export
`[.command_blocks` <- function(x, i) {
  new_command_blocks(NextMethod(x))
}



initialize_dat <- function(self, dat) {
  if (is.null(dat)) {
    self$dat <- NULL
    return(invisible(self))
  }
  if (is.character(dat)) {
    dat <- haven::read_sav(dat)
  }
  self$dat <- dat
  self$dat_mod <- self$dat
  invisible(self)
}




set_default_parameters <- function(self) {
  self$params <- list(
    na_to_filter = TRUE,
    vectorized = FALSE,
    data = tibble::tibble(),
    try_catch = FALSE,
    add_r_command_colum = FALSE,
    rec_fun = purrr::reduce2,
    check_id_is_unique = TRUE,
    mapping_file_attrs = list()
  )
  invisible(self)
}

load_configr_params <- function(self) {
  l_configr <- get_configr_args_list(self$mapping_file)
  id_var <- l_configr$id_var

  self$params$mapping_file_attrs <- l_configr
  self$params$id_var <- id_var
  invisible(self)
}
