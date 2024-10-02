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
#' @field mapping_type String specifying the mapping type. Either "excel", "google"
#'   (for googlesheets), or "list". If not specified, when initializing it is
#'   auto-determined:
#'   \itemize{
#'     \item{"list": }{If `mapping_file` is a list object.}
#'     \item{"excel": }{If the `mapping_file` path ends on "xlsm" or "xlsx".}
#'     \item{"google": }{If `mapping_file` is another string, it is assumed that
#'       it is a valid `googlesheets4::as_sheets_id()`.}
#'   }
#' @field cmd_tbl Dataframe with the command block information
#' @field cmd R list structure containing the processed command block
#'   information of the Excel mapping file. `r lifecycle::badge('experimental')`
#' @field dat_mod modified dataframe
#' @field params Parameter list object
#' @field wb For an excel mapping, the openxlsx2 workbook object, otherwise `NULL`.
#' @export
#'
#' @examples
#' # Create a Mapping object from the files provided by the package:
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "mtcars_labelled.sav", package = "datenanpassr")
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
    params = NULL,
    wb = NULL,
    #' @description Initialize a Mapping object
    #'
    #' @param dat Dataframe to apply the mapping on.
    #' @param mapping_file Path to the Excel mapping file.
    #' @param mapping_type String specifying the mapping type. Either "excel", "google"
    #'   (for googlesheets), or "list".
    #' @param process_sheets (default TRUE) allows (process_sheets = FALSE) to postpone the execution of the commands in the Excel mapping file to the modify_data() method
    #' @param ... Arguments passed to gen_mapping_params() which will populate
    #'   the `params` field of the object.
    initialize = function(dat = NULL,
                          mapping_file = NULL,
                          mapping_type = NULL,
                          process_sheets = TRUE,
                          ...) {
      self$mapping_file <- mapping_file
      self$mapping_type <- mapping_type

      set_mapping_type(self)
      set_workbook(self$mapping_file, self)

      self$dat <- read_data(dat)

      self$params <- gen_mapping_params(self$mapping_file, wb = self$wb, ...)
      if (process_sheets) {
        self$process_sheet_commands()
      }
    },
    #' @description Parse the sheet data of the mapping file and derive the command blocks included.
    #' Automatically run in the constructor if `process_sheets = TRUE` (the default).
    #' Automatically run by the `modify_data()` method if not done before.
    process_sheet_commands = function() {
      self$cmd$sheet_data_raw <- read_sheets(self$mapping_file, self)
      self$cmd$sheet_command_tables_raw <- gen_sheet_cmd_tbls(self)
      self$cmd$df_cmd_raw <- gen_df_cmd_raw(self)
      self$cmd$command_blocks <- gen_command_blocks(self)
      self$cmd_tbl <- gen_command_table(self)

      if (self$params$write_mapping_to_txt) {
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

      if (self$params$lowercase_varnames) {
        attr(self$dat_mod, "original_varnames") <- names(self$dat)
        self$dat_mod <- self$dat_mod |> rename_with(tolower)
      }

      apply_command_blocks(command_blocks, self)

      if (self$params$lowercase_varnames) {
        self$dat_mod <- rename_vars_to_original_case(self$dat_mod)
      }
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
  if (is.character(self$mapping_file)) {
    return("google")
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
rename_vars_to_original_case <- function(df) {
  orig_names <- attr(df, "original_varnames")
  rename_vec <- tibble(orig_names) |>
    mutate(lowercase_names = tolower(orig_names)) |>
    inner_join(
      tibble(
        lowercase_names = names(df)
      ),
      by = "lowercase_names"
    ) |>
    deframe()
  df |> rename(!!rename_vec)
}
#' Save the modified data of a mapping to a file
#'
#' The data can be exported to the file formats of Stata & SPSS. The Excel
#' export removes variable & value labels. Rmarkdown filetypes ("Rmd").
#'
#' @param mapping `Mapping` object
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
#' @noRd
#' @examples
#' \dontrun{
#' # Create a Mapping object from the files provided by the package:
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "mtcars_labelled.sav", package = "datenanpassr")
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
    filetype <- str_remove(path, ".*\\.")
  }
  df <- tibble(path, name, filetype, show)
  walk2(df$path, df$filetype, ~ save_type(mapping$dat_mod, .x, .y))

  df$path[df$show] |> walk(browseURL)
}


save_type <- function(df, path, filetype) {
  switch (filetype,
    "sav"  = write_sav(df, path),
    "dta"  = write_dta(df, path),
    "xlsx" = save_xlsx(df, path),
    "qs"   = qsave(df, path),
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
apply_command_blocks.safe <- function(command_blocks, self) {
  self$params$cmd_index <- 0
  self$params$error_list <- vector(
    "character",
    length(self$cmd_tbl$command_blocks)
  )

  walk(self$cmd_tbl$command_blocks, apply_command_block_safe, self)

  add_error_list_to_command_blocks(self)
}
apply_command_block_safe <- function(cdb, self) {
  cmd_index <- self$params$cmd_index + 1
  self$params$cmd_index <- cmd_index
  tryCatch(
    withCallingHandlers(
    {
      args <- list(cdb = cdb, mapping = self) |> append(cdb$args)
      do.call(apply_command, args)
    },
    warning = function(w)
    {
      self$params$error_list[cmd_index] <- paste0(self$params$error_list[cmd_index], w)
    }),
    error = function(e) {
      if (self$params$debug) {
        # probably this can't be tested:
        # nocov start
        browser()
        debugonce(apply_command)
        args <- list(cdb = cdb, mapping = self) |> append(cdb$args)
        do.call(apply_command, args)
        # nocov end
      }


      message(
        paste(
          "Error in command",
          cmd_index,
          ": ",
          e
        )
      )
      self$params$error_list[cmd_index] <- paste0(self$params$error_list[cmd_index], e)
    }
  )


  invisible(self)
}


add_error_list_to_command_blocks <- function(self) {
  error_list <- self$params$error_list
  self$cmd_tbl$error <- error_list
  invisible(self)
}
#' Ingest data from data.frame or file path
#'
#' @param dat String. Either a path to an SPSS file, a data.frame, or `NULL`.
#'
#' @return Returns `dat` (unchanged) in case of a data.frame,
#'  in case of a character string returns the data.frame resulting of
#'  `haven::read_sav(dat)`/`haven::read_dta(dat)`/`qs::qread(dat)`
#'  (depending on the file extension)
#'  or returns `NULL` in case of `NULL`.
#'
#' @export
read_data <- function(dat) {
  if (is.null(dat)) {
    return(NULL)
  }
  UseMethod("read_data")
}
#' @export
read_data.data.frame <- function(dat) {
  dat
}
#' @export
read_data.character <- function(dat) {
  filetype <- str_remove(dat, ".*\\.")
  switch(filetype,
    "sav" = read_sav(dat),
    "dta" = read_dta(dat),
    "qs"  = qread(dat),
    stop("unknown filetype")
  )
}

#' Mapping parameters
#'
#' @description `gen_mapping_params()` is a helper function to generate the
#'   parameters in the `params` field when a Mapping object is constructed with
#'   `Mapping$new()`. It generates a list of named elements with mapping
#'   parameters. The argument values are the below default values, then
#'   overwritten if passed by the `...` dots, and then overwritten by the Excel
#'   file.
#'
#' @param mapping_file Path of the Excel mapping file. Alternatively, you can
#'   pass an R list object containing named dataframes that is in the shape of
#'   the `Mapping$cmd$sheet_data_raw` field (see section
#'   "Parse the sheets to R list objects" in
#'   `vignette("translating_command_blocks_to_R")`).
#' @param excel_params Params parameters read from Excel file; see
#'   `extract_named_region_params()`.
#' @param mapping_type String specifying the mapping type. Either "excel" or "google"
#'   (for googlesheets). Defaults to "excel".
#' @param id_var character string of the id variable name in the dataset.
#' @param error_out character string. Either "safe" or "unsafe" (the default).
#'   Whether to continue executing when a command block fails, or to error out.
#'   Adds a column "error" to the mapping's command table `mapping$cmd_tbl`.
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
#' @param lowercase_varnames Whether to transform all variable names to
#'   lowercase during data modification, and rename them back to their original
#'   case (if still existing) in the end.
#' @param wb For an excel mapping, the openxlsx2 workbook object, otherwise `NULL`.
#' @param database_dsn Defaults to `NULL`; Character string of the database dsn.
#'   Only used in crosstabser.
#' @param ... used to pass arguments from `Mapping$new(...)`
#' @return list object (see examples)
#'
#' @export
#'
#' @examples
#' # Only for documentation purposes:
#' # (`gen_mapping_params()` isn't supposed to be be called directly).
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' class(mapping_file) <- "excel"
#' wb <- openxlsx2::wb_load(mapping_file)
#'
#' gen_mapping_params(mapping_file, wb = wb)
gen_mapping_params <- function(
  mapping_file = NULL,
  mapping_type = "excel",
  excel_params = extract_named_region_params(mapping_file, wb),
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
  lowercase_varnames = FALSE,
  database_dsn = NULL,
  wb,
  ...

) {

  p <- lst(
    mapping_file,
    excel_params,
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
    lowercase_varnames,
    database_dsn,
    ...
  )
  if (debug) {
    p$error_out <- "safe"
  }

  if (!is.null(p$excel_params)) {
    p[names(p$excel_params)] <- p$excel_params
  }
  p
}

set_workbook <- function(mapping_file, mapping) {
  UseMethod("set_workbook")
}
set_workbook.default <- function(mapping_file, mapping) {}
set_workbook.excel <- function(mapping_file, mapping) {
  mapping$wb <- wb_load(mapping_file)
}
