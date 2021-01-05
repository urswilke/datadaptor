#' Set variable label of variable orig_var in dataframe df
#'
#' @param df dataframe
#' @param orig_var character string of (labelled) variable
#' @param new_label character string of new label
#'
#' @return
#' @export
#'
#' @examples
#' df <- data.frame(x = 1)
#' df <- set_lab(df, "x", "I'm the variable label")
#' df$x
set_lab <- function(df, orig_var, new_label){
  df[[orig_var]] <- haven::labelled(
    df[[orig_var]],
    labels = attr(df[[orig_var]], "labels"),
    label = new_label
  )
  df
}

#' Set value labels of labelled variable var in dataframe df
#'
#' @param df dataframe
#' @param orig_var character string of (labelled) variable in df
#' @param new_label character string of new label
#'
#' @return
#' @export
#'
#' @examples
#' df <- data.frame(x = 1:2)
#' df <- set_labs(df, "x", new_vals = 1:2, new_labs = c("value for 1", "value for 2"))
#' df$x
set_labs <- function(df, orig_var, new_lab = attr(orig_var, "label", exact = TRUE), new_vals, new_labs){
  df[[orig_var]] <- haven::labelled(
    df[[orig_var]],
    labels = purrr::set_names(new_vals, new_labs),
    label = new_lab
  )
  df
}

#' Add value labels to variable orig_var in dataframe df
#'
#' @param df dataframe
#' @param orig_var variable
#' @param new_lab new variable label
#' @param vals_added values added
#' @param labs_added value labels added
#'
#' @return
#' @export
#'
#' @examples
#' x <- haven::labelled(1:2, labels = c("value for 1" = 1), label = "var label")
#' df <- data.frame(x)
#' df <- add_labs(df, orig_var = "x", vals_added = 2, labs_added = c("value for 2"))
#' df$x
add_labs <- function(df, orig_var, new_lab = NULL, vals_added, labs_added){
  labs <- c(attr(df[[orig_var]], "labels") %>% names(), labs_added)
  vals <- c(attr(df[[orig_var]], "labels") %>% unname(), vals_added)
  if(is.null(new_lab))
    varlab <-  attr(df[[orig_var]], "label", exact = TRUE)
  else
    varlab <- new_lab

  df[[orig_var]] <- haven::labelled(
    df[[orig_var]],
    labels = purrr::set_names(vals, labs),
    label = varlab
  )
  df
}


kg_mix <- function(df, var1, var2) {
  var_kg <- paste(var1, var2, sep = "_")
  var_kg_factor <- df %>%
    dplyr::transmute(!!var_kg := forcats::fct_cross(!!rlang::sym(var1) %>% forcats::as_factor(), !!rlang::sym(var2) %>% forcats::as_factor())) %>% dplyr::pull()
  labels_vec <- var_kg_factor %>% levels() %>% purrr::set_names(1:length(.), .)
  var_kg_labelled <- haven::labelled_spss(var_kg_factor, labels = labels_vec)

  df %>%
    dplyr::mutate(!!var_kg := var_kg_labelled)
}

#' Split variable in dataframe into multiple according to the values of another variable
#'
#' Create a set of variables for each value of split_var. The resulting variables
#' are equal to by_var if split_var is equal to the respective value and NA otherwise.
#'
#' @param df data frame
#' @param split_var variable to split by
#' @param by_var variable to be splitted
#'
#' @return
#' @export
#'
#' @examples
#' kg(data.frame(a = 1:3, b = c(3, 3, 4)), "b", "a")
kg <- function(df, split_var, by_var) {
  new_vars <- prepare_newvar_table(df, split_var, by_var)
  new_vars %>%
    purrr::transpose() %>%
    # these 2 lines would do the same
    # rowwise() %>%
    # group_split() %>%
    # add the new variables one by one to the dataframe:
    purrr::reduce(split_cat_by_cat, split_var, by_var, .init = df)
}
prepare_newvar_table <- function(df, split_var, by_var) {
  var2lab <- attr(df[[by_var]], "label", exact = TRUE)
  new_varlabs <-
    df %>%
    dplyr::mutate(id = dplyr::row_number(), !!split_var) %>%
    tablab::tab_all() %>%
    dplyr::filter(var == split_var) %>%
    tidyr::drop_na(nv) %>%
    tidyr::unite(new_varlab, varlab, vallab, sep = " - ") %>%
    dplyr::mutate(new_varlab = paste0(new_varlab, ": ", var2lab)) %>%
    dplyr::select(nv, new_varlab)

  new_varnames <- paste0(
    by_var,
    "x",
    split_var,
    "_",
    new_varlabs$nv
  ) %>% stringr::str_replace("-", "minus")
  new_vars <- new_varlabs %>% dplyr::mutate(new_varnames)
  new_vars
}
split_cat_by_cat <- function(df, new_vars, split_var, by_var) {
  new_vec <- df %>% dplyr::transmute(x = ifelse(!!rlang::sym(split_var) == new_vars$nv, !!rlang::sym(by_var), NA)
  ) %>% dplyr::pull()
  vallabs <- df %>%
    dplyr::pull(!!rlang::sym(by_var)) %>%
    attr(., "labels")
  new_vec <- haven::labelled(new_vec, labels = vallabs, label = new_vars$new_varlab)
  df %>% dplyr::mutate(
    !!rlang::sym(new_vars$new_varnames) := new_vec)

}



#' Create new recoded labelled variable from variable in dataframe
#'
#' @param df dataframe
#' @param new_var name of new recoded variable (character string)
#' @param orig_var name of original variable (character string)
#' @param new_lab string of variable label
#' @param orig_vals
#' @param new_vals numeric vector of labelled values of new recoded variable
#' @param new_labs character vector of value labels of new recoded variable
#'
#' @return
#' @export
#'
#' @examples
#' orig_var <- 1:5
#' new_vals <- new_vals <- c(1, 1, 2, 3, 3)
#' new_labs <- c("1 - 2", "3", "4 - 5")
#' new_lab <- "new variable label"
#' orig_vals <- 1:5
#' new_labs <- c("1-2 summ", NA, "3 summ.", "4-5 summ", NA)
#' df <- data.frame(orig_var)
#' df <- rec_1var(df, "new_var", "orig_var", new_lab, orig_vals, new_vals, new_labs)
#' df
#' df$new_var
rec_1var <- function(df, new_var, orig_var, new_lab = NULL, orig_vals, new_vals, new_labs) {
  sum_var_vals_n_labs <- tibble::tibble(orig_vals, new_vals, new_labs) %>%
    dplyr::group_by(new_vals) %>%
    dplyr::summarise(val_lists = list(orig_vals),
                     val_labs = dplyr::first(new_labs))
  cond_statements <- purrr::map2(
    sum_var_vals_n_labs$val_lists,
    sum_var_vals_n_labs$new_vals,
    ~ rlang::quo(!!rlang::sym(orig_var) %in% !!.x ~ !!.y)
  )



  df <- df %>%
    dplyr::mutate(
      !!rlang::sym(new_var) := dplyr::case_when(!!!cond_statements)
    )
  df[new_var] <- haven::labelled(
      df[[new_var]],
      labels = sum_var_vals_n_labs[-2] %>% dplyr::select(2, 1) %>%  tibble::deframe(),
      label = new_lab
    )
  df
}


#' Recode variable
#'
#' @param orig_var numeric variable to recode
#' @param new_lab new variable label
#' @param lb vector of lower bounds of intervals
#' @param ub vector of upper bounds of intervals (missing values are replaced by the corresponding values of \code{ub})
#' @param new_vals labelled values of recoded variable
#' @param new_labs value labels of recoded variable
#'
#' @details
#' The vectors lb, ub, new_vals and new_labs all need to be of the same length.
#'
#' @return
#' @export
#'
#' @examples
#' orig_var <- 1:5
#' df <- data.frame(orig_var)
#' lb = c(1, 3, 4)
#' ub = c(2, NA, 5)
#' new_vals <- 1:3
#' new_labs <- c("1 - 2", "3", "4 - 5")
#' df <- rec_1var_free(df, orig_var = "orig_var", new_var = "new_var", lb = lb, ub = ub, new_vals = new_vals, new_labs = new_labs)
#' df
#' df$new_var
rec_1var_free <- function(df, orig_var, new_var, new_lab = NULL, lb, ub, new_vals, new_labs) {
  rec_vecs <-
    list(lb, dplyr::coalesce(ub, lb), new_vals)

  cond_statements <-
    purrr::pmap(
      rec_vecs,
      function(x,y,z) rlang::quo(!!rlang::sym(orig_var) >= !!x & !!rlang::sym(orig_var) <= !!y  ~ !!z)
    )

  df <- df %>%
    dplyr::mutate(!!rlang::sym(new_var) := dplyr::case_when(!!!cond_statements))

  df[new_var] <- haven::labelled(
    df[[new_var]],
    labels = purrr::set_names(new_vals, new_labs),
    label = new_lab
  )
  df
}


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


#' Compute variable in data frame according to string expression
#'
#' @param df dataframe
#' @param new_var string of the variable name
#' @param new_val expression string
#'
#' @return
#' @export
#'
#' @examples
#' mutate_comp(data.frame(x = 1:3), "y", "x * 2")
mutate_comp <- function(df, new_var, new_val) {
  # transforms numeric values from character to numeric:
  new_val <- rlang::parse_expr(new_val)

  df %>% dplyr::mutate(!!rlang::sym(new_var) := !!new_val)
}


#' Conditional computing of a variable in a dataframe
#'
#' @param df dataframe
#' @param new_var string of the variable name
#' @param condition character string of the condition
#' @param new_val character string the new value expression  when \code{condition}
#' is fulfilled (numeric string values are transformed to numeric)
#'
#' @return
#' @export
#'
#' @examples
#' mutate_cond(data.frame(x = 1:3), "y", "x == 3", "2")
mutate_cond <- function(df, new_var, condition, new_val) {
  cond <- rlang::parse_expr(condition)
  val <- rlang::parse_expr(new_val)

  df %>% dplyr::mutate(!!rlang::sym(new_var) := ifelse(!!cond, !!val, NA_real_))
}



make_sumvar_cmd_table <- function(df_vall) {
  df_vall %>%
    tidyr::drop_na(sum_var_value) %>%
    dplyr::select(-new_label) %>%
    dplyr::mutate(new_var = paste0("k", var)) %>%
    dplyr::mutate(orig_var = var) %>%
    dplyr::group_by(new_var, orig_var) %>%
    dplyr::mutate(row = paste(row, collapse = ", ")) %>%
    dplyr::mutate(sheet = "Labels") %>%
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
  if (nrow(res) > 0) {
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
  else {
    tibble::tibble()
  }
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
mapp_cmd_table <- function(filename, add_r_command_colum = FALSE) {
  sheets <- filename %>% readxl::excel_sheets()

  sheet_types <- c("^Variables", "^Labels", "^Verbatims", "^Free")

  # vector of sheets with names defined by types:
  sheet_cats <- purrr::map(
    sheets,
    ~stringr::str_detect(.x, sheet_types)
  ) %>%
    purrr::map(
      ~ sheet_types[.x] %>%
        stringr::str_remove("\\^")
    ) %>%
    purrr::set_names(sheets) %>%
    # remove sheets not in sheet types list:
    purrr::compact() %>%
    purrr::map_chr(~.x)

  df_cmd <- purrr::map2_dfr(
    sheets %>%
      purrr::set_names(),
    sheet_cats,
    ~ make_sheet_cmd_table(filename, .y, .x),
    .id = "sheet"
  ) %>%
    dplyr::mutate(data = transl_human_read(action, data))
  if (add_r_command_colum) {
    cmd_list <- map2(df_cmd$action, df_cmd$data, ~deparse(make_cmd_expression(.x, .y)))
    # print(cmd_list)
    df_cmd["R command"] <-
      tibble::tibble(a = cmd_list) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(a = list(paste(stringr::str_squish(a), collapse = " "))) %>%
      tidyr::unnest(a)
  }
  df_cmd
}
make_sheet_cmd_table <- function(filename, sheet_cat, sheet_name) {
  switch (sheet_cat,
          "Variables" = mapp_varl(filename, sheet = sheet_name) %>% make_varlab_cmd_table(),
          "Labels" = mapp_vall(filename, sheet = sheet_name) %>% make_sumvar_cmd_table(),
          "Free" = mapp_free1(filename, sheet = sheet_name) %>% make_free_cmd_table(),
          "Verbatims" = make_verbatim_cmd_table(filename, sheet = sheet_name)
  )

}


make_cmd_expression <- function(action, data) {
  switch (
    action,
    "#IF"     = rlang::expr(mutate_cond(df, !!!data)),
    "#COMP"   = rlang::expr(mutate_comp(df, !!!data)),
    "#REC"    = rlang::expr(rec_1var_free(df, !!!data)),
    "#SUMVAR" = rlang::expr(rec_1var(df, !!!data)),
    "#NEWLAB" = rlang::expr(set_lab(df, !!!data)),
    "#VARL"   = rlang::expr(set_lab(df, !!!data)),
    "#VALL"   = rlang::expr(set_labs(df, !!!data)),
    "#AVALL"  = rlang::expr(add_labs(df, !!!data)),
    "#KG"     = rlang::expr(kg(df, !!!data)),
    "#Verba"  = rlang::expr(assign_verba_val(df, !!!data)),
    stop("Invalid action command")
  )
}

apply_one_cmd <- function(df, action, data) {
  cmd <- make_cmd_expression(action, data)
  rlang::eval_tidy(cmd)
}

apply_one_cmd_safe <- function(df1, action, data) {
  res <- tryCatch({
      i_cmd <<- i_cmd + 1
      apply_one_cmd(df1, action, data)
    },
    error = function(df1) {
      err_msg <- geterrmessage()[1]
      print(err_msg)
      error_list[[i_cmd]] <<- err_msg
      # return(df1)
    }
  )
  if (inherits(res, "character")) {
    res <- df1
  }
  return(res)
}


#' Apply changes of mapping Excel file to dataframe
#'
#' The commands entered in the mapping file can be excuted on the data set
#' with this function.
#' A template of a mapping file with existing label information of a labelled dataset
#' can be created with \code{mapp_create()}. The mapping file consists of
#' the sheets "Variables", "Labels", "Verbatims" & "Free".
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
#' that error out will be skipped; for this option to work two objects `i_cmd`
#' and `error_list` need to be created beforehand (see examples); in combination with
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
#' # For the option input_if_error = TRUE to work, the following two objects
#' # `i_cmd` and `error_list` have to be created beforehand:
#' i_cmd <- 0
#' error_list <- vector("character", nrow(df_cmd))
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
                            input_if_error = FALSE, rec_fun = purrr::reduce2) {
  cmd_table <- mapp_cmd_table(filename)

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
#'
#' @return `var` where NAs are replaced by `replace_val`
#' @export
#'
#' @examples
#' x <- haven::labelled(c(1, NA), labels = c("value label of 1" = 1))
#' set_na_to_filter(x)
set_na_to_filter <- function(var, replace_val = -2) {
  labs = c(attr(var, "labels") %>% names(), "FILTER")
  vals = c(attr(var, "labels") %>% unname() %>% as.numeric(), replace_val)
  var[is.na(var)] <- replace_val
  haven::labelled(
    var,
    labels = setNames(vals, labs),
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
