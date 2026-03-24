# from here: https://stackoverflow.com/a/64105860
#' @import R6
NULL

#' Mapping class
#'
#'
#' @description The `R6::R6Class()` \code{Mapping} can be used to apply the changes
#'   specified in the command blocks of an Excel mapping file to a (labelled)
#'   dataframe.
#'
#'   The information of the Excel mapping file results in the `cmd_tbl`
#'   dataframe field of the mapping object. This dataframe has a column
#'   `command_blocks` which is applied to the data in the `dat` field by the
#'   method `modify_data()` and then results in the `dat_mod` field.
#'
#' @field dat (filepath to pass to \code{haven::read_sav()} to read in the)
#'   labelled dataframe to apply the mapping on.
#' @field mapping_file Mapping file document (see `mapping_type`). The class of
#'   this string will be set to "mapping_type".
#' @field mapping_type String specifying the mapping type. Either "excel"
#'   or "list". If not specified, when initializing it is auto-determined:
#'   \itemize{
#'     \item{"list": If `mapping_file` is a list object.}
#'     \item{"excel": If the `mapping_file` path ends on "xlsm" or "xlsx".}
#'   }
#' @field cmd_tbl Dataframe with the command block information
#' @field cmd R list structure containing the processed command block
#'   information of the Excel mapping file. `r lifecycle::badge('experimental')`
#' @field dat_mod modified dataframe
#' @field opts Parameter list object (in `opts$da`)
#' @field wb For an excel mapping, the openxlsx2 workbook object,
#'   otherwise `NULL`.
#' @field ditw This is the "dust in the wind" list object field
#'   that stores data that didn't make it into their own field.
#'   For developers only!
#'   For reproducible code you should NEVER rely on this field
#'   as it might be subject to change without any warning.
#' @export
#'
#' @examples
#' # Create a Mapping object from the files provided by the package:
#' mapping_file <- system.file(
#'   "extdata",
#'   "mapping.xlsx",
#'   package = "datadaptor"
#' )
#' spss_file <- system.file(
#'   "extdata",
#'   "mtcars_labelled.sav",
#'   package = "datadaptor"
#' )
#' mapping <- Mapping$new(spss_file, mapping_file)
#'
#' # The spss_file path was read into a dataframe in the "dat" field of the
#' # mapping object:
#' mapping$dat
#'
#' # The Excel mapping file is translated to a `command_blocks()` object.
#' # It contains the processed information in a list structure that has
#' # its own print method.
#' # You can access it with
#' \dontrun{
#' mapping$cmd_tbl$command_blocks
#' }
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
Mapping <- R6Class(
  "Mapping",
  public = list(
    dat = NULL,
    mapping_file = NULL,
    mapping_type = NULL,
    cmd_tbl = NULL,
    cmd = list(),
    dat_mod = NULL,
    opts = list(da = NULL),
    wb = NULL,
    ditw = list(da = NULL),
    #' @description Initialize a Mapping object
    #'
    #' @param dat Dataframe to apply the mapping on.
    #' @param mapping_file Path to the Excel mapping file.
    #' @param mapping_type String specifying the mapping type.
    #'   Either "excel" or "list".
    #' @param process_sheets (default TRUE)
    #'   allows (process_sheets = FALSE) to postpone the execution
    #'   of the commands in the Excel mapping file to the modify_data() method
    #' @param ... Arguments passed to the `Mapping$set_options()` method
    #'   which will populate  the `Mapping$opts$da` field of the object.
    #' @return A new `Mapping` object.
    initialize = function(dat = NULL,
                          mapping_file = NULL,
                          mapping_type = NULL,
                          process_sheets = TRUE,
                          ...) {
      self$mapping_file <- mapping_file
      self$mapping_type <- mapping_type

      set_mapping_type(self)
      set_workbook(self)

      self$set_options(...)

      self$dat <- self$read_data(dat)

      if (process_sheets) {
        self$process_sheet_commands()
      }
    },
    #' @description Parse the sheet data of the mapping file
    #'   and derive the command blocks included.
    #' Automatically run in the constructor
    #'   if `process_sheets = TRUE` (the default).
    #' Automatically run by the `modify_data()` method if not done before.
    process_sheet_commands = function() {
      self$cmd$sheet_data_raw <- read_sheets(self)
      self$cmd$sheet_command_tables_raw <- gen_sheet_cmd_tbls(self)
      self$cmd$df_cmd_raw <- gen_df_cmd_raw(self)
      self$cmd$command_blocks <- gen_command_blocks(self)
      self$cmd_tbl <- gen_command_table(self)

      if (self$opts$da$write_mapping_to_txt) {
        write_mapping_txt(self)
      }
    },
    #' @description Run all command blocks of the mapping file. The commands in
    #'   the argument `command_blocks` (defaults to the Mapping's
    #'   `cmd_tbl$command_blocks` field) successively are applied to the data in
    #'   the field `"dat_mod"` according to their subclass methods of
    #'   `apply_command()`.
    #' @param reset whether to apply the modifications to the input data (field
    #'   \code{dat}) or whether to keep previous modifications (only relevant
    #'   when applying \code{modify_data()} multiple times).
    #' @param command_blocks The \code{"command_blocks"} object results of the
    #'   processing of the Excel mapping file.
    modify_data = function(reset = TRUE,
                           command_blocks = self$cmd_tbl$command_blocks) {
      if (is.null(self$cmd_tbl)) {
        self$process_sheet_commands()
      }
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
    #' @param path `character()` string or `NULL`. If `NULL` (the default) it
    #'   will write the file to the path in `self$opts$da$save_path` with
    #'   the file `name` & `filetype`.
    #' @param show Whether to directly open the file (needs the according
    #'   software installed and setup to open its `filetype`).
    #' @param name `character()` string containing the file name to be written.
    #'    Is overwritten, by `path` if not `NULL`.
    #' @param filetype `character()` string containing the file type to be
    #'   written. Is overwritten, by `path` if not `NULL`.
    #' @param ... Passed to methods.
    #' @examples
    #' \dontrun{
    #' # Create a Mapping object from the files provided by the package:
    #' mapping_file <- system.file(
    #'   "extdata",
    #'   "mapping.xlsx",
    #'   package = "datadaptor"
    #' )
    #' spss_file <- system.file(
    #'   "extdata",
    #'   "mtcars_labelled.sav",
    #'   package = "datadaptor"
    #' )
    #' m <- Mapping$new(spss_file, mapping_file)
    #'
    #' # The method applies the modifications specified in a command_blocks object
    #' m$modify_data(command_blocks = m$cmd_tbl$command_blocks)
    #' m$save("stata_data.dta", show = TRUE)
    #' }
    save = function(
      path = NULL,
      show = FALSE,
      name = "dat",
      filetype = "sav",
      ...
    ) {
      if (is.null(path)) {
        path <- paste0(self$opts$da$save_path, "/", name, ".", filetype)
      } else {
        filetype <- str_remove(path, ".*\\.")
      }
      save_type(self$dat_mod, path, filetype)

      if (show) browseURL(path)
      invisible(self)
    },
    #' @description Set / change options of the `Mapping` object
    #'
    #' The dots (`...`) can be passed here to change settings,
    #' or already when initializing the object with `Mapping$new(...)`
    #'
    #' Additionally to the dots you can also pass parameters
    #' from an Excel mapping file by using named regions starting with `"R_"`,
    #' for instance, `"R_id_var"` will become `"id_var"`.
    #' The complete set of arguments consists of he default values in `get_mapping_options()`
    #' overwritten by the above named regions of the  Excel file,
    #' and all this can be overwritten by the dots.
    #'
    #' The part of the arguments known to `get_mapping_options()` is written to the `opts$da` field,
    #' The rest is written to the `opts$dev` field.
    #'
    #'
    #'
    #' @param ... arguments passed to `get_mapping_options()`
    set_options = function(...) {
      excel_params <- private$get_named_region_params()
      # If specified in both, excel parameters will be overwritten by the dots:
      args <- excel_params |> modifyList(list(...))

      da <- use_known_args(get_mapping_options, args)
      dev <- args |> setdiff(da)

      self$opts <- tibble::lst(
        da,
        dev
      )
    },
    #' @description Read in dataset
    #'
    #' @param dat Dataset indentifier (see `?read_data_` helper function).
    #' @param ... Arguments passed to `read_data_()` helper function.
    read_data = function(dat, ...) {
      read_data_(dat, ...)
    }
  ),
  private = list(
    get_named_region_params = function() {
      extract_named_region_params(self)
    }
  )
)

determine_mapping_type <- function(self) {
  if (!is.null(self$mapping_type)) {
    return(self$mapping_type)
  }
  if (is.list(self$mapping_file)) {
    return("list")
  }
  file_ending <- self$mapping_file |>
    str_extract("(?<=\\.)([[:alnum:]]+)$")
  if (str_detect(file_ending, "^xls[xm]$")) {
    return("excel")
  }
  stop(
    "`mapping_type` couldn't be determined from `mapping_file` string.\n",
    "You can directly specify it when calling `Mapping$new(mapping_type = <SPECIFY-HERE>)`"
  )
}
set_mapping_type <- function(self) {
  self$mapping_type <- determine_mapping_type(self)
  class(self$mapping_file) <- self$mapping_type
}

save_type <- function(df, path, filetype) {
  switch(filetype,
    "sav"  = write_sav(df, path),
    "dta"  = write_dta(df, path),
    "xlsx" = save_xlsx(df, path),
    "qs2"  = {check_installed("qs2"); qs2::qs_save(df, path)},
    stop("unknown filetype")
  )

}
save_xlsx <- function(df, path) {
  df |>
    mutate(across(
      everything(),
      strip_attributes
    )) |>
    write_xlsx(path)
}


#' @param command_blocks object generated by `command_blocks()`
#' @noRd
apply_command_blocks <- function(command_blocks, self) {
  UseMethod("apply_command_blocks")
}

#' @noRd
apply_command_blocks.unsafe <- function(command_blocks, self) {
  walk(command_blocks, apply_command_block_unsafe, self)
}
apply_command_block_unsafe <- function(cdb, self) {
  args <- list(cdb = cdb, mapping = self) |> append(cdb$args)
  do.call(apply_command, args)
  invisible(self)
}

#' @noRd
apply_command_blocks.quiet <- apply_command_blocks.safe <- function(command_blocks, self) {
  self$opts$da$cmd_index <- 0
  self$opts$da$error_list <- vector(
    "character",
    length(self$cmd_tbl$command_blocks)
  )

  walk(self$cmd_tbl$command_blocks, apply_command_block_safe, self)

  add_error_list(self)
}

apply_command_block_safe <- function(cdb, self) {
  cmd_index <- self$opts$da$cmd_index + 1
  self$opts$da$cmd_index <- cmd_index
  suppressWarnings(
    tryCatch(
      withCallingHandlers(
        {
          args <- list(cdb = cdb, mapping = self) |> append(cdb$args)
          do.call(apply_command, args)
        },
        warning = function(w) {
          self$opts$da$error_list[cmd_index] <- paste0(
            self$opts$da$error_list[cmd_index],
            w
          )
          if (self$opts$da$error_out != "quiet") {
            message(
              paste(
                "Warning in command",
                cmd_index,
                ": ",
                w
              )
            )
          }
        }
      ),
      error = function(e) {
        if (self$opts$da$debug) {
          # probably this can't be tested:
          # nocov start
          browser()
          debugonce(apply_command)
          args <- list(cdb = cdb, mapping = self) |> append(cdb$args)
          do.call(apply_command, args)
          # nocov end
        }

        self$opts$da$error_list[cmd_index] <- paste0(
          e,
          self$opts$da$error_list[cmd_index]
        )

        if (self$opts$da$error_out != "quiet") {
          message(
            paste(
              "Error in command",
              cmd_index,
              ": ",
              e
            )
          )
        }
      }
    )
  )


  invisible(self)
}


add_error_list <- function(self) {
  error_list <- self$opts$da$error_list
  self$cmd_tbl$error <- error_list
  invisible(self)
}
#' Ingest data from data.frame or file path
#'
#' @param dat String. Either a path to an SPSS file, a data.frame, or `NULL`.
#' @param ... Arguments passed to methods.
#'
#' @return Returns `dat` (unchanged) in case of a data.frame,
#'  in case of a character string returns the data.frame resulting of
#'  `haven::read_sav(dat)`/`haven::read_dta(dat)`/`qs2::qs_read(dat)` or
#'  `openxlsx2::read_xls(x)` for excel files (depending on the file
#'  extension) or returns `NULL` in case of `NULL`.
#'
#' @export
read_data_ <- function(dat, ...) {
  if (is.null(dat)) {
    return(NULL)
  }
  UseMethod("read_data_")
}
#' @export
read_data_.data.frame <- function(
    dat,
    ...
) {
  dat
}
#' @export
read_data_.character <- function(
    dat,
    ...
) {
  filetype <- str_remove(dat, ".*\\.")
  df <- switch(filetype,
    "sav" = read_sav(dat),
    "dta" = read_dta(dat),
    "qs2" = {check_installed("qs2"); qs2::qs_read(dat)},
    "xlsx" = read_xlsx(dat) |> dplyr::mutate(across(where(is.logical), as.double)),
    "xls" = read_xls(dat) |> dplyr::mutate(across(where(is.logical), as.double)),
    stop("unknown filetype")
  )
  df
}

#' Mapping parameters
#'
#' @description `get_mapping_options()` is a helper function
#'   called by `Mapping$new(...)` or `Mapping$set_options(...)`
#'   to generate the parameters in the `opts$da` field of a Mapping object.
#'
#' @param id_var character string of the id variable name in the dataset.
#' @param error_out character string.
#'   Either "safe", "quiet" or "unsafe" (the default).
#'   Whether to continue executing when a command block fails
#'   ("safe" or "quiet"), or to error out ("unsafe").
#'   Adds a column "error" to the mapping's command table `mapping$cmd_tbl`.
#'   The difference between "safe" & "quiet" is
#'   whether to print errors & warnings to the command line
#'   while running `Mapping$modify_data()`.
#' @param debug whether to enter in debug mode when an error occurs.
#'   Automatically sets `error_out = "safe"`.
#' @param save_path filepath where to save files.
#' @param write_mapping_to_txt Whether to write the `Mapping`'s data to text
#'   files (for instance, in order to allow for git version control during the
#'   course of a project that evolves). Defaults to FALSE. Will probably be
#'   deprecated in the future.
#' @param expr_eval_env The environment where expressions are evaluated. See
#'   `?safer_env`.
#' @param lab_before_var_sheet Whether to apply the "Label" sheet before the
#'   "Variables" sheet. Defaults to `TRUE`.
#' @param miss_rec_lab Label given if `na_to_filter = TRUE`.
#' @param miss_rec_val Replace value if `na_to_filter = TRUE`.
#' @param na_to_filter if TRUE (the default), NA values ("missing" in SPSS) are
#'   transformed with. `apply_command.cmd_recna_xcpt()` in the first command
#'   block.
#' @param not_miss_to_filter_vars Space separated character string of variable
#'   names spared out for `apply_command.cmd_recna_xcpt()`.
#' @param verbose Defaults to `FALSE`;
#'   If `TRUE` will be more chatty about what's happening
#'   (Very preliminary! at the moment, only used in crosstabser).
#' @param ... used to pass arguments from `Mapping$new(...)`
#' @return list object (see examples)
#'
#' @export
#'
#' @examples
#' get_mapping_options()
get_mapping_options <- function(
    id_var = NULL,
    error_out = "unsafe",
    debug = FALSE,
    save_path = tempdir(),
    write_mapping_to_txt = FALSE,
    expr_eval_env = new.env(parent = baseenv()),
    lab_before_var_sheet = "yes",
    miss_rec_lab = "FILTER",
    miss_rec_val = -2,
    na_to_filter = TRUE,
    not_miss_to_filter_vars = NA_character_,
    verbose = FALSE,
    ...) {
  p <- lst(
    id_var,
    na_to_filter,
    error_out,
    debug,
    write_mapping_to_txt,
    save_path,
    expr_eval_env,
    lab_before_var_sheet,
    miss_rec_lab,
    miss_rec_val,
    not_miss_to_filter_vars,
    verbose,
    ...
  )
  if (debug) {
    p$error_out <- "safe"
  }

  p
}

set_workbook <- function(mapping) {
  UseMethod("set_workbook", mapping$mapping_file)
}
set_workbook.default <- function(mapping) {}
set_workbook.excel <- function(mapping) {
  mapping$wb <- wb_load(mapping$mapping_file)
}
