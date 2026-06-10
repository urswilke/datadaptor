#' @export
read_sheets <- function(self) {
  UseMethod("read_sheets", self$mapping_file)
}
#' @export
read_sheets.list <- function(self) {
  self$mapping_file
}
#' @export
read_sheets.default <- function(self) {
  sheet_cats <- gen_sheet_cats(self)
  map2(
    sheet_cats$sheet |>
      set_names(),
    sheet_cats$sheet_type,
    ~ gen_sheet_data_raw(self, .y, .x),
    .id = "sheet"
  )
}
gen_sheet_cats <- function(self) {
  sheets <- get_sheets(self)

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if (
    self$opts$da$lab_before_var_sheet == "yes" &
    "Variables" %in% sheets &
    "Label" %in% sheets
  ) {
    sheets <- switch_sheets_vars_label(sheets)
  }

  sheet_cats <- tab_sheet_types(sheets)
  sheet_cats
}
#' @export
get_sheets <- function(mapping) {
  UseMethod("get_sheets", mapping$mapping_file)
}
#' @export
get_sheets.excel <- function(mapping) {
  wb_get_sheet_names(mapping$wb)
}
switch_sheets_vars_label <- function(sheets) {
  var_index <- which(sheets == "Variables")
  lab_index <- which(sheets == "Label")
  sheets[var_index] <- "Label"
  sheets[lab_index] <- "Variables"
  sheets
}
tab_sheet_types <- function(sheets) {
  sheet_types <- c("^Variables", "^Label", "^Verbatims", "^Free")

  # vector of sheets with names defined by types:
  sheet_cats <- map(
    sheets,
    ~ str_detect(.x, sheet_types)
  ) |>
    map(
      ~ sheet_types[.x] |>
        str_remove("\\^")
    ) |>
    set_names(sheets)
  # remove sheets not in sheet types list:
  sheet_cats <- sheet_cats[lengths(sheet_cats) > 0]
  sheet_cats |>
    map_chr(~.x) |>
    enframe("sheet", "sheet_type")
}
gen_sheet_data_raw <- function(self, sheet_cat, sheet_name) {
  switch(sheet_cat,
    "Variables" = read_variables_sheet_raw(sheet = sheet_name, mapping = self),
    "Label"     = read_label_sheet_raw(sheet = sheet_name, mapping = self),
    "Free"      = mapp_free_sheet_cmd_table_raw(sheet = sheet_name, mapping = self),
    "Verbatims" = parse_verbatim_data_raw(sheet = sheet_name, verbatim_file = extract_verbatim_file_name(sheet_name, self), mapping = self)
  )
}


# gen_sheet_cmd_tbls() ------------------------------------------

gen_sheet_cmd_tbls <- function(self) {
  sheet_cats <- names(self$cmd$sheet_data_raw) |>
    tab_sheet_types()

  sheet_command_tables_raw <- map2(
    sheet_cats$sheet |>
      set_names(),
    sheet_cats$sheet_type,
    ~ generate_sheet_cmd_table(self, .y, .x)
  )

  if (self$opts$da$na_to_filter == TRUE) {
    sheet_command_tables_raw <- append(
      list(Config = generate_rec_na_cmd_table(self)),
      sheet_command_tables_raw
    )
  }
  sheet_command_tables_raw
}
generate_sheet_cmd_table <- function(self, sheet_cat, sheet_name) {
  res <- switch(sheet_cat,
    "Variables" = mapp_var_sheet_cmd_table(self, sheet = sheet_name),
    "Label"     = mapp_vallab_sheet_cmd_table(self, sheet = sheet_name),
    "Free"      = mapp_free_sheet_cmd_table(self, sheet = sheet_name),
    "Verbatims" = mapp_verbatim_sheet_cmd_tbl(self, sheet = sheet_name)
  )
  if (is.null(res)) {
    return(NULL)
  }
  res |>
    rename(raw = "data")
}
generate_rec_na_cmd_table <- function(self) {
  params <- self$opts$da
  vars_to_exclude_na_to_filter <- c(
    params$not_miss_to_filter_vars |>
      str_split("[, ;]+") |>
      unlist(),
    self$opts$da$id_var
  )
  tibble(
    sheet = "Config",
    action = "#RECNA",
    row = NA_character_,
    new_var = NA_character_,
    raw = list(
      list(
        xs = vars_to_exclude_na_to_filter,
        replace_val = params$miss_rec_val,
        replace_label = params$miss_rec_lab
      )
    )
  )
}



# gen_df_cmd_raw() -------------------------------------------------

gen_df_cmd_raw <- function(self) {
  bind_rows(
    self$cmd$sheet_command_tables_raw,
    .id = "sheet"
  )
}





#' Generate an object inheriting from `"command_block"`
#'
#' @param cdb row of command table
#'
#' @noRd
#' @examples
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
#' m$cmd$df_cmd_raw[10, ] |> command_block()
#' # command_block() detects the subclass. So this is equivalent to:
#' m$cmd$df_cmd_raw[10, ] |> new_command_block(subclass = "cmd_newlab")
command_block <- function(cdb) {
  subclass <- match_command_block_class(cdb$action)

  # hopefully preliminary method to use new apply_command.cmd_verbatim_custom():
  if (subclass == "cmd_verbatim" && cdb$raw[[1]]$EFA1MCG2MDG3 == "mdg_custom") {
    subclass <- c("cmd_verbatim_custom", subclass)
  }
  new_command_block(cdb, subclass = subclass)
}

match_command_block_class <- function(keyword) {
  command_block_row <- datadaptor::command_block_classes$keyword == keyword
  if (sum(command_block_row) == 0) {
    stop(
      paste0(
        "command block '", keyword, "' doesn't exist. ",
        "See the package dataset `datadaptor::command_block_classes` for allowed ones."
      )
    )
  }
  datadaptor::command_block_classes[["command_block"]][command_block_row]
}


#' @noRd
#' @param ... further arguments passed to constructor
#' @param subclass character vector containing the subclass of the object to construct
new_command_block <- function(cdb, ..., subclass = character()) {
  cdb <- structure(
    cdb,
    ...,
    class = c(subclass, "command_block")
  )

  # create temporary object of the `raw` data field with the same class as the
  # command block:
  raw_data <- structure(
    cdb$raw[[1]],
    class = subclass
  )
  cdb$args <- parse_command_args(raw_data)
  cdb
}


# gen_command_blocks() --------------------------------------------------------

#' gen_command_blocks objects
#'
#' @param self `Mapping` object
#' @details
#'   `gen_command_blocks()` generates an object of class `command_blocks` and of subclass
#' `self$opts$da$error_out`.
#'
#'   `apply_command_blocks()` applies `"command_blocks"` object to a mapping object.
#'
#'   The `"command_blocks"` objects is a list of multiple `"command_block"`
#'   elements, that are applied to the mapping with `Mapping$modify_data()`
#'   using the `apply_command()` method of their subclass.
#'
#' @noRd
#'
#' @examples
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
#' gen_command_blocks(m)
#' # This object was automatically generated when m was created.
#' # you can access it with:
#' # m$cmd$command_blocks
#' class(m$cmd$command_blocks)
gen_command_blocks <- function(self) {
  df_cmd_raw <- self$cmd$df_cmd_raw
  cdbs <- df_cmd_raw |>
    split(seq_len(nrow(df_cmd_raw))) |>
    unname() |>
    lapply(command_block)

  subclass <- self$opts$da$error_out
  new_command_blocks(cdbs, subclass = subclass)
}

new_command_blocks <- function(command_blocks, ..., subclass = character()) {
  class(command_blocks) <- c(subclass, "command_blocks", "list")

  command_blocks
}


# gen_command_table() -----------------------------------------------------

gen_command_table <- function(self) {
  self$cmd$df_cmd_raw |>
    mutate(
      command_blocks = self$cmd$command_blocks
    )
}
