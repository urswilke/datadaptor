process_command_blocks <- function(self) {
  self$cmd$sheet_cats <- gen_sheet_cats(self)

  if (self$params$refresh) {
    refresh_mapping(self)
  } else {
    self$cmd$sheet_data_raw <- gen_sheet_data_raw_list(self)
    self$cmd$df_cmd_raw <- gen_command_table_raw(self)
    self$cmd$command_blocks <- command_blocks(self)
    self$cmd_tbl <- gen_command_table(self)
  }

  if (self$params$write_mapping_to_txt) {
    write_mapping_txt(self)
  }
}
refresh_mapping <- function(self) {
  all_sheets <- readxl::excel_sheets(self$mapping_file)
  active_sheet_index <- openxlsx::loadWorkbook(self$mapping_file) %>% openxlsx::activeSheet()
  active_sheet_name <- all_sheets[active_sheet_index]
  sheet_data_raw_index <- which(self$cmd$sheet_cats$sheet == active_sheet_name)
  self$cmd$sheet_data_raw[[active_sheet_name]] <- gen_sheet_data_raw(self, self$cmd$sheet_cats$sheet_type[sheet_data_raw_index], self$cmd$sheet_cats$sheet[sheet_data_raw_index])
}

gen_command_table <- function(self) {
  self$cmd$df_cmd_raw %>%
    dplyr::mutate(
      command_blocks = self$cmd$command_blocks
    )
}
gen_command_table_raw <- function(self) {
  sheet_cats <- self$cmd$sheet_cats


  df_cmd_raw <- purrr::map2_dfr(
    sheet_cats$sheet %>%
      purrr::set_names(),
    sheet_cats$sheet_type,
    ~ generate_sheet_cmd_table(self, .y, .x),
    .id = "sheet"
  )

  if (self$params$na_to_filter == TRUE) {
    df_cmd_raw <- dplyr::bind_rows(
      generate_rec_na_cmd_table(self),
      df_cmd_raw
    )
  }
  df_cmd_raw
}
gen_sheet_cats <- function(self) {
  sheets <- self$mapping_file %>% readxl::excel_sheets()

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if (self$params$lab_before_var_sheet == "yes" & "Variables" %in% sheets & "Label" %in% sheets) {
    sheets <- switch_sheets_vars_label(sheets)
  }

  sheet_cats <- tab_sheet_types(sheets)
  sheet_cats
}
gen_sheet_data_raw_list <- function(self) {
  sheet_cats <- self$cmd$sheet_cats
  purrr::map2(
    sheet_cats$sheet %>%
      purrr::set_names(),
    sheet_cats$sheet_type,
    ~ gen_sheet_data_raw(self, .y, .x),
    .id = "sheet"
  )
}

generate_rec_na_cmd_table <- function(self) {
  params <- self$params
  vars_to_exclude_na_to_filter <- c(
    params$not_miss_to_filter_vars %>%
      stringr::str_split("[, ;]+") %>%
      unlist(),
    self$params$id_var
  )
  tibble::tibble(
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
  res %>%
    dplyr::rename(raw = .data$data)
}

gen_sheet_data_raw <- function(self, sheet_cat, sheet_name) {
  switch(sheet_cat,
    "Variables" = read_variables_sheet_raw(self$mapping_file, sheet = sheet_name, translate_xlsm = self$params$translate_xlsm),
    "Label"     = read_label_sheet_raw(self$mapping_file, sheet = sheet_name, translate_xlsm = self$params$translate_xlsm),
    "Free"      = mapp_free_sheet_cmd_table_raw(self$mapping_file, sheet = sheet_name),
    "Verbatims" = parse_verbatim_data_raw(self$mapping_file, sheet = sheet_name, verbatim_file = extract_verbatim_file_name(self$mapping_file, sheet_name), translate_xlsm = self$params$translate_xlsm)
  )
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
  sheet_cats <- purrr::map(
    sheets,
    ~ stringr::str_detect(.x, sheet_types)
  ) %>%
    purrr::map(
      ~ sheet_types[.x] %>%
        stringr::str_remove("\\^")
    ) %>%
    purrr::set_names(sheets)
  # remove sheets not in sheet types list:
  sheets <- sheets[purrr::map_int(sheet_cats, length) > 0]
  sheet_cats <- sheet_cats[purrr::map_int(sheet_cats, length) > 0]
  sheet_cats %>%
    purrr::map_chr(~.x) %>%
    tibble::enframe("sheet", "sheet_type")
}

#' Generate an object inheriting from `"command_block"`
#'
#' @param cdb row of command table
#'
#' @export
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' m <- Mapping$new(spss_file, mapping_file)
#' m$cmd$df_cmd_raw[10, ] %>% command_block()
#' # command_block() detects the subclass. So this is equivalent to:
#' m$cmd$df_cmd_raw[10, ] %>% new_command_block(subclass = "cmd_newlab")
command_block <- function(cdb, validate = TRUE) {
  subclass <- match_command_block_class(cdb$action)

  # hopefully preliminary method to use new apply_command.cmd_verbatim_custom():
  if (subclass == "cmd_verbatim" && cdb$raw[[1]]$EFA1MCG2MDG3 == "mdg_custom") {
    subclass <- c("cmd_verbatim_custom", subclass)
  }
  new_command_block(cdb, validate = validate, subclass = subclass)
}

match_command_block_class <- function(keyword) {
  command_block_row <- datenanpassr::command_block_classes$keyword == keyword
  if (sum(command_block_row) == 0) {
    stop(
      "command block keyword doesn't exist.",
      "See the package dataset `command_block_classes` for allowed ones."
    )
  }
  datenanpassr::command_block_classes[["command_block"]][command_block_row]
}


#' @export
#' @param ... further arguments passed to constructor
#' @param validate Whether to validate the arguments passed to generate the
#'   command block. Defaults to TRUE.
#' @param subclass character vector containing the subclass of the object to construct
#' @rdname command_block
new_command_block <- function(cdb, validate = TRUE, ..., subclass = character()) {
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
  if (validate) {
    cdb <- validate_command_block(cdb)
  }
  cdb
}

#' Command_blocks objects
#'
#' @param self `Mapping` object
#' @details
#'   `command_blocks()` generates an object of class `command_blocks` and of subclass
#' `self$params$error_out`.
#'
#'   `apply_command_blocks()` applies `"command_blocks"` object to a mapping object.
#'
#'   The `"command_blocks"` objects is a list of multiple `"command_block"`
#'   elements, that are applied to the mapping with `Mapping$modify_data()`
#'   using the `apply_command()` method of their subclass.
#'
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' m <- Mapping$new(spss_file, mapping_file)
#' command_blocks(m)
#' # This object was automatically generated when m was created.
#' # you can access it with:
#' # m$cmd$command_blocks
#' class(m$cmd$command_blocks)
command_blocks <- function(self) {
  cdbs <- self$cmd$df_cmd_raw %>%
    dplyr::rowwise() %>%
    dplyr::transmute(cmd = list(
      command_block(dplyr::cur_data(), validate = self$params$validate)
    )) %>%
    dplyr::pull()

  subclass <- self$params$error_out
  if (self$params$validate) {
    subclass <- c("validated", subclass)
  }
  new_command_blocks(cdbs, subclass = subclass)
}

new_command_blocks <- function(command_blocks, ..., subclass = character()) {
  class(command_blocks) <- c(subclass, "command_blocks", "list")

  command_blocks
}


#' @export
`[.command_blocks` <- function(x, i) {
  res <- new_command_blocks(NextMethod(x))
  class(res) <- class(x)
  res
}
