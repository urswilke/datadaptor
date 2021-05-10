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
#' @param mapping name of the mapping Excel file or the object returned by
#'   `mapp_cmd_table_()` of this path
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
#' mapping <- datenanpassr:::mapp_cmd_table_(mapping_file, add_r_command_colum = TRUE)
#'
#' df_cmd <- mapp_xl_to_data(df, mapping)
#'
#'
#' df_mod_list <- mapp_xl_to_data(
#'   df,
#'   mapping,
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
mapp_xl_to_data <- function(df, mapping, na_to_filter = TRUE,
                            try_catch = FALSE, rec_fun = purrr::reduce2,
                            check_id_is_unique = TRUE,
                            vectorized = FALSE) {
  data_mapping <- mapp_xl_to_data_(
    df = df,
    mapping = mapping,
    check_id_is_unique = check_id_is_unique,
    na_to_filter = na_to_filter,
    try_catch = try_catch,
    rec_fun = rec_fun,
    vectorized = vectorized
  )
  data_mapping$df_mod
}

mapp_xl_to_data_ <- function(df, mapping, check_id_is_unique = TRUE, ...) {
  # HACK to create a subclass of "mapping" with class attribute "cmd_table"
  # added and df_cmd calculated by generate_cmd_table():
  # TODO: implement cleaner solution as in
  # https://adv-r.hadley.nz/s3.html#s3-subclassing
  mapping <- as_cmd_table(mapping, check_id_is_unique = check_id_is_unique, ...)

  # if a mapping object without subclass is passed to mapp_xl_to_data_(), the
  # dataset has to be set afterwards (HACKY):
  mapping$data <- df


  # TODO: move to validate() function:
  id_var <- mapping$id_var
  if (check_id_is_unique & length(unique(df[[id_var]])) < nrow(df)) {
    stop("Defined id variable ", id_var, " is not unique")
  }



  mapping$df_mod <- apply_commands_to_dataset(mapping)
  mapping
  structure(
    mapping,
    class = c("data_mod", class(mapping))
  )
}

apply_commands_to_dataset <- function(mapping) {
  cmd_table <- mapping$df_cmd
  vectorized <- mapping$vectorized
  try_catch <- mapping$try_catch
  rec_fun <- mapping$rec_fun
  if (try_catch) {
    datenanpassr.env$cmd_index <- 0
    datenanpassr.env$error_list <- vector("character", length = nrow(cmd_table))

  }
  if (vectorized) {
    cmd_table <- group_vectorizable_cmds(cmd_table, try_catch = try_catch)
  }
  # add the class property to the dataset (first function arg of apply_one_cmd),
  # in order to make it choose the right method:
  classy_df <- new_dataset_class(mapping, vectorized, try_catch)
  df_mod <- rec_fun(cmd_table$action, cmd_table$data, apply_one_cmd, .init = classy_df)
  if (try_catch) {
    attr(df_mod, "cmd_index") <- datenanpassr.env$cmd_index
    attr(df_mod, "error_list") <- datenanpassr.env$error_list
  }
  df_mod
}

# HACK to generate a subclass string which represents the 4 possible
# combinations of two booleans; S3 doesnt offer double dispatch...
# another possibility would be this:
# https://gist.github.com/wch/adf13fd291976d6bf312
new_dataset_class <- function(mapping, vectorized, try_catch) {
  vectorized_try_catch_pair_string <- get_vectorized_try_catch_pair_string(vectorized, try_catch)

  structure(
    mapping$data,
    class = c(vectorized_try_catch_pair_string, class(mapping$data))
  )
}
get_vectorized_try_catch_pair_string <- function(vectorized, try_catch) {
  dplyr::case_when(
    try_catch == FALSE                       ~ "unsafe",
    vectorized == FALSE & try_catch == TRUE  ~ "nonvec_safe",
    vectorized == TRUE  & try_catch == TRUE  ~ "vec_safe"
  )
}

#' Translate Excel mapping file to R script
#'
#' This function generates an R script with the command blocks of the Excel mapping file
#' translated to R code. When the created script is run, the resulting dataframe df should be equal to
#' the result of `mapp_xl_to_data()`.
#'
#' @param mapping_file Path of the Excel mapping file (character vector) or object of class "mapping".
#' @param rscript_name file name of the R script to be saved.
#' @param spss_file file name of the SPSS dataset, the mapping is applied on.
#' @param ... Arguments passed to `new_mapping()` (only `vectorized` has an effect).
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
#' mapping <- datenanpassr:::mapp_cmd_table_(mapping_file)
#' \dontrun{
#' translate_to_r_script(mapping, rscript_name = "mapping.R", spss_file)
#'
#' # Alternatively, pass the file pass directly without saving the mapping to an object:
#' translate_to_r_script(mapping_file, rscript_name = "mapping.R", spss_file)
#' # For an illustration of the internal differences when using vectorized = TRUE in
#' # `mapp_xl_to_data()`, compare the resulting script
#' # "mapping.R", with the vectorized version:
#' mapping_vec <- datenanpassr:::mapp_cmd_table_(mapping_file, vectorized = TRUE)
#' translate_to_r_script(mapping_vec, rscript_name = "mapping_vec.R", spss_file)
#' }
translate_to_r_script <- function(
  mapping_file,
  rscript_name = "mapping.R",
  spss_file,
  ...
  ) {
  mapping <- as_cmd_table(mapping_file, ...)
  df_cmd <- mapping$df_cmd
  if (mapping$vectorized == TRUE) {
    df_cmd <- group_vectorizable_cmds(df_cmd)
  }
  cmd_list <-
    purrr::map2(df_cmd$action, df_cmd$data, ~deparse(generate_cmd_expression(.x, .y))) %>%
    purrr::map(~c("df <- ", paste0("  ", .x)))
  script_start <- c(
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
