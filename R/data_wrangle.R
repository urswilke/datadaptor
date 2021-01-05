extract_sev_lists <- function(var) {
  l_sev_parts <-
    var %>%
    stringr::str_squish() %>%
    stringr::str_extract_all("(\\{.+?\\})", simplify = T) %>%
    purrr::map(~stringr::str_remove_all(.x, "[\\{\\}]")) %>%
    stringr::str_split(" +", simplify = T) %>%
    tibble::as_tibble(.name_repair = "unique")

  replace_1curly <- function(orig_str, replacement) stringr::str_replace(orig_str,  "\\{.+?\\}", replacement)
  replace_all_curlies <- function(orig_str, l_1sev_parts) purrr::reduce(l_1sev_parts, replace_1curly, .init = orig_str)
  if (!all(dim(l_sev_parts) == c(0,0))) {
    l_sev_parts %>% purrr::map_chr(~replace_all_curlies(var, .x)) %>% unname()
  }
  else {
    var
  }
}

#' Turn one line of code into multiple replacing the curly braces by each of the parts
#'
#' This function turns one line of code of an "#IF" or "#COMP" block into
#' multiple replacing the curly braces
#' by each of the parts inside (separated by spaces).
#'
#' @param df_f1 code blocks read in by \code{mapp_free1()}
#'
#' @return
#' @export
#'
#' @examples
#' df_free <- data.frame(X1 = "#IF", X2 = "q{2 3} == 1", X3 = "kq{5 6} = {7 8}")
#' severalize(df_free)
severalize <- function(df_f1) {
  if (!is.na(df_f1$X1) & stringr::str_detect(df_f1$X1, "(^#IF|^#COMP)")) {
    df_f1 %>%
      dplyr::filter_all(dplyr::any_vars(!is.na(.))) %>%
      dplyr::mutate_at(2:3, ~purrr::map(.x,~extract_sev_lists(.))) %>%
      tidyr::unnest(cols = c("X2", "X3"))

  }
  else {
    df_f1
  }
}

#' Severalize all #IF & #COMP commands
#'
#' @param df_free1 commands of the Excel mapping's "free" sheet
#'
#' @return
#' @export
#'
#' @examples
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' df_free1 <- mapp_free1(mapping_filepath)
#' sevif(df_free1)
sevif <- function(df_free1) {
  df_free1 %>%
    dplyr::rowwise() %>%
    dplyr::group_split() %>%
    purrr::map_dfr(severalize)
}


make_sumvar_cmd_table <- function(df_vall) {
  df_vall %>%
    tidyr::drop_na(sum_var_value) %>%
    dplyr::select(-new_label) %>%
    dplyr::mutate(new_var = paste0("k", var)) %>%
    dplyr::mutate(orig_var = var) %>%
    dplyr::group_by(new_var, orig_var) %>%
    dplyr::mutate(row = paste(row, collapse = ", ")) %>%
    dplyr::mutate(sheet = "Label") %>%
    dplyr::mutate(action = "#SUMVAR") %>%
    dplyr::relocate(sheet, action)  %>%
    dplyr::group_by(sheet, action, row, new_var) %>%
    tidyr::nest()
}

make_varlab_cmd_table <- function(df_varl) {
  df_varl %>%
    dplyr::mutate(row = (dplyr::row_number() + 1) %>% as.character()) %>%
    tidyr::drop_na(new_label) %>%
    dplyr::mutate(new_var = var) %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#NEWLAB") %>%
    dplyr::group_by(sheet, action, row, new_var) %>%
    tidyr::nest()
}


make_free_cmd_table <- function(df_f1) {
  if (nrow(df_f1) == 0) {
    return(tibble::tibble())
  }
  res <- df_f1 %>%
    dplyr::mutate(index = cumsum(dplyr::coalesce(stringr::str_detect(X1, "^#"), FALSE))) %>%
    dplyr::group_by(index) %>%
    dplyr::mutate(row = paste(row, collapse = ", ")) %>%
    dplyr::mutate(action = X1[1]) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(sheet = "Free1") %>%
    dplyr::select(-index) %>%
    sevif() %>%
    dplyr::group_by(action, row)
  res %>%
    dplyr::mutate(
      new_var = dplyr::case_when(
        action == "#REC"                 ~ X3[1],
        action == "#IF"                  ~ stringr::str_remove(X3, "=.*") %>% stringr::str_squish(),
        action == "#COMP"                ~ X2,
        action == "#VARL"                ~ X2,
        action == "#KG"                  ~ paste(X2, X3, sep = "_"),
        action %in% c("#VALL", "#AVALL") ~ X2[1]
      )
    ) %>%
    dplyr::group_by(sheet, action, row, new_var) %>%
    tidyr::nest() %>%
    dplyr::ungroup()
}



#' Create a summary table of the data modifications list read in from the
#' Excel mapping file
#'
#' @param filename filename of the Excel mapping file
#' @param add_r_command_colum logical, whether to add a column `"R command"`
#' specifying the corresponding R command; defaults to FALSE
#'
#' @return
#' @export
#'
#' @examples
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapp_cmd_table(mapping_filepath)
#' # Add column for R command:
#' mapp_cmd_table(mapping_filepath, add_r_command_colum = TRUE)
mapp_cmd_table <- function(filename, add_r_command_colum = FALSE, translate_xlsm = FALSE) {
  sheets <- filename %>% readxl::excel_sheets()

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
    ~ make_sheet_cmd_table(filename, .y, .x, translate_xlsm = translate_xlsm),
    .id = "sheet"
  ) %>%
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
make_sheet_cmd_table <- function(filename, sheet_cat, sheet_name, translate_xlsm) {
  switch (sheet_cat,
          "Variables" = mapp_varl(filename, sheet = sheet_name, translate_xlsm = translate_xlsm) %>% make_varlab_cmd_table(),
          "Label" = mapp_vall(filename, sheet = sheet_name, translate_xlsm = translate_xlsm) %>% make_sumvar_cmd_table(),
          "Free" = mapp_free1(filename, sheet = sheet_name, translate_xlsm = translate_xlsm) %>% make_free_cmd_table(),
          "Verbatims" = make_verbatim_cmd_table(filename, sheet = sheet_name)
  )

}


make_cmd_expression <- function(action, data) {
  switch (
    action,
    "#IF"     = rlang::expr(cmd_if(df, !!!data)),
    "#COMP"   = rlang::expr(cmd_comp(df, !!!data)),
    "#REC"    = rlang::expr(cmd_rec(df, !!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar(df, !!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab(df, !!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab(df, !!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs(df, !!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs(df, !!!data)),
    "#KG"     = rlang::expr(cmd_kg(df, !!!data)),
    "#Verba"  = rlang::expr(cmd_verba(df, !!!data)),
    stop("Invalid action command")
  )
}

apply_one_cmd <- function(df, action, data) {
  cmd <- make_cmd_expression(action, data)
  rlang::eval_tidy(cmd)
}

apply_one_cmd_safe <- function(df1, action, data) {
  res <- tryCatch({
      # i_cmd <<- i_cmd + 1
      err_msg <- NA_character_
      apply_one_cmd(df1, action, data)
    },
    error = function(df1) {
      err_msg <- geterrmessage()[1]
      print(err_msg)
      df1
    }
  )
  # BAD STYLE!
  # TODO: find better method
  error_list <<- append(error_list, err_msg)
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
#' @param filename name of the Excel file with mappings
#' @param na_to_filter logical; if TRUE, NA values of numerical variables in df will
#' be replaced by -2 with the value label "FILTER".
#' @param input_if_error logical; if TRUE, command blocks of the mapping file
#' that error out will be skipped; for this option to work the object `error_list`
#' needs to be created beforehand (see examples); in combination with
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
#' # This command creates an overview table:
#' df_cmd <- mapp_cmd_table(mapping_filepath, add_r_command_colum = TRUE)
#'
#' mapp_xl_to_data(df, mapping_filepath)
#'
#'
#' # For the option input_if_error = TRUE to work, the following object
#' # `error_list` has to be created beforehand:
#' error_list <- character()
#' df_mod_list <- mapp_xl_to_data(df, mapping_filepath, input_if_error = TRUE, rec_fun = purrr::accumulate2)
#' error_list
#'
#' # Add further columns to df_cmd:
#' # The first element of df_mod_list is the initial state of df:
#' df_cmd["intermediate df"] <- list(df_mod_list[-1])
#' df_cmd["error"] <- error_list
#' df_cmd
#' # In RStudio type: View(df_cmd)
mapp_xl_to_data <- function(df, filename, na_to_filter = TRUE,
                            input_if_error = FALSE, rec_fun = purrr::reduce2,
                            translate_xlsm = FALSE) {
  cmd_table <- mapp_cmd_table(filename, translate_xlsm = translate_xlsm)

  if (na_to_filter == TRUE) {
    df <- df %>% dplyr::mutate_if(is.numeric, set_na_to_filter)
  }

  if (input_if_error) {
    apply_one_cmd <- apply_one_cmd_safe
    # rec_fun <- purrr::accumulate2
  }

  rec_fun(cmd_table$action, cmd_table$data, apply_one_cmd, .init = df)
}

#' Relpace NA values by `replace_val` labelled by "FILTER"
#'
#' @param var numeric variable
#' @param replace_val numeric value, NAs are replaced by; defaults to -2
#' @param replace_label character value, value label `replace_val` will be
#' labelled by; defaults to "FILTER"
#'
#' @return `var` where NAs are replaced by `replace_val`
#' @export
#'
#' @examples
#' x <- haven::labelled(c(1, NA), labels = c("value label of 1" = 1))
#' set_na_to_filter(x)
set_na_to_filter <- function(var, replace_val = -2, replace_label = "FILTER") {
  labels_vec <- dplyr::full_join(
    attr(var, "labels") %>% tibble::enframe(),
    setNames(replace_val, replace_label) %>% tibble::enframe(),
    by = c("name", "value")
  ) %>% dplyr::distinct(value, .keep_all = T) %>%
    tibble::deframe()
  var[is.na(var)] <- replace_val
  haven::labelled(
    var,
    labels = labels_vec,
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
    "library(tidyverse)",
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
