#' Create a summary table of the data modifications list read in from the
#' Excel mapping file
#'
#' @param mapping_file filename of the Excel mapping file
#' @param add_r_command_colum logical, whether to add a column `"R command"`
#' @param translate_xlsm logical, whether to translate from Wolf's format
#' specifying the corresponding R command; defaults to FALSE
#'
#' @return
#' @export
#'
#' @examples
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_filepath)
#' }
#' mapp_cmd_table(mapping_filepath)
#' # Add column for R command:
#' mapp_cmd_table(mapping_filepath, add_r_command_colum = TRUE)
mapp_cmd_table <- function(mapping_file, add_r_command_colum = FALSE, translate_xlsm = FALSE) {
  id_var_str <- get_id_var(mapping_file)


  sheets <- mapping_file %>% readxl::excel_sheets()

  # exchange positions of "Variables" & "Label" sheets (because otherwise,
  # renaming a variable in the "Variables" sheet will not work when creating a
  # summary variable out of it):
  if ("Variables" %in% sheets & "Label" %in% sheets) {
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

  df_cmd <- purrr::map2_dfr(
    sheets %>%
      purrr::set_names(),
    sheet_cats,
    ~ make_sheet_cmd_table(mapping_file, .y, .x, translate_xlsm = translate_xlsm, id_var_str = id_var_str),
    .id = "sheet"
  ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(data = transl_human_read(action, data))
  if (add_r_command_colum) {
    cmd_list <- purrr::map2(df_cmd$action, df_cmd$data, ~deparse(make_cmd_expression(.x, .y)))
    # print(cmd_list)
    df_cmd["R command"] <-
      tibble::tibble(a = cmd_list) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(a = list(paste(stringr::str_squish(a), collapse = " "))) %>%
      tidyr::unnest(a)
  }
  df_cmd
}
make_sheet_cmd_table <- function(mapping_file, sheet_cat, sheet_name, translate_xlsm, id_var_str) {
  switch (
    sheet_cat,
    "Variables" = mapp_var_sheet_cmd_table(mapping_file, sheet = sheet_name, translate_xlsm = translate_xlsm),
    "Label"     = mapp_vallab_sheet_cmd_table(mapping_file, sheet = sheet_name, translate_xlsm = translate_xlsm),
    "Free"      = mapp_free_sheet_cmd_table(mapping_file, sheet = sheet_name, translate_xlsm = translate_xlsm),
    "Verbatims" = mapp_verbatim_sheet_cmd_tbl(mapping_file, sheet = sheet_name, id_var_str = id_var_str)
  )

}


make_cmd_expression <- function(action, data) {
  switch (
    action,
    "#MERGER" = rlang::expr(cmd_merge(df, !!!data)),
    "#IF"     = rlang::expr(cmd_if(df, !!!data)),
    "#COMP"   = rlang::expr(cmd_comp(df, !!!data)),
    # TODO: find cleaner way to deal with this!
    "#COMPR"   = rlang::expr(cmd_comp(df, !!!data)),
    "#REC"    = rlang::expr(cmd_rec(df, !!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar(df, !!!data)),
    "#RENAME" = rlang::expr(cmd_rename(df, !!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab(df, !!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab(df, !!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs(df, !!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs(df, !!!data)),
    "#DIC"    = rlang::expr(cmd_dic(df, !!!data)),
    "#KG"     = rlang::expr(cmd_kg(df, !!!data)),
    "#Verba"  = rlang::expr(cmd_verbatim(df, !!!data)),
    stop("Invalid action command")
  )
}

apply_one_cmd <- function(df, action, data) {
  cmd <- make_cmd_expression(action, data)
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
#' The commands entered in the mapping file can be excuted on the data set
#' with this function.
#' A template of a mapping file with existing label information of a labelled dataset
#' can be created with \code{mapp_create()}. The mapping file consists of
#' the sheets "Variables", "Label", "Verbatims" & "Free".
#' Each of these controlls different aspects of data manipulations you can apply
#' to a labelled dataset. You can add as much of those sheets as you want to the
#' file (they just have to start by one of these strings) and therein enter
#' commands to manipulate variables. The
#' sequence of commands is executed in the same order as the sequence of sheets in the mapping file.
#'
#' @param df dataframe to apply mapping on
#' @param mapping_file name of the mapping Excel file or the object returned by
#' `mapp_cmd_table()` of this path
#' @param na_to_filter logical; if TRUE, NA values of numerical variables in df will
#' be replaced by -2 with the value label "FILTER".
#' @param input_if_error logical; if TRUE, command blocks of the mapping file
#' that error out will be skipped; possible errors are attached to the dataframe
#' as a character vector of length of all the commands in the command table;
#' in combination with
#' `rec_fun` = `purrr::accumulate2` this can be used to examine intermediate
#' results, in order to find the reason for the error. Alternatively, run the script
#' created by `translate_to_r_script()`.
#' @param rec_fun function either purrr::reduce2 or purrr::accumulate2; see Value section
#'
#' @return in case rec_fun = purrr::reduce2 only the final dataframe is returned
#' in case of purrr::accumulate2 a list with all intermediate dataframes (of
#' every command block) is returned
#' @export
#'
#' @examples
#' spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_filepath)
#'
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_filepath)
#' }
#' # This command creates an overview table:
#' df_cmd <- mapp_cmd_table(mapping_filepath, add_r_command_colum = TRUE)
#'
#' mapp_xl_to_data(df, mapping_filepath)
#'
#'
#' df_mod_list <- mapp_xl_to_data(
#'   df,
#'   mapping_filepath,
#'   input_if_error = TRUE,
#'   rec_fun = purrr::accumulate2
#' )
#' # show the error list of the final data frame in the list:
#' error_list <- attr(df_mod_list[[length(df_mod_list)]], "error_list")
#' error_list
#'
#' # Add further columns to df_cmd:
#' # The first element of df_mod_list is the initial state of df:
#' df_cmd["intermediate df"] <- list(df_mod_list[-1])
#' df_cmd["error"] <- error_list
#' df_cmd
#' # In RStudio type: View(df_cmd)
mapp_xl_to_data <- function(df, mapping_file, na_to_filter = TRUE,
                            input_if_error = FALSE, rec_fun = purrr::reduce2,
                            translate_xlsm = FALSE) {
  if (typeof(mapping_file) == "character") {
    cmd_table <- mapp_cmd_table(mapping_file, translate_xlsm = translate_xlsm)
  }
  else if (is.data.frame(mapping_file)) {
    cmd_table <- mapping_file
  }
  else {
    stop("
         mapping_file has to be either the file path to the mapping file,
         or the command table data frame (returned by `mapp_cmd_table()`) of this path!")
  }

  if (na_to_filter == TRUE) {
    df <- df %>% dplyr::mutate_if(is.numeric, set_na_to_filter)
  }

  if (input_if_error) {
    attr(df, "cmd_index") <- 0
    attr(df, "error_list") <- vector("character", length = nrow(cmd_table))

    apply_one_cmd <- apply_one_cmd_safe
    # rec_fun <- purrr::accumulate2
  }

  rec_fun(cmd_table$action, cmd_table$data, apply_one_cmd, .init = df)
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
#' When the created script is run, the resulting dataframe df should be equal to
#' the result of `mapp_xl_to_data()`.
#'
#' @param df_cmd dataframe returned by `mapp_cmd_table()`
#' @param rscript_name file name of the script
#' @param spss_filepath file name of the SPSS dataset
#'
#' @return
#' @export
#'
#' @examples
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' # open this Excel file (that comes with the package) via:
#' \dontrun{
#' utils::browseURL(mapping_filepath)
#' }
#' spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df_cmd <- mapp_cmd_table(mapping_filepath)
#' \dontrun{
#' translate_to_r_script(df_cmd, rscript_name = "mapping.R", spss_filepath)
#' }
translate_to_r_script <- function(
  df_cmd,
  rscript_name = "mapping.R",
  spss_filepath
  ) {
  cmd_list <-
    purrr::map2(df_cmd$action, df_cmd$data, ~deparse(make_cmd_expression(.x, .y))) %>%
    purrr::map(~c("df <- ", paste0("  ", .x)))
  script_start <- c(
    # "library(tidyverse)",
    "library(datenanpassr)",
    paste0("df <- haven::read_sav('", spss_filepath, "')")
  )
  append(
    script_start,
    cmd_list
  ) %>%
    unlist() %>%
    readr::write_lines(rscript_name)

}
