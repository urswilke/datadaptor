#' Extract verbatim sheet related data of Excel mapping file to dataframe
#'
#' @param self \code{Mapping} object
#' @param sheet name of the sheet in the Excel mapping file
#'
#' @return Command block table of the "Verbatims" sheet of the Excel mapping file.
#' @noRd
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # verbatim_file <- system.file("extdata", "Verbatims_mtcars_labelled.xlsx", package = "datenanpassr")
#' # open these Excel files (that come with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' # utils::browseURL(verbatim_file)
#' }
#' m <- Mapping$new(NULL, mapping_file)
#' mapp_verbatim_sheet_cmd_tbl(m)
mapp_verbatim_sheet_cmd_tbl <- function(
  self,
  sheet = "Verbatims"
) {
  id_var_str <- self$params$id_var
  l <- self$cmd$sheet_data_raw[[sheet]]
  if (is.null(l)) {
    return(NULL)
  }
  generate_verbatim_assignment_table_raw(l) |>
    mutate(
      action = "#verbatim",
      new_var = .data$x,
      sheet = sheet,
      ex_assign_temp = .data$ex_assign,
      id_var_str = id_var_str
    ) |>
    group_by(sheet, .data$action, row, .data$new_var, .data$ex_assign_temp) |>
    nest() |>
    ungroup() |>
    select(-"ex_assign_temp")
}

generate_verbatim_sheet_table <- function(mapping_file, sheet, mapping) {
  mapping_verbatim_sheet <-
    wb_read(
      mapping$wb,
      sheet,
      start_row = 18
    ) |>
    format_sheet_data() |>
    drop_na("VariableOriginal") |>
    select("VariableOriginal":"Tabellen-blatt", "VariableZiel", "padding" = "VariableZ\u00e4hler", any_of(c("ex_further_cond", "ex_assign"))) |>
    # HACK!!! TODO: replace with general regex
    mutate(VariableZiel = un_OT_ize(.data$VariableZiel, .data$VariableOriginal) |> un_OT_ize(.data$VariableOriginal) |> un_OT_ize(.data$VariableOriginal)) |>
    relocate(q_id = "Tabellen-blatt")
  mapping_verbatim_sheet
}
extract_verbatim_file_name <- function(mapping_file, sheet, mapping) {
  verbatims_sheet <- wb_read(
    mapping$wb,
    sheet,
    cols = 2:4,
    col_names = FALSE
  ) |>
    format_sheet_data()
  if (nrow(verbatims_sheet) == 0) {
    return(NA_character_)
  }
  file_path <- verbatims_sheet |>
    filter(.data$B == "Filename input") |>
    pull(.data$D)
  adapt_filepath(file_path, mapping_file)
}
generate_assignments_list <- function(verbatim_file, mapping_verbatim_sheet, wb) {
  verbatim_file_sheets <- wb$get_sheet_names() |> unname()

  read_assigns <- function(sheet_name, mapping) {
    res <- wb_read(wb, sheet_name, start_row = 32)
    res |>
      select(orig_var = "Orig. Variable", "ID", matches("^Zuord ")) |> as_tibble()
  }

  # except "Codestufen", the first sheet:
  verbatim_file_sheets[-1] |>
    set_names() |>
    map(~ read_assigns(.x))
}
generate_label_code_list <- function(verbatim_file, wb) {
  raw <- wb_read(wb, "Codestufen")
  names(raw)[1] <- "Code"
  df_codestufen <- raw |>
    format_sheet_data() |>
    mutate_all(~ ifelse(. == "<reserved>", NA, .)) |>
    mutate(Code = row_number()) |>
    relocate("Code")
  2:length(df_codestufen) |>
    set_names(names(df_codestufen)[-1]) |>
    map(~ select(df_codestufen, 1, lab = !!.x) |> drop_na())
}
# function to replace the term {OT...} in x by the corresponding substring
# in orig_var:
un_OT_ize <- function(x, orig_var) {
  # exctract the three digits in {OT...} :
  copyDigits <- str_match(x, "\\{OT(.*?)\\}")[, 2]
  # the first two digits in the beginning represent the starting positition:
  cp1stPos <- copyDigits |>
    str_match("^\\d\\d") |>
    as.numeric()
  # the last digit in the end represent the length:
  cpLength <- copyDigits |>
    str_match("\\d$") |>
    as.numeric()
  # extract substring of orig_var:
  replaceStr <- str_sub(orig_var, cp1stPos, cp1stPos + cpLength - 1)
  # replace the term {OT...} by the latter substring:
  var_name <- str_replace(x, "\\{OT\\d\\d\\d\\}", replaceStr)
  var_name
}


parse_verbatim_data_raw <- function(
  mapping_file,
  verbatim_file,
  sheet,
  mapping
) {
  if (is.na(verbatim_file)) {
    return(NULL)
  }
  mapping_verbatim_sheet <- generate_verbatim_sheet_table(mapping_file, sheet = sheet, mapping)
  verbatim_sheets <- mapping_verbatim_sheet$q_id

  wb <- wb_load(verbatim_file)


  l_codestufen <- generate_label_code_list(verbatim_file, wb)
  l_codestufen <- l_codestufen[verbatim_sheets]
  l_assigns <- generate_assignments_list(verbatim_file, mapping_verbatim_sheet, wb)
  l_assigns <- l_assigns[verbatim_sheets]
  l <- vector("list", length(verbatim_sheets))
  for (i in seq_len(length(verbatim_sheets))) {
    l[[i]][["name"]] <- verbatim_sheets[i]
    l[[i]][["meta"]] <- mapping_verbatim_sheet |> slice(i)
    # next line is equal to:
    # l[[i]][["assignments"]] <- l_assigns[[i]] |> filter(.data$orig_var == l[[i]][["meta"]] |> pull(.data$VariableOriginal))
    l[[i]][["assignments"]] <- l_assigns[[i]][l[[i]][["meta"]]$VariableOriginal == l_assigns[[i]]$orig_var,]
    l[[i]][["labs"]] <- l_codestufen[i]
  }
  l
}
extract_custom_mdg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  df_vars_n_labs <- i_l$labs[[1]] |>
    mutate(
      temp = .data$Code |> as.character(),
      temp = ifelse(
        rep(i_l$meta$padding, nrow(i_l$labs[[1]])) %in% "00",
        stringr::str_pad(temp, 2, pad = "0"),
        temp
      ),
      x = var_template |> str_replace(
        "\\{nn\\}",
        temp
      ),
      temp = NULL,
    ) |>
    rename(varlab = "lab") |>
    mutate(varlab = as.list(.data$varlab))
  df_assigns <- i_l$assignments |>
    gather("i_assign", "code_assign", starts_with("Zuord")) |>
    select(-"i_assign") |>
    drop_na() |>
    group_by(.data$code_assign) |>
    summarise(id_list = list(unique(.data$ID))) |>
    full_join(
      df_vars_n_labs,
      by = c("code_assign" = "Code")
    )
  ex_assign <- pluck(i_l$meta, "ex_assign")
  if (is.null(ex_assign)) {
    stop(
      "You need to specify a value of a column named `ex_assign` for variable ",
      i_l$meta$VariableZiel,
      "."
    )
  }

  df_assigns <- df_assigns |>
    mutate(
      temp = .data$code_assign |> as.character(),
      temp = ifelse(
        rep(i_l$meta$padding, nrow(i_l$labs[[1]])) %in% "00",
        stringr::str_pad(temp, 2, pad = "0"),
        temp
      ),
      ex_assign = ex_assign |> str_replace(
        "\\{nn\\}",
        temp
      ),
      temp = NULL,
      init_val = 0
    ) |>
    select(-"code_assign")
  df_assigns
}
extract_mdg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  df_vars_n_labs <- i_l$labs[[1]] |>
    mutate(
      temp = .data$Code |> as.character(),
      temp = ifelse(
        rep(i_l$meta$padding, nrow(i_l$labs[[1]])) %in% "00",
        stringr::str_pad(temp, 2, pad = "0"),
        temp
      ),
      x = var_template |> str_replace(
        "\\{nn\\}",
        temp
      ),
      temp = NULL,
    ) |>
    rename(varlab = "lab") |>
    mutate(varlab = as.list(.data$varlab))
  df_assigns <- i_l$assignments |>
    gather("i_assign", "code_assign", starts_with("Zuord")) |>
    select(-"i_assign") |>
    drop_na() |>
    group_by(.data$code_assign) |>
    summarise(id_list = list(unique(.data$ID))) |>
    full_join(
      x = df_vars_n_labs,
      y = _,
      by = c("Code" = "code_assign")
    )

  df_assigns <- df_assigns |>
    mutate(
      ex_assign = 1,
      vallab = rep(list(c("unselected" = 0, "selected" = 1)), nrow(df_assigns)),
      init_val = 0
    ) |>
    mutate(ex_assign = as.character(.data$ex_assign)) |>
    select(-"Code")
  df_assigns
}
extract_efa_assignment_table <- function(i_l) {
  # in case multiple "Zuord" columns occur in assignment data, code would break
  # and only the first is needed:
  i_l$assignments <- i_l$assignments |>
    select(1:3)
  extract_mcg_assignment_table(i_l) |>
    mutate(init_val = NA_real_)
}
extract_mcg_assignment_table <- function(i_l) {
  var_template <- i_l$meta$VariableZiel
  vallabs <- i_l$labs[[1]] |>
    relocate(2) |>
    deframe() |>
    merge_vallabs(c("FILTER" = -2))
  df_assigns <- i_l$assignments |>
    gather("i_assign", "ex_assign", starts_with("Zuord")) |>
    mutate(i_assign = str_remove(.data$i_assign, "^Zuord ") |> as.numeric()) |>
    mutate(ex_assign = as.character(.data$ex_assign)) |>
    group_by(.data$i_assign, .data$ex_assign) |>
    summarise(id_list = list(.data$ID)) |>
    # Hack to not assign missing values: TODO: find cleaner way!
    mutate(id_list = ifelse(is.na(.data$ex_assign), list(NULL), .data$id_list)) |>
    mutate(
      x = var_template |> str_replace(
        "\\{nn\\}",
        .data$i_assign |> as.character()
      )
    ) |>
    ungroup()

  df_assigns <- df_assigns |>
    mutate(
      varlab = rep(list(NULL), nrow(df_assigns)),
      vallab = rep(list(vallabs), nrow(df_assigns))
    ) |>
    select(-"i_assign") |>
    mutate(init_val = -2)
  df_assigns
}
translate_verbatim_line <- function(verbatim_type, verbatim_data) {
  switch(verbatim_type,
    "1" = extract_efa_assignment_table(verbatim_data),
    "2" = extract_mcg_assignment_table(verbatim_data),
    "3" = extract_mdg_assignment_table(verbatim_data),
    "mdg_custom" = extract_custom_mdg_assignment_table(verbatim_data),
    stop("Invalid verbatim type code.")
  )
}

generate_verbatim_assignment_table_raw <- function(l) {
  # hopefully preliminary structure to use new apply_command.cmd_verbatim_new():
  verbatim_types <- l |> map_chr(chuck, "meta", "EFA1MCG2MDG3")
  # allow to not specify ex_further_cond in excel mapping file -> then write NA column
  ex_further_cond <- l |> map_chr(pluck, "meta", "ex_further_cond", .default = NA_character_)
  map2(verbatim_types, l, translate_verbatim_line) |>
    map2(ex_further_cond, ~ mutate(.x, ex_further_cond = .y)) |>
    map2(verbatim_types, ~ mutate(.x, EFA1MCG2MDG3 = .y)) |>
    bind_rows(.id = "row")
}
