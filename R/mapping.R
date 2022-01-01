#' Mapping class
#'
#'
#' @description The class \code{Mapping} can be used to apply the changes
#'   specified in the command blocks of an Excel mapping file to a (labelled)
#'   dataframe.
#'
#' @field dat (filepath to pass to \code{haven::read_sav()} to read in the)
#'   labelled dataframe to apply the mapping on.
#' @field mapping_file filepath of the Excel mapping file
#' @field cmd R list structure containing the processed command block
#'   information of the Excel mapping file.
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
#' # The spss_file path was read into a dataframe in the "dat" field of the mapping object:
#' mapping$dat
#'
#' # Apply the command blocks to the dataset:
#' mapping$modify_data()
#'
#' # Access the modified dataframe:
#' mapping$dat_mod
#'
#' # To write it back to an SPSS file, you could do:
#' # haven::write_sav(mapping$dat_mod, "path/to/your/file.sav")
Mapping <- R6::R6Class(
  "Mapping",
  public = list(
     dat = NULL,
     mapping_file = NULL,
     cmd = list(),
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
       process_command_blocks(self)
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

       apply_command_blocks(self$cmd$command_blocks, self)

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
  self$params$error_list <- vector("character", length(self$cmd$command_blocks))

  purrr::walk(self$cmd$command_blocks, apply_command_block_safe, self)

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
# as in self$cmd$df_cmd_raw instead of self$cmd$command_blocks:
add_error_list_to_command_blocks <- function(self) {
  command_blocks <- self$cmd$command_blocks
  error_list <- self$params$error_list
  command_blocks_mod <- purrr::map2(
    self$cmd$command_blocks,
    self$params$error_list,
    ~{.x$error = .y; .x}
  )
  class(command_blocks_mod) <- class(command_blocks)
  self$cmd$command_blocks <- command_blocks_mod
  invisible(self)
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
