

#' Mapping class
#'
#'
#' @description The class \code{Mapping} can be used to apply the changes specified in the command blocks of an Excel mapping file to a (labelled) dataframe.
#'
#' @field dat (filepath to pass to \code{haven::read_sav()} to read in the) labelled dataframe to apply the mapping on.
#' @field mapping_file filepath of the Excel mapping file
#' @field dat_mod modified dataframe
#' @field params Parameter list object
#' @export
#'
#' @examples
#' # Create a Mapping object from the files provided by the package:
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' mapping <- Mapping$new(spss_file, mapping_file)
#'
#' # Generate command blocks:
#' mapping$gen_command_table_raw()
#' # Apply command blocks to dataset specified by spss_file:
#' mapping$modify_data()
#' # Access the modified dataframe:
#' mapping$dat_mod
#' # To write it back to an SPSS file, you could do:
#' # haven::write_sav(mapping$dat_mod, "path/to/your/file.sav")
Mapping <- R6::R6Class(
  "Mapping",
  public = list(
     dat = NULL,
     mapping_file = NULL,
     dat_mod = NULL,
     params = NULL,
     #' @description Initialize a Mapping object
     #'
     #' @param dat Dataframe to apply the mapping on.
     #' @param mapping_file Path to the Excel mapping file.
     initialize = function(
       dat = NULL,
       mapping_file
     ) {
       self$dat <- initialize_dat(self, dat)

       self$mapping_file <- mapping_file
       self$params <- load_configr_params(self)
       self$params$df_cmd_raw <- gen_command_table(self)
       self$params$command_blocks_raw <- gen_command_blocks_raw(self)
       self$params$command_blocks <- gen_command_blocks(self)
     },
     #' @description Run all command blocks of the mapping file. The command
     #'   blocks of the Excel mapping file are translated to the field
     #'   \code{$params$command_blocks} field of the \code{Mapping} object.
     #' @param reset whether to apply the modifications to the input data (field
     #'   \code{dat}) or whether to keep previous modifications (only relevant
     #'   when applying the \code{modify_data()} multiple times).
     modify_data = function(reset = TRUE) {
       if (reset == TRUE) {
         self$dat_mod <- self$dat
       }

       apply_command_blocks(self$params$command_blocks, self)

       invisible(self)
     }
  )
)
apply_command_blocks <- function(command_blocks, self) {
  UseMethod("apply_command_blocks")
}

apply_command_blocks.unsafe <- function(command_blocks, self) {
  purrr::walk(command_blocks, apply_command_block_unsafe, self)
}
apply_command_block_unsafe <- function(x, self) {
  apply_command(x, self)
  invisible(self)
}

apply_command_blocks.safe <- function(command_blocks, self) {
  self$params$cmd_index <- 0
  self$params$error_list <- vector("character", length(self$params$command_blocks))

  purrr::walk(self$params$command_blocks, apply_command_block_safe, self)

  add_error_list_to_command_blocks(self)

}
apply_command_block_safe <- function(x, self) {
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
}






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

  self$params$df_cmd_raw %>%
    dplyr::rowwise() %>%
    dplyr::transmute(cmd = list(command_block_factory(dplyr::cur_data()))) %>%
    dplyr::pull()
}

new_command_blocks <- function(command_blocks, ..., subclass = character()) {
  class(command_blocks) <- c(subclass, "command_blocks", "list")

  command_blocks
}

gen_command_blocks <- function(self) {
  try_catch_subclass <- ifelse(self$params$try_catch, "safe", "unsafe")
  purrr::map(self$params$command_blocks_raw, parse_command_args) %>%
    new_command_blocks(subclass = try_catch_subclass)
}

#' @export
`[.command_blocks` <- function(x, i) {
  new_command_blocks(NextMethod(x))
}



initialize_dat <- function(self, dat) {
  if (is.null(dat)) {
    self$dat <- NULL
    return(NULL)
  }
  if (is.character(dat)) {
    dat <- haven::read_sav(dat)
  }
  dat
}





load_configr_params <- function(self) {
  params <- list(
    na_to_filter = TRUE,
    try_catch = FALSE,
    mapping_file_attrs = list()
  )
  l_configr <- get_configr_args_list(self$mapping_file)
  id_var <- l_configr$id_var

  params$mapping_file_attrs <- l_configr
  params$id_var <- id_var
  params
}
