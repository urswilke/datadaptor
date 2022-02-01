#' Mapping class
#'
#'
#' @description The class \code{Mapping} can be used to apply the changes
#'   specified in the command blocks of an Excel mapping file to a (labelled)
#'   dataframe.
#'
#'   The information of the Excel mapping file is processed in the list elements
#'   of the cmd field of the mapping object.
#'
#' @field dat (filepath to pass to \code{haven::read_sav()} to read in the)
#'   labelled dataframe to apply the mapping on.
#' @field mapping_file filepath of the Excel mapping file
#' @field cmd_tbl Dataframe with the command block information
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
#' # The Excel mapping file is translated to a `command_blocks()` object.
#' # It contains the processed information in a list structure that has
#' # its own print method.
#' # You can access it with
#' mapping$cmd_tbl$command_blocks
#'
#' # Apply the command blocks to the dataset:
#' mapping$modify_data()
#'
#' # Access the modified dataframe:
#' mapping$dat_mod
#'
#' # To write it back to an SPSS file, you could do:
#' # mapping$save("path/to/your/file.sav")
#' # or with haven (used under the hood by `save()`):
#' # haven::write_sav(mapping$dat_mod, "path/to/your/file.sav")
Mapping <- R6::R6Class(
  "Mapping",
  public = list(
    dat = NULL,
    mapping_file = NULL,
    cmd_tbl = data.frame(),
    cmd = list(),
    dat_mod = NULL,
    params = NULL,
    #' @description Initialize a Mapping object
    #'
    #' @param dat Dataframe to apply the mapping on.
    #' @param mapping_file Path to the Excel mapping file.
    #' @param ... Arguments passed to gen_mapping_params()
    initialize = function(dat = NULL,
                          mapping_file = NULL,
                          ...) {
      self$dat <- initialize_dat(self, dat)

      self$mapping_file <- mapping_file
      self$params <- gen_mapping_params(self$mapping_file, dots_args = tibble::lst(...), ...)
      if (!is.null(mapping_file)) {
        self$prep_cmd_tbl()
      }
    },
    #' @description Process all command blocks of the Excel mapping file to R. The command
    #'   blocks of the Excel mapping file are translated to the `command_blocks()` field
    #'   \code{self$cmd_tbl$command_blocks} field of the \code{Mapping} object.
    #'
    #' @param translate_xlsm For internal use
    prep_cmd_tbl = function(translate_xlsm = FALSE) {
      # self$params$translate_xlsm <- translate_xlsm
      # self$params <- add_configr_params(self)
      process_command_blocks(self)

      invisible(self)
    },
    #' @description Run all command blocks of the mapping file. The command
    #'   blocks of the Excel mapping file are translated to the `command_blocks()` field
    #'   \code{self$cmd_tbl$command_blocks} field of the \code{Mapping} object.
    #'
    #'   The internally called `apply_command_blocks()` method depends on the
    #'   value of `self$params$error_out` subclass. This subclass decides
    #'   whether to interrupt code execution in case of an error in one of the
    #'   command blocks (for `"unsafe"`), or not (for the subclass `"safe"`).
    #'
    #'
    #'   `apply_command_blocks()` then walks through the list of
    #'   `"command_block"` objects in `"command_blocks"` and applies each of them to
    #'   the data in the field `"dat_mod"` according to their subclass methods
    #'   of `apply_command()`.
    #' @param reset whether to apply the modifications to the input data (field
    #'   \code{dat}) or whether to keep previous modifications (only relevant
    #'   when applying \code{modify_data()} multiple times).
    #' @param command_blocks The \code{"command_blocks"} object results of the
    #'   processing of the Excel mapping file.
    #' @examples
    #' # Create a Mapping object from the files provided by the package:
    #' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
    #' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
    #' m <- Mapping$new(spss_file, mapping_file)
    #'
    #' # The method applies the modifications specified in a command_blocks object
    #' m$modify_data(command_blocks = m$cmd_tbl$command_blocks)
    #' m$dat_mod
    modify_data = function(reset = TRUE,
                           command_blocks = self$cmd_tbl$command_blocks) {
      if (reset == TRUE) {
        self$dat_mod <- self$dat
      }

      apply_command_blocks(command_blocks, self)

      invisible(self)
    },
    #' @description Save the modified data to a file
    #'
    #' The data can be exported to the file formats of Stata & SPSS. The Excel
    #' export removes variable & value labels.
    #'
    #' @param ... arguments passed to `save_mapping()`
    save = function(...) {
      save_mapping(self, ...)
      invisible(self)
    }
  )
)
#' Save the modified data of a mapping to a file
#'
#' The data can be exported to the file formats of Stata & SPSS. The Excel
#' export removes variable & value labels. Rmarkdown filetypes ("Rmd") can
#' be used to setup a python session with the data
#'
#' @param mapping `Mappjng` object
#' @param path `character()` vector or `NULL`. If `NULL` (the default) it
#'   will write the file to the path in `self$params$save_path` with
#'   the file `name`(s) & `filetype`(s) specified.
#' @param show Whether to directly open the file (needs the according
#'   software installed and setup to open its filetype).
#' @param name `character()` vector containing all the filenames to be
#' written. Needs to be of length 1 or the same length as `filetype`. Is
#' overwritten, by `path` if not `NULL`.
#' @param filetype `character()` vector containing all the filetypes to be
#'   written. Is overwritten, by `path` if not `NULL`.
#' @param ... used to pass arguments from `Mapping$save(...)`
#' @export
#' @examples
#' \dontrun{
#' # Create a Mapping object from the files provided by the package:
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' m <- Mapping$new(spss_file, mapping_file)
#'
#' # The method applies the modifications specified in a command_blocks object
#' m$modify_data(command_blocks = m$cmd_tbl$command_blocks)
#' m$save("stata_data.dta", show = TRUE)
#' }
save_mapping <- function(mapping, path = NULL, show = FALSE, name = "dat", filetype = "sav", ...) {
  if (is.null(path)) {
    path <- paste0(mapping$params$save_path, "/", name, ".", filetype)
  } else {
    filetype <- stringr::str_remove(path, ".*\\.")
  }
  raw <- tidyr::tibble(path, name, filetype, show)
  # add a sav file when there is an Rmd(that will import the sav):
  df <- raw %>%
    dplyr::bind_rows(raw %>%
                dplyr::filter(filetype == "Rmd") %>%
                dplyr::mutate(path = stringr::str_replace(path, "\\.Rmd$", ".sav"), filetype = "sav"),
              .
    ) %>%
    dplyr::distinct() %>%
    # For Rmd the result is a html:
    dplyr::mutate(res_path = stringr::str_replace(path, "\\.Rmd$", ".html"))
  purrr::walk2(df$path, df$filetype, ~ save_type(mapping$dat_mod, .x, .y))

  df$res_path[df$show] %>% purrr::walk(utils::browseURL)
}


save_type <- function(df, path, filetype) {
  switch (filetype,
          "sav"  = haven::write_sav(df, path),
          "dta"  = haven::write_dta(df, path),
          "xlsx" = save_xlsx(df, path),
          "Rmd"  = render_python_rmd(path),
          stop("unknown filetype")
  )
}
save_xlsx <- function(df, path) {
  df %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), tablab::strip_attributes)) %>%
    writexl::write_xlsx(path)
}
render_python_rmd <- function(path) {
  params_for_py <- list(sav_file = stringr::str_replace(path, "\\.Rmd", ".sav"))
  template_file <- system.file(
    "rmarkdown", "templates", "python-debbuging",
    "skeleton", "debug_skeleton.Rmd",
    package = "datenanpassr"
  )
  fs::file_copy(template_file, path, overwrite = TRUE)
  rmarkdown::render(path, params = params_for_py)
}


#' @param command_blocks object generated by `command_blocks()`
#' @export
#' @rdname command_blocks
apply_command_blocks <- function(command_blocks, self) {
  UseMethod("apply_command_blocks")
}

#' @export
#' @rdname command_blocks
apply_command_blocks.unsafe <- function(command_blocks, self) {
  purrr::walk(command_blocks, apply_command_block_unsafe, self)
}
apply_command_block_unsafe <- function(cdb, self) {
  apply_command(cdb, self)
  invisible(self)
}

#' @export
#' @rdname command_blocks
apply_command_blocks.safe <- function(command_blocks, self) {
  self$params$cmd_index <- 0
  self$params$error_list <- vector("character", length(self$cmd_tbl$command_blocks))

  purrr::walk(self$cmd_tbl$command_blocks, apply_command_block_safe, self)

  add_error_list_to_command_blocks(self)
}
apply_command_block_safe <- function(cdb, self) {
  cmd_index <- self$params$cmd_index + 1
  self$params$cmd_index <- cmd_index
  tryCatch(
    {
      err_msg <- NA_character_
      apply_command(cdb, self)
    },
    error = function(e) {
      if (self$params$debug) {
        browser()
        debugonce(apply_command)
        apply_command(cdb, self)
      }

      err_msg <- geterrmessage()[1]
      self$params$error_list[cmd_index] <- err_msg
      message(
        paste(
          "Error in command",
          cmd_index,
          ": ",
          err_msg
        )
      )
    }
  )

  invisible(self)
}


add_error_list_to_command_blocks <- function(self) {
  error_list <- self$params$error_list
  self$cmd_tbl$error <- error_list
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



#' Mapping parameters
#'
#' Generate list of named elements with mapping parameters. The argument values
#' are the below default values, then overwritten if passed by the `...` dots,
#' and then overwritten by the Excel file. If `override_excel = FALSE` the
#' Excel parameters will prevail, and otherwise overwritten by the dots.
#'
#' @param mapping_file Path of the Excel mapping file
#' @param excel_params Params parameters read from Excel file; see `extract_excel_params()`.
#' @param id_var character string of the id variable name in the dataset.
#' @param na_to_filter if TRUE (the default), NA values ("missing" in SPSS) are transformed with.
#'   `apply_command.cmd_recna_xcpt()` in the first command block.
#' @param error_out character string. Either "safe" or "unsafe" (the default).
#'   Whether to continue executing when a command block fails, or to error out.
#'   Adds a column "error" to the mapping's command table `mapping$cmd_tbl`.
#' @param translate_xlsm for internal use
#' @param validate whether to validate the parsed arguments of the command blocks from the Excel file.
#' @param dyn_validate whether to validate expressions when running (highly experimental).
#' @param debug whether to enter in debug mode when an error occurs. Automatically sets `error_out = "safe"`.
#' @param save_path filepath where to save files.
#' @param override_excel should arguments passed with the `...` dots when initializing overwrite those
#'   from the Excel file? Defaults to `FALSE`.
#' @param expr_eval_env The environment where expressions are evaluated. See `?safer_env`.
#' @param lab_before_var_sheet Whether to apply the "Label" sheet before the "Variables" sheet. Defaults to `TRUE`.
#' @param miss_rec_lab Label given if `na_to_filter = TRUE`.
#' @param miss_rec_val Replace value if `na_to_filter = TRUE`.
#' @param not_miss_to_filter_vars Space separated character string of variable names spared out
#'   for `apply_command.cmd_recna_xcpt()`.
#' @param dots_args for internal use.
#' @param ... used to pass arguments from `Mapping$new(...)`
#'
#' @return
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#'
#' gen_mapping_params(mapping_file)
gen_mapping_params <- function(
  mapping_file = NULL,
  excel_params = extract_excel_params(mapping_file),
  id_var = NULL,
  na_to_filter = TRUE,
  error_out = "unsafe",
  translate_xlsm = FALSE,
  validate = TRUE,
  dyn_validate = TRUE,
  debug = FALSE,
  save_path = tempdir(),
  override_excel = FALSE,
  expr_eval_env = safer_env,
  lab_before_var_sheet = "yes",
  miss_rec_lab = "FILTER",
  miss_rec_val = -2,
  not_miss_to_filter_vars = NA_character_,
  # Needed for developing...:
  # These only need to interest you if you want to override params that
  # already were defined in the Excel file already (see arg `override_excel`):
  dots_args,
  ...

) {
  if (is.null(id_var) & is.null(excel_params)) {
    stop(
      'You need to pass a valid id variable name character string in your dataset\n',
      'for instance, ',
      'id_var = "ID_VARIABLE_NAME"\n',
      'or you can define this string with a named region "R_id_var" in the Excel mapping file.')
  }

  p <- tibble::lst(
    mapping_file,
    excel_params,
    id_var,
    na_to_filter,
    error_out,
    translate_xlsm,
    validate,
    dyn_validate,
    debug,
    save_path,
    override_excel,
    expr_eval_env,
    lab_before_var_sheet,
    miss_rec_lab,
    miss_rec_val,
    not_miss_to_filter_vars,
    ...
  )
  # make sure to enter debug mode, when any of these is set to true:
  if (debug) {
    p$error_out <- "safe"
  }

  if (!is.null(p$excel_params)) {
    p[names(p$excel_params)] <- p$excel_params
  }
  if (override_excel) {
    p[names(dots_args)] <- dots_args
  }
  p
}
