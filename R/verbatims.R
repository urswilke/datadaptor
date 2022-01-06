#' Extract verbatim sheet related data of Excel mapping file to dataframe
#'
#' @param self \code{Mapping} object
#' @param sheet name of the sheet in the Excel mapping file
#' @param verbatim_file character string of the name of the Verbatim file
#'
#' @return Command block table of the "Verbatims" sheet of the Excel mapping file.
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' verbatim_file <- system.file("extdata", "Verbatims_fake_survey.xlsx", package = "datenanpassr")
#' # open these Excel files (that come with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' utils::browseURL(verbatim_file)
#' }
#' m <- Mapping$new(NULL, mapping_file)
#' mapp_verbatim_sheet_cmd_tbl(m, verbatim_file = verbatim_file)
mapp_verbatim_sheet_cmd_tbl <- function(
  self,
  verbatim_file = extract_verbatim_file_name(self$mapping_file, sheet),
  sheet = "Verbatims"
) {
  # self$mapping_file <- new_self$mapping_file(self$mapping_file)
  if (!is.na(verbatim_file)) {
    id_var_str <- self$params$id_var
    l <- self$cmd$sheet_data_raw[[sheet]]
    generate_verbatim_assignment_table_raw(l) %>%
      dplyr::mutate(
        action = "#verbatim",
        new_var = .data$var_ziel,
        sheet = sheet,
        val_assign_temp = .data$val_assign,
        id_var_str = id_var_str
      ) %>%
      dplyr::group_by(sheet, .data$action, row, .data$new_var, .data$val_assign_temp) %>%
      tidyr::nest() %>%
      dplyr::ungroup() %>%
      dplyr::select(-.data$val_assign_temp)
  }
}

generate_verbatim_sheet_table <- function(mapping_file, sheet) {
  mapping_verbatim_sheet <-
    readxl::read_excel(mapping_file,
      skip = 16,
      sheet = sheet,
      col_names = TRUE
    ) %>%
    tidyr::drop_na(.data$VariableOriginal) %>%
    dplyr::select(.data$VariableOriginal:.data$`Tabellen-blatt`, .data$VariableZiel) %>%
    # HACK!!! TODO: replace with general regex
    dplyr::mutate(VariableZiel = un_OT_ize(.data$VariableZiel, .data$VariableOriginal) %>% un_OT_ize(.data$VariableOriginal) %>% un_OT_ize(.data$VariableOriginal)) %>%
    dplyr::relocate(q_id = .data$`Tabellen-blatt`)
  mapping_verbatim_sheet
}
extract_verbatim_file_name <- function(mapping_file, sheet) {
  file_path <- readxl::read_xlsx(
    mapping_file,
    sheet = sheet,
    range = cellranger::cell_cols(c("B:D")),
    skip = 0,
    col_types = c("text", "text", "text"),
    col_names = LETTERS[2:4]
  ) %>%
    dplyr::filter(.data$B == "Filename input") %>%
    dplyr::pull(.data$D)
  adapt_filepath(file_path, mapping_file)
}
generate_assignments_list <- function(verbatim_file, mapping_verbatim_sheet) {
  verbatim_file_sheets <-
    verbatim_file %>%
    readxl::excel_sheets()

  read_assigns <- function(sheet_name) {
    readxl::read_excel(verbatim_file, sheet = sheet_name, col_names = TRUE, range = cellranger::cell_limits(ul = c(32, 4))) %>%
      dplyr::select(orig_var = .data$`Orig. Variable`, .data$ID, dplyr::matches("^Zuord "))
  }


  # except "Codestufen", the first sheet:
  verbatim_file_sheets[-1] %>%
    purrr::set_names() %>%
    purrr::map(~ read_assigns(.x))
}
generate_label_code_list <- function(verbatim_file) {
  df_codestufen <-
    readxl::read_excel(
      verbatim_file,
      sheet = "Codestufen",
      col_names = TRUE,
      range = cellranger::cell_limits(ul = c(1, 2))
    ) %>%
    dplyr::mutate_all(~ ifelse(. == "<reserved>", NA, .)) %>%
    dplyr::mutate(dplyr::across(.fns = stringr::str_trim)) %>%
    dplyr::mutate(Code = dplyr::row_number()) %>%
    dplyr::relocate(.data$Code)
  2:length(df_codestufen) %>%
    purrr::set_names(names(df_codestufen)[-1]) %>%
    purrr::map(~ dplyr::select(df_codestufen, 1, lab = .x) %>% tidyr::drop_na())
}
# function to replace the term {OT...} in var_ziel by the corresponding substring
# in orig_var:
un_OT_ize <- function(var_ziel, orig_var) {
  # exctract the three digits in {OT...} :
  copyDigits <- stringr::str_match(var_ziel, "\\{OT(.*?)\\}")[, 2]
  # the first two digits in the beginning represent the starting positition:
  cp1stPos <- copyDigits %>%
    stringr::str_match("^\\d\\d") %>%
    as.numeric()
  # the last digit in the end represent the length:
  cpLength <- copyDigits %>%
    stringr::str_match("\\d$") %>%
    as.numeric()
  # extract substring of orig_var:
  replaceStr <- stringr::str_sub(orig_var, cp1stPos, cp1stPos + cpLength - 1)
  # replace the term {OT...} by the latter substring:
  var_name <- stringr::str_replace(var_ziel, "\\{OT\\d\\d\\d\\}", replaceStr)
  var_name
}


parse_verbatim_data_raw <- function(
  mapping_file,
  verbatim_file,
  sheet,
  translate_xlsm = FALSE
) {
  mapping_verbatim_sheet <- generate_verbatim_sheet_table(mapping_file, sheet = sheet)
  verbatim_sheets <- mapping_verbatim_sheet$q_id
  l_codestufen <- generate_label_code_list(verbatim_file)
  l_codestufen <- l_codestufen[verbatim_sheets]
  l_assigns <- generate_assignments_list(verbatim_file, mapping_verbatim_sheet)
  l_assigns <- l_assigns[verbatim_sheets]
  l <- vector("list", length(verbatim_sheets))
  for (i in 1:length(verbatim_sheets)) {
    l[[i]][["name"]] <- verbatim_sheets[i]
    l[[i]][["meta"]] <- mapping_verbatim_sheet %>% dplyr::slice(i)
    l[[i]][["assignments"]] <- l_assigns[[i]] %>% dplyr::filter(.data$orig_var == l[[i]][["meta"]] %>% dplyr::pull(.data$VariableOriginal))
    l[[i]][["labs"]] <- l_codestufen[i]
  }
  l
}
parse_mdg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  df_vars_n_labs <- i_l$labs[[1]] %>%
    dplyr::mutate(
      var_ziel = var_template %>% stringr::str_replace(
        "\\{nn\\}",
        .data$Code %>% as.character()
      )
    ) %>%
    dplyr::rename(varlab = .data$lab) %>%
    dplyr::mutate(varlab = as.list(.data$varlab))
  df_assigns <- i_l$assignments %>%
    tidyr::gather("i_assign", "code_assign", dplyr::starts_with("Zuord")) %>%
    dplyr::select(-.data$i_assign) %>%
    tidyr::drop_na() %>%
    dplyr::group_by(.data$code_assign) %>%
    dplyr::summarise(id_list = list(unique(.data$ID))) %>%
    dplyr::full_join(
      df_vars_n_labs,
      by = c("code_assign" = "Code")
    )
  df_assigns <- df_assigns %>%
    dplyr::mutate(
      val_assign = 1,
      vallab = rep(list(c("unselected" = 0, "selected" = 1)), nrow(df_assigns)),
      init_val = 0
    ) %>%
    dplyr::select(-.data$code_assign)
  df_assigns
}
parse_efa_assignment_table <- function(i_l) {
  # in case multiple "Zuord" columns occur in assignment data, code would break
  # and only the first is needed:
  i_l$assignments <- i_l$assignments %>%
    dplyr::select(1:3)
  parse_mcg_assignment_table(i_l) %>%
    dplyr::mutate(init_val = NA_real_)
}
parse_mcg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  vallabs <- i_l$labs[[1]] %>%
    dplyr::relocate(2) %>%
    tibble::deframe() %>%
    merge_vallabs(c("FILTER" = -2))
  df_assigns <- i_l$assignments %>%
    tidyr::gather("i_assign", "val_assign", dplyr::starts_with("Zuord")) %>%
    dplyr::mutate(i_assign = stringr::str_remove(.data$i_assign, "^Zuord ") %>% as.numeric()) %>%
    dplyr::group_by(.data$i_assign, .data$val_assign) %>%
    dplyr::summarise(id_list = list(.data$ID)) %>%
    # Hack to not assign missing values: TODO: find cleaner way!
    dplyr::mutate(id_list = ifelse(is.na(.data$val_assign), list(NULL), .data$id_list)) %>%
    dplyr::mutate(
      var_ziel = var_template %>% stringr::str_replace(
        "\\{nn\\}",
        .data$i_assign %>% as.character()
      )
    ) %>%
    dplyr::ungroup()

  df_assigns <- df_assigns %>%
    dplyr::mutate(
      varlab = rep(list(NULL), nrow(df_assigns)),
      vallab = rep(list(vallabs), nrow(df_assigns))
    ) %>%
    dplyr::select(-.data$i_assign) %>%
    dplyr::mutate(init_val = -2)
  df_assigns
}
translate_verbatim_line <- function(verbatim_type, verbatim_data) {
  switch(verbatim_type,
    "1" = parse_efa_assignment_table(verbatim_data),
    "2" = parse_mcg_assignment_table(verbatim_data),
    "3" = parse_mdg_assignment_table(verbatim_data),
    stop("Invalid verbatim type code.")
  )
}

generate_verbatim_assignment_table_raw <- function(l) {
  verbatim_types <- l %>% purrr::map_dbl(purrr::chuck, "meta", "EFA1MCG2MDG3")
  purrr::map2(verbatim_types, l, translate_verbatim_line) %>%
    dplyr::bind_rows(.id = "row")
}
