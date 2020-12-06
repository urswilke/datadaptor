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
#' @param data
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
  )
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
  # attr(df$sum_var, "label") <- sum_var_label
  # attr(df$sum_var, "labels") <- sum_var_vals_n_labs[-2] %>% tibble::deframe()
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
    stringr::str_split(" ", simplify = T) %>%
    tibble::as_tibble()

  replace_1curly <- function(orig_str, replacement) stringr::str_replace(orig_str,  "\\{.+?\\}", replacement)
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
    df_f1 %>%
    # dplyr::filter(stringr::str_detect(X1, "(^#IF|^#COMP)")) %>%
    dplyr::filter_all(dplyr::any_vars(!is.na(.))) %>%
    dplyr::mutate_at(2:3, ~purrr::map(.x,~extract_sev_lists(.))) %>%
    tidyr::unnest(cols = c("X2", "X3"))
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
    dplyr::relocate(sheet, action)  %>%
    dplyr::group_by(sheet, action, row, new_var) %>%
    tidyr::nest()
}

create_df_new_varlab <- function(df_varl) {
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
    # severalize() %>%
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
      tidyr::nest()
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
  df_varl  <- mapp_varl(filename)
  df_vall  <- mapp_vall(filename)
  df_verba <- mapp_prepare_verba_data(filename)
  df_free1 <- mapp_free1(filename)


  df_f1_commands <- make_free_cmd_table(df_free1)# %>% severalize())
  create_df_new_varlab(df_varl) %>%
    dplyr::bind_rows(create_df_sumvar(df_vall)) %>%
    dplyr::bind_rows(df_f1_commands)  %>%
    dplyr::bind_rows(df_verba)  %>%
    # dplyr::group_by(sheet, action, row, new_var) %>%
    # tidyr::nest() %>%
    dplyr::ungroup()
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
    "#Verba"  = assign_verba_val(df, data)
  )
}

#' Apply changes of mapping Excel file to dataframe
#'
#' @param df dataframe to apply mapping on
#' @param filename name of the Excel file with mappings
#'
#' @return
#' @export
#'
#' @examples
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' mapp_xl_to_data(fake_survey, mapping_filepath)
mapp_xl_to_data <- function(df, filename) {
  cmd_table <- mapp_cmd_table(filename)

  purrr::reduce2(cmd_table$action, cmd_table$data, apply_one_cmd, .init = df)
}
