#' Create an Excel mapping file based on a labelled dataframe
#'
#' The mapping file consists of the sheets "Variables", "Label", "Verbatims" &
#' "Free". Each of these controls different aspects of data manipulations you
#' can apply to a labelled dataset. You can add as much of those sheets as you
#' want to the file. The commands entered in the mapping file can later be
#' executed on the data set with \code{mapp_xl_to_data()}. The sequence of
#' commands is executed in the same order as the sequence of sheets in the
#' mapping file.
#'
#' @param df_raw dataframe with labelled variables, e.g. resulting from
#'   haven::read_sav
#' @param mapping_file name of the Excel file to be created
#' @param mapping_type String specifying the mapping type. Either "excel" or "google"
#'   (for googlesheets). Defaults to "excel".
#'
#' @export
#'
#' @examples
#' spss_file <- system.file("extdata", "mtcars_labelled.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_file)
#' \dontrun{
#' mapp_create(df, "mapping.xlsx")
#' mapp_create(df, "mapping_googlesheets", mapping_type = "google")
#' }
mapp_create <- function(df_raw, mapping_file, mapping_type = "excel") {
  if (mapping_type == "excel") {
    mapp_create_xlsx(df_raw, mapping_file)
  }
  if (mapping_type == "google") {
    mapp_create_google(df_raw, mapping_file)
  }
}
mapp_create_xlsx <- function(df_raw, mapping_file) {
  df_varlab <- gen_var_table(df_raw)
  df_vallabs <- gen_label_table(df_raw)

  wb <- createWorkbook()

  addWorksheet(wb, "Variables")
  addWorksheet(wb, "Label")
  addWorksheet(wb, "Verbatims")
  addWorksheet(wb, "Free1")

  # Write the data to the sheets
  writeData(wb, sheet = "Variables", x = df_varlab)
  writeData(wb, sheet = "Label", x = df_vallabs)
  writeData(wb, sheet = "Verbatims", x = "")
  writeData(wb, sheet = "Free1", x = "")

  # Export the file
  saveWorkbook(wb, mapping_file)
  message("Excel mapping file written to '", mapping_file, "'")
}
mapp_create_google <- function(df_raw, mapping_file) {
  df_varlab <- gen_var_table(df_raw)
  df_vallabs <- gen_label_table(df_raw)

  gs <- gs4_create(mapping_file, sheets = c("Variables", "Label", "verbatims", "Free1"))

  sheet_write(df_varlab, ss = gs, sheet = "Variables")
  sheet_write(df_vallabs, ss = gs, sheet = "Label")

  gs4_get(gs)
}
#' Extract variable label sheet of Excel mapping file to dataframe
#'
#' @param  self \code{Mapping} object
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return Command block table of the "Variables" sheet of the Excel mapping
#'   file.
#' @noRd
#'
#' @examples
#' # create empty template from labelled dataset `mtcars_labelled` via:
#' # mapp_create(mtcars_labelled, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' m <- Mapping$new(NULL, mapping_file)
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_var_sheet_cmd_table(m)
mapp_var_sheet_cmd_table <- function(self, sheet = "Variables") {
  self$cmd$sheet_data_raw[[sheet]] |>
    format_df_varl()
}
read_variables_sheet_raw <- function(mapping_file, sheet) {
  UseMethod("read_variables_sheet_raw")
}
read_variables_sheet_raw.google <- function(mapping_file, sheet) {
  read_sheet(
    mapping_file |> as.character(),
    sheet = sheet
  )
}
read_variables_sheet_raw.excel <- function(mapping_file, sheet) {
  if (attr(mapping_file, "translate_xlsm")) {
    df_varl <- read_xlsm_variables_sheet_raw(mapping_file, sheet)
  } else {
    df_varl <- read_xlsx(
      mapping_file,
      sheet = sheet,
      col_types = "text"
    )
  }
  df_varl
}

read_xlsm_variables_sheet_raw <- function(mapping_file, sheet) {
  read_xlsx(
    mapping_file,
    sheet = sheet,
    range = cell_limits(c(3, 1), c(NA, 13)),
    col_names = c("var", "nn1", "varlab", "nn2", "nn3", "nn4", "nn5", "nn6", "nn7", "nn8", "op", "new_name", "new_label"),
    col_types = "text"
  ) |>
    select(-matches("^nn[1-8]$"))
}

format_df_varl <- function(df_varl) {
  df_varl |>
    mutate(row = (row_number() + 1) |> as.character()) |>
    parse_varlab_cmd_table()
}



parse_varlab_cmd_table <- function(df_varl) {
  bind_rows(
    # TODO:
    # refactor these functions for better performance:
    # group_by() |> nest() |> ungroup() is called in all of these functions...:
    parse_str_to_num_cmd_block(df_varl),
    parse_autorecode_cmd_block(df_varl),
    parse_drop_cmd_block(df_varl),
    parse_rename_cmd_block(df_varl),
    parse_newlab_cmd_blocks(df_varl)
  )
}

parse_newlab_cmd_blocks <- function(df_varl) {
  df_varl |>
    drop_na("new_label") |>
    mutate(var = coalesce(.data$new_name, .data$var)) |>
    mutate(new_var = .data$var) |>
    mutate(sheet = "Variables") |>
    mutate(action = "#NEWLAB") |>
    select(-all_of(c("new_name", "op"))) |>
    group_by(.data$sheet, .data$action, row, .data$new_var) |>
    nest() |>
    ungroup()
}
parse_rename_cmd_block <- function(df_varl) {
  df_varl |>
    drop_na("new_name") |>
    mutate(sheet = "Variables") |>
    mutate(action = "#RENAME_varsheet") |>
    mutate(new_var = .data$new_name) |>
    select(-any_of(c("new_label", "op", "varlab"))) |>
    group_by(.data$sheet, .data$action) |>
    summarise(
      row = paste(row, collapse = ", "),
      new_names = list(.data$new_var),
      new_var = paste(.data$new_var, collapse = ", "),
      vars = list(.data$var)
    ) |>
    group_by(.data$sheet, .data$action, .data$new_var, row) |>
    nest() |>
    ungroup()
}

parse_autorecode_cmd_block <- function(df_varl) {
  df_varl |>
    filter(.data$op == "a") |>
    mutate(sheet = "Variables") |>
    mutate(action = "#AUTOREC") |>
    mutate(new_var = .data$var) |>
    select(-any_of(c("new_label", "op", "varlab", "new_name"))) |>
    group_by(.data$sheet, .data$action, .data$new_var, .data$row) |>
    nest() |>
    ungroup()
}


parse_drop_cmd_block <- function(df_varl) {
  df_varl |>
    filter(.data$op == "d") |>
    mutate(sheet = "Variables") |>
    mutate(action = "#DROP") |>
    group_by(.data$sheet, .data$action) |>
    summarise(
      row = paste(row, collapse = ", "),
      new_var = NA_character_,
      vars = list(.data$var)
    ) |>
    group_by(.data$sheet, .data$action, .data$new_var, row) |>
    nest() |>
    ungroup()
}


parse_str_to_num_cmd_block <- function(df_varl) {
  df_varl |>
    filter(.data$op == "n") |>
    mutate(sheet = "Variables") |>
    mutate(action = "#STR2NUM") |>
    mutate(new_var = .data$var) |>
    select(-any_of(c("new_label", "op", "varlab", "new_name"))) |>
    group_by(.data$sheet, .data$action, .data$new_var, .data$row) |>
    nest() |>
    ungroup()
}





#' Extract value label sheet of Excel mapping file to dataframe
#'
#' @param  self \code{Mapping} object
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return Command block table of the "Label" sheet of the Excel mapping file.
#' @noRd
#'
#' @examples
#' # create empty template from labelled dataset `mtcars_labelled` via:
#' # mapp_create(mtcars_labelled, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' m <- Mapping$new(NULL, mapping_file)
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_vallab_sheet_cmd_table(m)
mapp_vallab_sheet_cmd_table <- function(self, sheet = "Label") {
  df_vall <- self$cmd$sheet_data_raw[[sheet]]

  df_vall <- df_vall |>
    mutate(row = row_number() + 1)
  bind_rows(
    parse_newvall_cmd_table(df_vall),
    parse_sumvar_cmd_table(df_vall)
  )
}

read_label_sheet_raw <- function(mapping_file, sheet) {
  UseMethod("read_label_sheet_raw")
}
read_label_sheet_raw.google <- function(mapping_file, sheet) {
  read_sheet(
    mapping_file |> as.character(),
    sheet = sheet
  )
}
read_label_sheet_raw.excel <- function(mapping_file, sheet) {
  if (attr(mapping_file, "translate_xlsm")) {
    df_vall <- read_xlsm_label_sheet_raw(mapping_file, sheet)
  } else {
    df_vall <- read_xlsx(
      mapping_file,
      sheet = sheet
    )
  }
  df_vall
}

read_xlsm_label_sheet_raw <- function(mapping_file, sheet) {
  read_xlsx(
    mapping_file,
    sheet = sheet,
    range = cell_limits(c(3, 1), c(NA, 9)),
    col_names = c(
      "var", "nv", "vallab", "new_label", "not_needed1",
      "not_needed2", "sum_var_label", "sum_var_value",
      "sum_var_vallab"
    ),
    col_types = "text"
  ) |>
    select(-all_of(c("not_needed1", "not_needed2"))) |>
    mutate(
      nv = as.numeric(.data$nv),
      sum_var_value = as.numeric(.data$sum_var_value)
    ) |>
    fill("var")
}



parse_sumvar_cmd_table <- function(df_vall) {
  df_vall |>
    drop_na("sum_var_value") |>
    select(-"new_label") |>
    mutate(new_var = paste0("k", .data$var)) |>
    mutate(orig_var = .data$var) |>
    group_by(.data$new_var, .data$orig_var) |>
    mutate(row = paste(.data$row, collapse = ", ")) |>
    mutate(sheet = "Label") |>
    mutate(action = "#SUMVAR") |>
    relocate(all_of(c("sheet", "action"))) |>
    group_by(.data$sheet, .data$action, .data$row, .data$new_var) |>
    nest() |>
    ungroup()
}
parse_newvall_cmd_table <- function(df_vall) {
  df_vall |>
    drop_na("new_label") |>
    mutate(new_var = .data$var) |>
    mutate(orig_var = .data$var) |>
    mutate(sheet = "Label") |>
    mutate(action = "#NEWVALL") |>
    relocate(all_of(c("sheet", "action"))) |>
    group_by(.data$sheet, .data$action, .data$new_var) |>
    mutate(row = paste(.data$row, collapse = ", ")) |>
    group_by(.data$sheet, .data$action, .data$row, .data$new_var) |>
    nest() |>
    ungroup()
}




#' Extract free1 sheet of Excel mapping file to dataframe
#'
#' @param  self \code{Mapping} object
#' @param  sheet name of the sheet in the Excel mapping file
#'
#' @return Command block table of the "Free" sheet of the Excel mapping file.
#' @noRd
#'
#' @examples
#' # create empty template from labelled dataset `mtcars_labelled` via:
#' # mapp_create(mtcars_labelled, "mapping.xlsx")
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' m <- Mapping$new(NULL, mapping_file)
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_free_sheet_cmd_table(m)
mapp_free_sheet_cmd_table <- function(self, sheet = "Free1") {
  df_free <- self$cmd$sheet_data_raw[[sheet]]
  if (nrow(df_free) > 0) {
    df_free <- df_free[1:6]
  } else {
    df_free <-
      tibble(
        X1 = character(),
        X2 = character(),
        X3 = character(),
        X4 = character(),
        X5 = character(),
        row = character(),
      )

  }
  df_free |>
    put_absolute_filepaths(self$mapping_file) |>
    process_raw_free_cmd_table()
}

mapp_free_sheet_cmd_table_raw <- function(mapping_file, sheet) {
  mapp_free_sheet_cmd_table_raw_raw(mapping_file, sheet) |>
    mutate(row = row_number()) |>
    filter(if_any(starts_with("X"), ~ !is.na(.)))
}
mapp_free_sheet_cmd_table_raw_raw <- function(mapping_file, sheet) {
  UseMethod("mapp_free_sheet_cmd_table_raw_raw")
}
mapp_free_sheet_cmd_table_raw_raw.google <- function(mapping_file, sheet) {
  read_sheet(
    mapping_file |> as.character(),
    sheet = sheet,
    range = "A:E",
    col_types = "c",
    col_names = paste0("X", 1:5)
  )
}
mapp_free_sheet_cmd_table_raw_raw.excel <- function(mapping_file, sheet) {
  read_xlsx(
    mapping_file,
    range = cell_limits(ul = c(1, 1), lr = c(NA, 5), sheet = sheet),
    col_names = paste0("X", 1:5),
    col_types = "text"
  )
}



process_raw_free_cmd_table <- function(df_free) {
  if (nrow(df_free) == 0) {
    return(NULL)
  }
  df_free |>
    delete_empty_X1_not_multiline() |>
    add_curlies_to_cell_with_spaces() |>
    curlychop() |>
    group_by(.data$row) |>
    mutate(action = .data$X1[1]) |>
    group_by(.data$action, .data$row, .data$raw_index) |>
    nest() |>
    ungroup() |>
    get_new_var_name_free() |>
    select(-"raw_index")
}
put_absolute_filepaths <- function(df_free, mapping_file) {
  df_free[df_free$X1 %in% c("#MERGE", "#RFUN"), ][["X2"]] <-
    df_free[df_free$X1 %in% c("#MERGE", "#RFUN"), ][["X2"]] |>
    map_chr(~ adapt_filepath(.x, mapping_file))
  df_free
}

get_new_var_name_free <- function(df_free_nested) {
  # This function is old legacy code. Before, it was run on a grouped dataframe,
  # and then slightly modified (because this was very time-consuming)
  # so it got even more horrible, and still contains bugs....
  # e.g.:
  # - for #RECNA you would want to know all the variables to be modified (or
  #   or those omitted with a minus sign?)
  # - #RENAME: old name with minus, new names added...?
  # perhaps best to be calculated from:
  # mapping$cmd_tbl$command_blocks |> map("args") |> map("xs") |> map_chr(~.x |> na.omit() |> paste0(collapse = ", "))
  # &
  # mapping$cmd_tbl$command_blocks |> map("args") |> map("x")
  # (?)
  col2_names <- c("#VALL", "#AVALL", "#COMP", "#VARL")
  col3_names <- c("#DIC", "#RENAME")
  col3or2_names <- c("#REC", "#RMVAL")
  temp <- df_free_nested |>
    mutate(data = map(.data$data, ~slice(.x, 1))) |>
    bind_rows() |>
    unnest(.data$data) |>
    mutate(new_var = case_when(
      action %in% col3_names ~ .data$X3,
      action %in% col2_names ~ .data$X2,
      action %in% col3or2_names ~ coalesce(.data$X3, .data$X2),
      action == "#IF" ~ str_remove(.data$X3, "=.*") |> str_squish(),
      action == "#KG" ~ paste(.data$X2, .data$X3, sep = "_"),
      action == "#MERGE" ~ paste(.data$X4, collapse = ", ")
    ))
  df_free_nested |> mutate(new_var = temp$new_var, .after = "action")
}

add_curlies_to_cell_with_spaces <- function(df_free) {
  # transform X2 containing spaces to curlychop()able (surrounded by curly
  # braces):
  df_free |>
    mutate(X2 = ifelse(
      grepl("(#VARL|#REC|#VALL|#AVALL|#RMVAL)", .data$X1) == TRUE & str_detect(.data$X2, " ") & str_detect(.data$X2, "\\{", negate = TRUE),
      paste0("{", .data$X2, "}"),
      .data$X2
    ))
}
delete_empty_X1_not_multiline <- function(df_free) {
  df_free |>
    mutate(
      not_multiline_cmd = str_detect(
        .data$X1,
        "^#VALL$|^#REC$|^#AVALL$|^#RMVAL$|^#R$|^#RENAME$|^#SELECT$|^#FILTER$",
        negate = TRUE
      ),
      after_dot = (lag(str_detect(.data$X1, "\\.")) &
                     !str_detect(.data$X1, "^#")
                   ) |>
        is_true_vec(),
      temp = .data$not_multiline_cmd & !.data$after_dot
    ) |>
    fill("temp") |>
    mutate(temp = .data$temp & is.na(.data$X1)) |>
    filter(!.data$temp) |>
    select(-all_of(c("temp", "not_multiline_cmd", "after_dot")))
}
