#' Create a summary table of the data modifications list read in from the
#' Excel mapping file
#'
#' @param mapping_file filename of the Excel mapping file
#' @param add_r_command_colum logical, whether to add a column `"R command"`
#' @param translate_xlsm logical, whether to translate from Wolf's format
#' specifying the corresponding R command; defaults to FALSE
#' @param na_to_filter logical specifying whether a command is added whether
#' `set_na_to_filter_except()` should be run as the very first command.
#' @param vectorized logical whether groups of command blocks to calculate
#' new vectors are applied to the data in a single `dplyr::mutate()`
#' statement or whether to consecutively apply (by using `purrr::reduce()`)
#' each command expression on the whole data frame. Probably something similar as the difference between:
#' dataframe() %>% mutate(a = 1) %>% mutate(b = 2) or
#' dataframe() %>% mutate(a = 1, b = 2).
#' The second is faster. For many data operations or large datasets,
#' vectorized = TRUE should also be faster
#'
#' @return Command table containing the data of the command blocks of the Excel mapping file.
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' mapp_cmd_table(mapping_file)
#' # Add column for R command:
#' mapp_cmd_table(mapping_file, add_r_command_colum = TRUE)
mapp_cmd_table <- function(
  mapping_file,
  add_r_command_colum = FALSE,
  translate_xlsm = FALSE,
  na_to_filter = TRUE,
  vectorized = FALSE
  ) {
  set_configr_args(mapping_file)
  id_var <- datenanpassr.env$configr$id_var


  sheets <- mapping_file %>% readxl::excel_sheets()

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if (datenanpassr.env$configr$lab_before_var_sheet == "yes" & "Variables" %in% sheets & "Label" %in% sheets) {
    var_index <- which(sheets == "Variables")
    lab_index <- which(sheets == "Label")
    sheets[var_index] <- "Label"
    sheets[lab_index] <- "Variables"
  }

  sheet_types <- c("^Variables", "^Label", "^Verbatims", "^Free")

  # vector of sheets with names defined by types:
  sheet_cats <- purrr::map(
    sheets,
    ~stringr::str_detect(.x, sheet_types)
  ) %>%
    purrr::map(
      ~ sheet_types[.x] %>%
        stringr::str_remove("\\^")
    ) %>%
    purrr::set_names(sheets)
  # remove sheets not in sheet types list:
  sheets <- sheets[purrr::map_int(sheet_cats, length) > 0]
  sheet_cats <- sheet_cats[purrr::map_int(sheet_cats, length) > 0]
  sheet_cats <- sheet_cats %>%
    purrr::map_chr(~.x)

  # The class is set to the file ending:

  # sheet_cats <- new_xlsx(sheet_cats)
  mapping_file <- new_cmd_table_type(mapping_file)
  df_cmd <- purrr::map2_dfr(
    sheets %>%
      purrr::set_names(),
    sheet_cats,
    ~ generate_sheet_cmd_table(mapping_file, .y, .x, id_var_str = id_var),
    .id = "sheet"
  )
  df_cmd_manip_string <- datenanpassr.env$configr$manipulate_command_table
  if (!is.na(df_cmd_manip_string)) {
    df_cmd <- apply_df_cmd_manip(df_cmd_manip_string, df_cmd)
  }
  df_cmd <- df_cmd %>%
    dplyr::rowwise() %>%
    dplyr::mutate(data = parse_cmd_block_args(.data$action, .data$data, vectorized)) %>%
    dplyr::ungroup()
  if (na_to_filter == TRUE) {
    df_cmd <- add_rec_na_to_cmd_table(mapping_file, df_cmd, id_var)
  }
  if (add_r_command_colum) {
    cmd_list <- purrr::map2(df_cmd$action, df_cmd$data, ~deparse(generate_cmd_expression(.x, .y)))
    # print(cmd_list)
    df_cmd["R command"] <-
      tibble::tibble(a = cmd_list) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(a = list(paste(stringr::str_squish(.data$a), collapse = " "))) %>%
      tidyr::unnest(.data$a)
  }

  attr(df_cmd, "vectorized") = vectorized
  attr(df_cmd, "id_var") <- id_var
  df_cmd
}

new_cmd_table <- function(mapping_file, ..., class = character()) {
  stopifnot(file.exists(mapping_file))

  structure(
    mapping_file,
    ...,
    class = c(class, "cmd_table")
  )
}
new_cmd_table_type <- function(mapping_file) {
  excel_type <- stringr::str_remove(mapping_file, ".*\\.")
  excel_type <- match.arg(excel_type, c("xlsx", "xlsm"))
  new_cmd_table(mapping_file, class = excel_type)
}


apply_df_cmd_manip <- function(df_cmd_manip_string, df_cmd) {
  df_cmd <- df_cmd_manip_string %>% rlang::parse_expr() %>% rlang::eval_tidy()
}
add_rec_na_to_cmd_table <- function(mapping_file, df_cmd, id_var) {
  vars_to_exclude_na_to_filter <- c(
    datenanpassr.env$configr$not_miss_to_filter_vars,
    id_var,
    datenanpassr.env$configr$added_id_var
  )
  na_rec_vec <- datenanpassr.env$configr$miss_replace_lab_val
  dplyr::bind_rows(
    tibble::tibble(
      sheet = "Config",
      action = "#RECNA",
      row = NA_character_,
      new_var = NA_character_,
      data = list(list(
        recode_na_exceptions = vars_to_exclude_na_to_filter,
        replace_val = unname(na_rec_vec),
        replace_label = names(na_rec_vec)
      ))
    ),
    df_cmd
  )
}
generate_sheet_cmd_table <- function(mapping_file, sheet_cat, sheet_name, id_var_str) {
  switch (
    sheet_cat,
    "Variables" = mapp_var_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Label"     = mapp_vallab_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Free"      = mapp_free_sheet_cmd_table(mapping_file, sheet = sheet_name),
    "Verbatims" = mapp_verbatim_sheet_cmd_tbl(mapping_file, sheet = sheet_name, id_var_str = id_var_str)
  )

}


generate_cmd_expression <- function(action, data) {
  # Hack to prevent R CMD CHECK note
  # "no visible binding for global variable ‘df’":
  df <- NULL

  switch (
    action,
    "#RECNA"  = rlang::expr(set_na_to_filter_except(df, !!!data)),
    "#MERGE"  = rlang::expr(cmd_merge_df(df, !!!data)),
    "#RFUN"   = rlang::expr(cmd_rfun(df, !!!data)),
    "#R"      = rlang::expr(cmd_r_df(df, !!!data)),
    "#IF"     = rlang::expr(cmd_if_df(df, !!!data)),
    "#COMP"   = rlang::expr(cmd_comp_df(df, !!!data)),
    # TODO: find cleaner way to deal with this!
    "#COMPR"  = rlang::expr(cmd_compr_df(df, !!!data)),
    "#REC"    = rlang::expr(cmd_rec_df(df, !!!data)),
    "#NEWVALL"= rlang::expr(cmd_add_labs_df(df, !!!data)),
    "#AUTOREC"= rlang::expr(cmd_autorec_df(df, !!!data)),
    "#STR2NUM"= rlang::expr(cmd_str_to_num_df(df, !!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar_df(df, !!!data)),
    "#RENAME" = rlang::expr(cmd_rename(df, !!!data)),
    "#DROP"   = rlang::expr(cmd_drop(df, !!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab_df(df, !!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab_df(df, !!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs_df(df, !!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs_df(df, !!!data)),
    "#DIC"    = rlang::expr(cmd_dic_df(df, !!!data)),
    "#KG"     = rlang::expr(cmd_kg_df(df, !!!data)),
    "#verbatim"  = rlang::expr(cmd_verbatim_df(df, !!!data)),
    stop("Invalid action command")
  )
}

apply_one_cmd <- function(df, action, data) {
  cmd <- generate_cmd_expression(action, data)
  rlang::eval_tidy(cmd)
}

apply_one_cmd_safe <- function(df1, action, data) {
  cmd_index <- attr(df1, "cmd_index") + 1
  attr(df1, "cmd_index") <- cmd_index
  res <- tryCatch({
      err_msg <- NA_character_
      apply_one_cmd(df1, action, data)
    },
    error = function(e) {
      err_msg <- geterrmessage()[1]
      attr(df1, "error_list")[cmd_index] <- err_msg
      print(
        paste(
          "Error in command",
          cmd_index,
          ": ",
          err_msg)
        )
      df1
    }
  )
  res
}


#' Apply changes of mapping Excel file to dataframe
#'
#' The commands entered in the mapping file can be excuted on the data set with
#' this function. A template of a mapping file with existing label information
#' of a labelled dataset can be created with \code{mapp_create()}. The mapping
#' file consists of the sheets "Variables", "Label", "Verbatims" & "Free". Each
#' of these controlls different aspects of data manipulations you can apply to a
#' labelled dataset. You can add as much of those sheets as you want to the file
#' (they just have to start by one of these strings) and therein enter commands
#' to manipulate variables. The sequence of commands is executed in the same
#' order as the sequence of sheets in the mapping file.
#'
#' @param df dataframe to apply mapping on
#' @param mapping_file name of the mapping Excel file or the object returned by
#'   `mapp_cmd_table()` of this path
#' @param na_to_filter logical; if TRUE, NA values of numerical variables in df
#'   will be replaced by -2 with the value label "FILTER".
#' @param try_catch logical; if TRUE, command blocks of the mapping file
#'   that error out will be skipped; possible errors are attached to the
#'   dataframe as a character vector of length of all the commands in the
#'   command table; in combination with `rec_fun` = `purrr::accumulate2` this
#'   can be used to examine intermediate results, in order to find the reason
#'   for the error. Alternatively, run the script created by
#'   `translate_to_r_script()`.
#' @param rec_fun function either purrr::reduce2 or purrr::accumulate2; see
#'   Value section
#' @param check_id_is_unique logical whether to check that the specified id
#'   variable (in sheet "configr") is unique; defaults to TRUE.
#' @param translate_xlsm logical whether to translate the format of Wolf's mapping file to the format of `mapp_create()``
#' @param vectorized logical whether groups of command blocks to calculate
#' new vectors are applied to the data in a single `dplyr::mutate()`
#' statement or whether to consecutively apply (by using `purrr::reduce()`)
#' each command expression on the whole data frame. Probably something similar as the difference between:
#' dataframe() %>% mutate(a = 1) %>% mutate(b = 2) or
#' dataframe() %>% mutate(a = 1, b = 2).
#' The second is faster. For many data operations or large datasets,
#' vectorized = TRUE should also be faster
#'
#' @return in case rec_fun = purrr::reduce2 only the final dataframe is returned
#'   in case of purrr::accumulate2 a list with all intermediate dataframes (of
#'   every command block) is returned
#' @export
#'
#' @examples
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_file)
#'
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' # This command creates an overview table:
#' df_cmd <- mapp_cmd_table(mapping_file, add_r_command_colum = TRUE)
#'
#' mapp_xl_to_data(df, mapping_file)
#'
#'
#' df_mod_list <- mapp_xl_to_data(
#'   df,
#'   mapping_file,
#'   try_catch = TRUE,
#'   rec_fun = purrr::accumulate2
#' )
#' # For `try_catch = TRUE`, an attribute called "error_list" is added to the result
#' # of `mapp_xl_to_data()`:
#' error_list <- attr(df_mod_list, "error_list")
#' error_list
#'
#' # Add further columns to df_cmd:
#' # The first element of df_mod_list is the initial state of df:
#' df_cmd["intermediate df"] <- list(df_mod_list[-1])
#' df_cmd["error"] <- error_list
#' df_cmd
#' # In RStudio type: View(df_cmd)
mapp_xl_to_data <- function(df, mapping_file, na_to_filter = TRUE,
                            try_catch = FALSE, rec_fun = purrr::reduce2,
                            translate_xlsm = FALSE, check_id_is_unique = TRUE,
                            vectorized = FALSE) {
  if (typeof(mapping_file) == "character") {
    cmd_table <- mapp_cmd_table(
      mapping_file,
      translate_xlsm = translate_xlsm,
      na_to_filter = na_to_filter,
      vectorized = vectorized
    )
  }
  else if (is.data.frame(mapping_file)) {
    cmd_table <- mapping_file
  }
  else {
    stop("
         mapping_file has to be either the file path to the mapping file,
         or the command table data frame (returned by `mapp_cmd_table()`) of this path!")
  }
  if (attr(cmd_table, "vectorized") != vectorized) {
    stop("The command table data frame has to be generated with the same value of the `vectorized` argument.")
  }
  id_var <- attr(cmd_table, "id_var")
  if (check_id_is_unique & length(unique(df[[id_var]])) < nrow(df)) {
    stop("Defined id variable ", id_var, " is not unique")
  }


  if (try_catch) {
    datenanpassr.env$cmd_index <- 0
    datenanpassr.env$error_list <- vector("character", length = nrow(cmd_table))

    apply_one_cmd <- apply_one_cmd_safe
    # rec_fun <- purrr::accumulate2
  }
  if (vectorized) {
    cmd_table <- group_vectorizable_cmds(cmd_table, try_catch = try_catch)
    apply_one_cmd <- ifelse(try_catch, apply_one_group_cmd_safe, apply_one_group_cmd)

  }

  res <- rec_fun(cmd_table$action, cmd_table$data, apply_one_cmd, .init = df)
  if (try_catch) {
    attr(res, "cmd_index") <- datenanpassr.env$cmd_index
    attr(res, "error_list") <- datenanpassr.env$error_list
  }
  res
}

#' Relpace NA values by `replace_val` labelled by `replace_label`
#'
#' @param var numeric variable
#' @param replace_val numeric value, NAs are replaced by; defaults to -2
#' @param replace_label character value, value label `replace_val` will be
#' labelled by; defaults to "FILTER"
#'
#' @return `var` where NAs are replaced by `replace_val` with added label `replace_label`
#' @export
#'
#' @examples
#' x <- haven::labelled(c(1, NA), labels = c("value label of 1" = 1))
#' set_na_to_filter(x)
set_na_to_filter <- function(var, replace_val = -2, replace_label = "FILTER") {
  old_vallab_vec <- attr(var, "labels")
  added_vallab_vec <- purrr::set_names(replace_val, replace_label)
  new_vallab_vec <- merge_vallabs(old_vallab_vec, added_vallab_vec)
  var[is.na(var)] <- replace_val
  haven::labelled(
    var,
    labels = new_vallab_vec,
    label = attr(var, "label", exact = TRUE)
  )
}


#' Translate Excel mapping file to R script
#'
#' This function generates an R script with the command blocks of the Excel mapping file
#' translated to R code. When the created script is run, the resulting dataframe df should be equal to
#' the result of `mapp_xl_to_data()`.
#'
#' @param df_cmd dataframe returned by `mapp_cmd_table()`
#' @param rscript_name file name of the script
#' @param spss_file file name of the SPSS dataset
#'
#' @export
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
#' spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df_cmd <- mapp_cmd_table(mapping_file)
#' \dontrun{
#' translate_to_r_script(df_cmd, rscript_name = "mapping.R", spss_file)
#' # For an illustration of the internal differences when using vectorized = TRUE in
#' # `mapp_xl_to_data()`, compare the resulting script
#' # "mapping.R", with the vectorized version:
#' df_cmd_vec <- mapp_cmd_table(mapping_file, vectorized = TRUE)
#' translate_to_r_script(df_cmd_vec, rscript_name = "mapping_vec.R", spss_file)
#' }
translate_to_r_script <- function(
  df_cmd,
  rscript_name = "mapping.R",
  spss_file
  ) {
  if (attr(df_cmd, "vectorized") == TRUE) {
    df_cmd <- group_vectorizable_cmds(df_cmd)
    generate_cmd_expression <- generate_group_expr
  }
  cmd_list <-
    purrr::map2(df_cmd$action, df_cmd$data, ~deparse(generate_cmd_expression(.x, .y))) %>%
    purrr::map(~c("df <- ", paste0("  ", .x)))
  script_start <- c(
    # "library(tidyverse)",
    "library(datenanpassr)",
    paste0("df <- haven::read_sav('", spss_file, "')")
  )
  append(
    script_start,
    cmd_list
  ) %>%
    unlist() %>%
    readr::write_lines(rscript_name)

}
