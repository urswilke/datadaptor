#' Set variable label of variable var in dataframe df
#'
#' @param df dataframe
#' @param var (labelled) variable
#' @param new_label character string of new label
#'
#' @return
#' @export
#'
#' @examples
#' set_lab(data.frame(x = 1), "x", "I'm the variable label") %>% str()
set_lab <- function(df, var, new_label){
  df %>%
    dplyr::mutate(
      !!var := haven::labelled(
        df[[var]],
        labels = attr(df[[var]], "labels"),
        label = new_label
      )
    )
}

#' Set value labels of labelled variable var in dataframe df
#'
#' @param df dataframe
#' @param data data with label information
#'
#' @return
#' @export
#'
#' @examples
set_labs <- function(df, data){
  x <- df %>% dplyr::pull(!!data$X2[1])
  labs <- data$X3[-1]
  vals <- data$X2[-1] %>% as.numeric()

  # it doesn't work when reassigned to x !! - why that ?? - whatever...
  y <- haven::labelled(
    x,
    labels = purrr::set_names(vals, labs),
    label = data$X3[1]
  )
  df %>%
    dplyr::mutate(!!data$X2[1] := y)
}


add_labs <- function(df, data){
  x <- df %>% dplyr::pull(!!data$X2[1])
  labs <- c(attr(x, "labels") %>% names(), data$X3[-1])
  vals <- c(attr(x, "labels") %>% unname(), data$X2[-1] %>% as.numeric())
  y <- haven::labelled(
    x,
    labels = purrr::set_names(vals, labs),
    label = dplyr::coalesce(data$X3[1], attr(x, "label"))
  )
  df %>%
    dplyr::mutate(!!data$X2[1] := y)
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
#' Create a set of variables for each value of var1. The resulting variables
#' are equal to var2 if var1 is equal to the respective value and NA otherwise.
#'
#' @param df data frame
#' @param var1 variable to split by
#' @param var2 variable to be splitted
#'
#' @return
#' @export
#'
#' @examples
#' kg(data.frame(a = 1:3, b = c(3, 3, 4)), "b", "a")
kg <- function(df, var1, var2) {
  new_vars <- prepare_newvar_table(df, var1, var2)
  new_vars %>%
    purrr::transpose() %>%
    # these 2 lines would do the same
    # rowwise() %>%
    # group_split() %>%
    # add the new variables one by one to the dataframe:
    purrr::reduce(split_cat_by_cat, var1, var2, .init = df)
}
prepare_newvar_table <- function(df, var1, var2) {
  var2lab <- attr(df[[var2]], "label")
  new_varlabs <-
    df %>%
    dplyr::mutate(id = dplyr::row_number(), !!var1) %>%
    tablab::tab_all() %>%
    dplyr::filter(var == var1) %>%
    tidyr::drop_na(nv) %>%
    tidyr::unite(new_varlab, varlab, vallab, sep = " - ") %>%
    dplyr::mutate(new_varlab = paste0(new_varlab, ": ", var2lab)) %>%
    dplyr::select(nv, new_varlab)

  new_varnames <- paste0(
    var2,
    "x",
    var1,
    "_",
    new_varlabs$nv
  ) %>% stringr::str_replace("-", "minus")
  new_vars <- new_varlabs %>% dplyr::mutate(new_varnames)
  new_vars
}
split_cat_by_cat <- function(df, new_vars, var1, var2) {
  new_vec <- df %>% dplyr::transmute(x = ifelse(!!rlang::sym(var1) == new_vars$nv, !!rlang::sym(var2), NA)
  ) %>% dplyr::pull()
  vallabs <- df %>%
    dplyr::pull(!!rlang::sym(var2)) %>%
    attr(., "labels")
  new_vec <- haven::labelled(new_vec, labels = vallabs, label = new_vars$new_varlab)
  df %>% dplyr::mutate(
    !!rlang::sym(new_vars$new_varnames) := new_vec)

}

rec_1var <- function(df, l_sum_var_el) {
  var_name      <- l_sum_var_el %>% dplyr::pull(var) %>% .[1]
  sum_var_name  <- paste0("k", var_name)
  sum_var_label <- l_sum_var_el %>% dplyr::pull(sum_var_label) %>% .[1]

  sum_var_vals_n_labs <- l_sum_var_el %>%
    dplyr::mutate_at(c("sum_var_value"), as.numeric) %>%
    dplyr::group_by(sum_var_value) %>%
    dplyr::summarise(val_lists = list(nv),
              val_labs = dplyr::first(sum_var_vallab))

  cond_statements <- purrr::map2(
    sum_var_vals_n_labs$val_lists,
    sum_var_vals_n_labs$sum_var_value,
    ~ rlang::quo(!!rlang::sym(var_name) %in% !!.x ~ !!.y)
  )



  df <- df %>%
    dplyr::mutate(
      sum_var := dplyr::case_when(!!!cond_statements)
    )
  df$sum_var <- haven::labelled(
    df$sum_var,
    labels = sum_var_vals_n_labs[-2] %>% dplyr::select(2, 1) %>%  tibble::deframe(),
    label = sum_var_label
  )
  df %>% dplyr::rename(!!rlang::sym(sum_var_name) := sum_var)
}


rec_1var_free <- function(df, l_sum_var_el) {
  var_name      <- l_sum_var_el %>% dplyr::pull(X2) %>% .[1]
  sum_var_name  <- l_sum_var_el %>% dplyr::pull(X3) %>% .[1]
  sum_var_label <- l_sum_var_el %>% dplyr::pull(X4) %>% .[1]

  sum_var_vals_n_labs <- l_sum_var_el %>% dplyr::slice(-1) %>%
    dplyr::mutate_at(c("X2", "X3", "X4"), as.numeric)

  rec_vecs <-
    l_sum_var_el %>%
    dplyr::slice(-1) %>%
    dplyr::mutate_all(as.numeric) %>%
    dplyr::select(X2, X3, X4) %>%
    as.list() %>%
    unname()

  cond_statements <-
    purrr::pmap(
      rec_vecs,
      function(x,y,z) rlang::quo(!!rlang::sym(var_name) >= !!x & !!rlang::sym(var_name) <= dplyr::coalesce(!!y, !!x)  ~ !!z)
    )



  df <- df %>%
    dplyr::mutate(sum_var := dplyr::case_when(!!!cond_statements))

  df$sum_var <- haven::labelled(
    df$sum_var,
    labels = sum_var_vals_n_labs %>% dplyr::select(X5, X4) %>% tibble::deframe(),
    label = sum_var_label
  )
  df %>% dplyr::rename(!!rlang::sym(sum_var_name) := sum_var)
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
#' @param var_str string of the variable name
#' @param expr_str expression string
#'
#' @return
#' @export
#'
#' @examples
#' mutate_comp(data.frame(x = 1:3), "y", "x * 2")
mutate_comp <- function(df, var_str, expr_str) {
  expi <- rlang::parse_expr(expr_str)

  df %>% dplyr::mutate(!!var_str := !!expi)
}


#' Conditional computing of a variable in a dataframe
#'
#' @param df dataframe
#' @param cond_str condition to be fulfilled
#' @param assign_str string of the variable assignment
#'
#' @return
#' @export
#'
#' @examples
#' mutate_cond(data.frame(x = 1:3), "x == 3", "y = 2")
mutate_cond <- function(df, cond_str, assign_str) {
  condi <- rlang::parse_expr(cond_str)
  assi <- assign_str %>% stringr::str_split("=") %>% unlist() %>%  rlang::parse_exprs()

  df %>% dplyr::mutate(!!assi[[1]] := ifelse(!!condi, !!assi[[2]], NA_real_))
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
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
#' mapp_cmd_table("mapping.xlsx")
mapp_cmd_table <- function(filename) {
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

  purrr::map2_dfr(
    sheets %>%
      purrr::set_names(),
    sheet_cats,
    ~ make_sheet_cmd_table(filename, .y, .x),
    .id = "sheet"
  )

}
make_sheet_cmd_table <- function(filename, sheet_cat, sheet_name) {
  switch (sheet_cat,
          "Variables" = mapp_varl(filename, sheet = sheet_name) %>% make_varlab_cmd_table(),
          "Labels" = mapp_vall(filename, sheet = sheet_name) %>% make_sumvar_cmd_table(),
          "Free" = mapp_free1(filename, sheet = sheet_name) %>% make_free_cmd_table(),
          "Verbatims" = make_verbatim_cmd_table(filename, sheet = sheet_name)
  )

}



apply_one_cmd <- function(df, action, data) {
  switch (
    action,
    "#IF"     = mutate_cond(df, data$X2, data$X3),
    "#COMP"   = mutate_comp(df, data$X2, data$X3),
    "#REC"    = rec_1var_free(df, data),
    "#SUMVAR" = rec_1var(df, data),
    "#NEWLAB" = set_lab(df, data$var, data$new_label),
    "#VARL"   = set_lab(df, data$X2, data$X3),
    "#VALL"   = set_labs(df, data),
    "#AVALL"  = add_labs(df, data),
    "#KG"     = kg(df, data$X2, data$X3),
    "#Verba"  = assign_verba_val(df, data),
    stop("Invalid action command")
  )
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
#' that error out will be skipped
#' @param rec_fun function either purrr::reduce2 or purrr::accumulate2; see Value section
#'
#' @return in case rec_fun = purrr::reduce2 only the final dataframe is returned
#' in case of purrr::accumulate2 a list with all intermediate dataframes (of
#' every command block) is returned
#' @export
#'
#' @examples
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapp_xl_to_data(fake_survey, mapping_filepath)
mapp_xl_to_data <- function(df, filename, na_to_filter = TRUE, input_if_error = FALSE, rec_fun = purrr::reduce2) {
  cmd_table <- mapp_cmd_table(filename)

  if (na_to_filter == TRUE) {
    df <- df %>% dplyr::mutate_if(is.numeric, set_na_to_filter)
  }

  if (input_if_error) {
    apply_one_cmd <- apply_one_cmd_safe
  }


  rec_fun(cmd_table$action, cmd_table$data, apply_one_cmd, .init = df)
}

set_na_to_filter <- function(var, replace_val = -2) {
  labs = c(attr(var, "labels") %>% names(), "FILTER")
  vals = c(attr(var, "labels") %>% unname() %>% as.numeric(), replace_val)
  var[is.na(var)] <- replace_val
  haven::labelled(
    var,
    labels = setNames(vals, labs),
    label = attr(var, "label")
  )
}
