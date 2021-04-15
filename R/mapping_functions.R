
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
  if (!is_mapping_file(mapping_file) & is.character(mapping_file)) {
    mapping_file <- mapp_cmd_table(
      mapping_file,
      na_to_filter = na_to_filter,
      vectorized = vectorized
    )
  }
  else if (!is_mapping_file(mapping_file)){
    stop("
         mapping_file has to be either the file path to the mapping file,
         or the data structure (returned by `mapp_cmd_table()`) of this path!")
  }
  cmd_table <- attr(mapping_file, "df_cmd")

  if (attr(mapping_file, "vectorized") != vectorized) {
    stop("The command table data frame has to be generated with the same value of the `vectorized` argument.")
  }
  id_var <- attr(mapping_file, "id_var")
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
#' mapping_file <- mapp_cmd_table(mapping_file)
#' \dontrun{
#' translate_to_r_script(mapping_file, rscript_name = "mapping.R", spss_file)
#' # For an illustration of the internal differences when using vectorized = TRUE in
#' # `mapp_xl_to_data()`, compare the resulting script
#' # "mapping.R", with the vectorized version:
#' mapping_file_vec <- mapp_cmd_table(mapping_file, vectorized = TRUE)
#' translate_to_r_script(mapping_file_vec, rscript_name = "mapping_vec.R", spss_file)
#' }
translate_to_r_script <- function(
  mapping_file,
  rscript_name = "mapping.R",
  spss_file
  ) {
  df_cmd <- attr(mapping_file, "df_cmd")
  if (attr(mapping_file, "vectorized") == TRUE) {
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
