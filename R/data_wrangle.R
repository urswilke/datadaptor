#' Create an Excel mapping file based on a labelled dataframe
#'
#' @param df_raw dataframe with labelled variables, e.g. resulting from haven::read_sav
#' @param filename name of the Excel file to be created
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
mapp_create <- function(df_raw, filename) {

  df_varlab <-
    tablab::tab_varlabs(df_raw) %>%
    dplyr::mutate(new_label = "")
  df_vallabs <-
    tablab::tab_vallabs(df_raw) %>%
    dplyr::mutate(`new_label` = "",
           `sum_var_label` = "",
           `sum_var_value` = "",
           `sum_var_vallab` = "")

  wb <- openxlsx::createWorkbook()

  openxlsx::addWorksheet(wb, "Variables")
  openxlsx::addWorksheet(wb, "Labels")
  openxlsx::addWorksheet(wb, "Verbatims")
  openxlsx::addWorksheet(wb, "Free1")

  # Write the data to the sheets
  openxlsx::writeData(wb, sheet = "Variables", x = df_varlab)
  openxlsx::writeData(wb, sheet = "Labels", x = df_vallabs)
  openxlsx::writeData(wb, sheet = "Verbatims", x = "")
  openxlsx::writeData(wb, sheet = "Free1", x = "")

  # Export the file
  openxlsx::saveWorkbook(wb, filename)
}

#' Extract variable label sheet of Excel mapping file to dataframe
#'
#' @param filename name of the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
#' mapp_varl("mapping.xlsx")
mapp_varl <- function(filename) {
  readxl::read_xlsx(
    filename,
    sheet = "Variables"
  ) %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
}


#' Extract value label sheet of Excel mapping file to dataframe
#'
#' @param filename name of the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
#' mapp_vall("mapping.xlsx")
mapp_vall <- function(filename) {
  readxl::read_xlsx(
    filename,
    sheet = "Labels"
  ) %>%
    dplyr::mutate(row = dplyr::row_number() + 1)
}


#' Extract free1 sheet of Excel mapping file to dataframe
#'
#' @param filename name of the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
#' mapp_free1("mapping.xlsx")
mapp_free1 <- function(filename) {
  res <- readxl::read_xlsx(
    filename,
    sheet = "Free1",
    range = cellranger::cell_cols("A:E"),
    col_names = FALSE,
    col_types = "text"
  )
  if (nrow(res) > 0) {
    res %>%
      dplyr::select(1:5) %>%
      dplyr::rename_all( ~ paste0("X", 1:5)) %>%
      dplyr::filter_all(dplyr::any_vars(!is.na(.))) %>%
      dplyr::mutate(row = dplyr::row_number())
  }
  else {
    purrr::map_dfc(1:5, ~character()) %>% purrr::set_names(paste0("X", 1:5))
  }
}


read_sav_or_dta <- function(filename) {
  ending <- str_remove(filename, ".*\\.") %>% str_to_lower()
  if (!ending %in% c("sav", "dta")) {
    warning("input file needs to be of type sav or dta")
  }
  else{
    switch (ending,
            "sav" = haven::read_sav(filename),
            "dta" = haven::read_dta(filename)
    )
  }
}


#' Modify variable labels according to sheet in Excel mapping file
#'
#' @param df_raw labelled dataframe
#' @param filename name of the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' mapp_mod_varl(fake_survey, "mapping.xlsx")
mapp_mod_varl <- function(df_raw, filename) {
  df_varl <- mapp_varl(filename)
  df_raw[df_varl %>% tidyr::drop_na(new_label) %>% dplyr::pull(var)] <-
    df_raw[df_varl %>% tidyr::drop_na(new_label) %>% dplyr::pull(var)] %>%
    map2_dfc(.,
             df_varl %>% tidyr::drop_na(new_label) %>% dplyr::pull(new_label),
             ~ {
               attr(.x, "label") <- .y
               .x
             }
    )
  df_raw
}

set_lab <- function(df_raw, var, new_label){
  x <- df_raw %>% pull(!!var)
  attr(x, "label") <- new_label
  df_raw %>%
    mutate(!!var := x)
}

set_labs <- function(df_raw, data){
  x <- df_raw %>% pull(!!data$X2[1])
  labs <- data$X3[-1]
  vals <- data$X2[-1] %>% as.numeric()
  attr(x, "label") <- data$X3[1]
  attr(x, "labels") <- setNames(vals, labs)
  df_raw %>%
    mutate(!!data$X2[1] := x)
}


add_labs <- function(df_raw, data){
  x <- df_raw %>% pull(!!data$X2[1])
  labs <- c(attr(x, "labels") %>% names(), data$X3[-1])
  vals <- c(attr(x, "labels") %>% unname(), data$X2[-1] %>% as.numeric())
  attr(x, "label") <- dplyr::coalesce(data$X3[1], attr(x, "label"))
  attr(x, "labels") <- setNames(vals, labs)
  df_raw %>%
    mutate(!!data$X2[1] := x)
}


kg <- function(df_raw, var1, var2) {
  var_kg <- paste(var1, var2, sep = "_")
  df_raw %>%
    mutate(!!var_kg := fct_cross(!!rlang::sym(var1) %>% as_factor(), !!rlang::sym(var2) %>% as_factor()))

}

rec_1var <- function(df_raw, l_sum_var_el) {
  var_name <- l_sum_var_el %>% dplyr::pull(var) %>% .[1]
  sum_var_name <- var_name %>% paste0("k", .)
  sum_var_label <- l_sum_var_el %>% dplyr::pull(sum_var_label) %>% .[1]

  sum_var_vals_n_labs <- l_sum_var_el %>%
    dplyr::mutate_at(c("sum_var_value"), as.numeric) %>%
    dplyr::group_by(sum_var_value) %>%
    dplyr::summarise(val_lists = list(nv),
              val_labs = dplyr::first(sum_var_vallab))

  cond_statements <- purrr::map2(sum_var_vals_n_labs$val_lists,
                          sum_var_vals_n_labs$sum_var_value,
                          ~ rlang::quo(!!rlang::sym(var_name) %in% !!.x ~ !!.y)
  )



  df_raw <- df_raw %>% dplyr::mutate(sum_var := dplyr::case_when(!!!cond_statements))
  df_raw$sum_var <- haven::labelled(
    df_raw$sum_var,
    labels = sum_var_vals_n_labs[-2] %>% select(2, 1) %>%  tibble::deframe(),
    label = sum_var_label
  )
  # attr(df_raw$sum_var, "label") <- sum_var_label
  # attr(df_raw$sum_var, "labels") <- sum_var_vals_n_labs[-2] %>% tibble::deframe()
  df_raw %>% dplyr::rename(!!rlang::sym(sum_var_name) := sum_var)
}


rec_1var_free <- function(df_raw, l_sum_var_el) {
  var_name <- l_sum_var_el %>% dplyr::pull(X2) %>% .[1]
  sum_var_name <- l_sum_var_el %>% dplyr::pull(X3) %>% .[1]
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
    purrr::pmap(rec_vecs,
         function(x,y,z) rlang::quo(!!rlang::sym(var_name) >= !!x & !!rlang::sym(var_name) <= dplyr::coalesce(!!y, !!x)  ~ !!z)
    )



  df_raw <- df_raw %>% dplyr::mutate(sum_var := dplyr::case_when(!!!cond_statements))
  df_raw$sum_var <- haven::labelled(
    df_raw$sum_var,
    labels = sum_var_vals_n_labs %>% select(X5, X4) %>% tibble::deframe(),
    label = sum_var_label
  )
  # attr(df_raw$sum_var, "label") <- sum_var_label
  # attr(df_raw$sum_var, "labels") <- sum_var_vals_n_labs[-2] %>% tibble::deframe()
  df_raw %>% dplyr::rename(!!rlang::sym(sum_var_name) := sum_var)
}


extract_sev_lists <- function(var) {
  l_sev_parts <-
    var %>%
    stringr::str_squish() %>%
    stringr::str_extract_all("(\\{.+?\\})", simplify = T) %>%
    # as_tibble() %>%
    purrr::map(~stringr::str_remove_all(.x, "[\\{\\}]")) %>%
    stringr::str_split(" ", simplify = T) %>%
    tibble::as_tibble()

  replace_1curly <- function(orig_str, replacement) str_replace(orig_str,  "\\{.+?\\}", replacement)
  replace_all_curlies <- function(orig_str, l_1sev_parts) purrr::reduce(l_1sev_parts, replace_1curly, .init = orig_str)
  if (!all(dim(l_sev_parts) == c(0,0))) {
    l_sev_parts %>% purrr::map_chr(~replace_all_curlies(var, .x)) %>% unname()
  }
  else {
    var
  }
}

severalize <- function(df_f1) {
  df_if_or_comp <-
    df_f1[stringr::str_detect(df_f1$X1, "(^#IF|^#COMP)"),] %>% dplyr::filter_all(dplyr::any_vars(!is.na(.)))  %>%
    dplyr::mutate_at(2:3, ~purrr::map(.x,~extract_sev_lists(.))) %>% tidyr::unnest(cols = c("X2", "X3"))
  df_if_or_comp
  # df_f1_mod <-
  #   df_f1
  # df_f1_mod[which(str_detect(df_f1_mod$X1, "(^#IF|^#COMP)")),] <- df_if_or_comp
  # df_f1_mod %>%
  #   mutate(length_2 =  X2 %>% map_int(length)) %>%
  #   mutate(length_3 =  X3 %>% map_int(length)) %>%
  #   mutate(rep_factor =  length_2 / length_3) %>%
  #   mutate(X3 = map2(X3, rep_factor, ~rep(.x, .y))) %>%
  #   unnest() %>%
  #   select(names(df_f1))
}



mutate_comp <- function(df_raw, var_str, expr_str) {
  expi <- rlang::parse_expr(expr_str)

  df_raw %>% dplyr::mutate(!!var_str := !!expi)
}


mutate_cond <- function(df_raw, cond_str, assign_str) {
  condi <- rlang::parse_expr(cond_str)
  assi <- assign_str %>% stringr::str_split("=") %>% unlist() %>%  rlang::parse_exprs()

  df_raw %>% dplyr::mutate(!!assi[[1]] := ifelse(!!condi, !!assi[[2]], NA_real_))
}



create_df_sumvar <- function(df_vall) {
  df_vall %>%
    tidyr::drop_na(sum_var_value) %>%
    dplyr::select(-new_label) %>%
    dplyr::mutate(new_var = paste0("k", var)) %>%
    dplyr::mutate(orig_var = var) %>%
    dplyr::group_by(new_var, orig_var) %>%
    dplyr::mutate(row = paste(row, collapse = ", ")) %>%
    dplyr::mutate(sheet = "Labels") %>%
    dplyr::mutate(action = "#SUMVAR") %>%
    dplyr::relocate(sheet, action)
}

create_df_new_lab <- function(df_varl) {
  df_varl %>%
    dplyr::mutate(row = (dplyr::row_number() + 1) %>% as.character()) %>%
    tidyr::drop_na(new_label) %>%
    dplyr::mutate(new_var = var) %>%
    dplyr::mutate(sheet = "Variables") %>%
    dplyr::mutate(action = "#NEWLAB")
}


make_free_table <- function(df_f1) {
  res <- df_f1 %>%
    dplyr::mutate(index = cumsum(dplyr::coalesce(stringr::str_detect(X1, "^#"), FALSE))) %>%
    dplyr::group_by(index) %>%
    dplyr::mutate(row = paste(row, collapse = ", ")) %>%
    dplyr::mutate(action = X1[1]) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(sheet = "Free1") %>%
    dplyr::select(-index) %>%
    # severalize() %>%
    dplyr::group_by(action, row)
  if (nrow(res) > 0) {
    res %>%
      dplyr::mutate(
        new_var = dplyr::case_when(
          action == "#REC" ~ X3[1],
          action == "#IF" ~ stringr::str_remove(X3, "=.*") %>% stringr::str_squish(),
          action == "#COMP" ~ X2,
          action == "#VARL" ~ X2,
          action == "#KG" ~ paste(X2, X3, sep = "_"),
          action %in% c("#VALL", "#AVALL") ~ X2[1]
        )
      )
  }
  else {
    tibble::tibble()
  }
}

#' Create a summary table of the data modifications in the
#' Excel mapping file
#'
#' @param filename filename of the Excel mapping file
#'
#' @return
#' @export
#'
#' @examples
#' mapp_create(fake_survey, "mapping.xlsx")
#' mapp_mod_table("mapping.xlsx")
mapp_mod_table <- function(filename) {
  df_varl <- mapp_varl(filename)
  df_vall <- mapp_vall(filename)
  df_free1 <- mapp_free1(filename)


  df_f1_commands <- make_free_table(df_free1)# %>% severalize())
  create_df_new_lab(df_varl) %>%
    dplyr::bind_rows(create_df_sumvar(df_vall)) %>%
    dplyr::bind_rows(df_f1_commands)  %>%
    dplyr::group_by(sheet, action, row, new_var) %>%
    tidyr::nest() %>%
    ungroup()
}



all_mutes <- function(df_raw, action, data) {
  switch (action,
          "#IF" = mutate_cond(df_raw, data$X2, data$X3),
          "#COMP" = mutate_comp(df_raw, data$X2, data$X3),
          "#REC" = rec_1var_free(df_raw, data),
          "#SUMVAR" = rec_1var(df_raw, data),
          "#NEWLAB" = set_lab(df_raw, data$var, data$new_label),
          "#VARL" = set_lab(df_raw, data$X2, data$X3),
          "#VALL" = set_labs(df_raw, data),
          "#AVALL" = add_labs(df_raw, data),
          "#KG" = kg(df_raw, data$X2, data$X3)
  )
}

#' Apply changes of mapping Excel file to dataframe
#'
#' @param df_raw dataframe to apply mapping on
#' @param filename name of the Excel file with mappings
#'
#' @return
#' @export
#'
#' @examples
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapp_xl_to_data(fake_survey, mapping_filepath)
mapp_xl_to_data <- function(df_raw, filename) {
  mod_table <- mapp_mod_table(filename)

  purrr::reduce2(mod_table$action, mod_table$data, all_mutes, .init = df_raw)
}
