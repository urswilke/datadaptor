savefile <- function(filename, df_raw) {
  library(openxlsx)

  df_varlab <-
    tab_varlabs(df_raw) %>%
    mutate(new_label = "")
  df_vallabs <-
    tab_vallabs(df_raw) %>%
    mutate(`new_label` = "",
           `sum_var_label` = "",
           `sum_var_value` = "",
           `sum_var_vallab` = "")

  wb <- createWorkbook()

  addWorksheet(wb, "Variables")
  addWorksheet(wb, "Labels")
  addWorksheet(wb, "Verbatims")
  addWorksheet(wb, "Free1")

  # Write the data to the sheets
  writeData(wb, sheet = "Variables", x = df_varlab)
  writeData(wb, sheet = "Labels", x = df_vallabs)
  writeData(wb, sheet = "Verbatims", x = "")
  writeData(wb, sheet = "Free1", x = "")

  # Export the file
  saveWorkbook(wb, filename)
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


tab_n_distinct <- function(df_raw) {
  df_raw %>%
    # remove attributes to prevent warning when gathering:
    mutate_all(as.vector) %>%
    gather(var, val, factor_key = TRUE) %>%
    group_by(var) %>%
    summarise(n = n_distinct(val))
}


create_cnt_compare <- function(l, id){

  # cmp_cts_n_labs(l, id)
  cmp_all(l, id)

}

mod_varlabs <- function(df_raw, df_varl) {
  df_raw[df_varl %>% drop_na(new_label) %>% pull(var)] <-
    df_raw[df_varl %>% drop_na(new_label) %>% pull(var)] %>%
    map2_dfc(.,
             df_varl %>% drop_na(new_label) %>% pull(new_label),
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
  attr(x, "label") <- coalesce(data$X3[1], attr(x, "label"))
  attr(x, "labels") <- setNames(vals, labs)
  df_raw %>%
    mutate(!!data$X2[1] := x)
}


kg <- function(df_raw, var1, var2) {
  var_kg <- paste(var1, var2, sep = "_")
  df_raw %>%
    mutate(!!var_kg := fct_cross(!!sym(var1) %>% as_factor(), !!sym(var2) %>% as_factor()))

}

rec_1var <- function(l_sum_var_el, df_raw) {
  var_name <- l_sum_var_el %>% pull(var) %>% .[1]
  sum_var_name <- var_name %>% paste0("k", .)
  sum_var_label <- l_sum_var_el %>% pull(`sum var label`) %>% .[1]

  sum_var_vals_n_labs <- l_sum_var_el %>%
    group_by(`sum var value`) %>%
    summarise(val_lists = list(value),
              val_labs = first(`sum var vallab`))

  cond_statements <- map2(sum_var_vals_n_labs$val_lists,
                          sum_var_vals_n_labs$`sum var value`,
                          ~ quo(!!sym(var_name) %in% !!.x ~ !!.y)
  )



  df_raw <- df_raw %>% mutate(sum_var := case_when(!!!cond_statements))
  attr(df_raw$sum_var, "label") <- sum_var_label
  attr(df_raw$sum_var, "labels") <- sum_var_vals_n_labs[-2] %>% deframe()
  df_raw %>% rename(!!sym(sum_var_name) := sum_var)
}


rec_1var_free <- function(l_sum_var_el, df_raw) {
  var_name <- l_sum_var_el %>% pull(X2) %>% .[1]
  sum_var_name <- l_sum_var_el %>% pull(X3) %>% .[1]
  sum_var_label <- l_sum_var_el %>% pull(X5) %>% .[1]

  sum_var_vals_n_labs <- l_sum_var_el %>% slice(-1)

  rec_vecs <-
    l_sum_var_el %>%
    slice(-1) %>%
    mutate_all(as.numeric) %>%
    select(X2, X3, X4) %>%
    as.list() %>%
    unname()

  cond_statements <-
    pmap(rec_vecs,
         function(x,y,z) quo(!!sym(var_name) >= !!x & !!sym(var_name) <= coalesce(!!y, !!x)  ~ !!z)
    )




  df_raw <- df_raw %>% mutate(sum_var := case_when(!!!cond_statements))
  attr(df_raw$sum_var, "label") <- sum_var_label
  attr(df_raw$sum_var, "labels") <- sum_var_vals_n_labs[-2] %>% deframe()
  df_raw %>% rename(!!sym(sum_var_name) := sum_var)
}


extract_sev_lists <- function(var) {
  l_sev_parts <-
    var %>%
    str_squish() %>%
    str_extract_all("(\\{.+?\\})", simplify = T) %>%
    # as_tibble() %>%
    map(~str_remove_all(.x, "[\\{\\}]")) %>%
    str_split(" ", simplify = T) %>%
    as_tibble()

  replace_1curly <- function(orig_str, replacement) str_replace(orig_str,  "\\{.+?\\}", replacement)
  replace_all_curlies <- function(orig_str, l_1sev_parts) reduce(l_1sev_parts, replace_1curly, .init = orig_str)
  if (!all(dim(l_sev_parts) == c(0,0))) {
    l_sev_parts %>% map_chr(~replace_all_curlies(var, .x)) %>% unname()
  }
  else {
    var
  }
}

severalize <- function(df_f1) {
  df_if_or_comp <-
    df_f1[str_detect(df_f1$X1, "(^#IF|^#COMP)"),] %>% filter_all(any_vars(!is.na(.)))  %>%
    mutate_at(2:3, ~map(.x,~extract_sev_lists(.))) %>% unnest(cols = c("X2", "X3"))
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

  df_raw %>% mutate(!!var_str := !!expi)
}


mutate_cond <- function(df_raw, cond_str, assign_str) {
  condi <- rlang::parse_expr(cond_str)
  assi <- assign_str %>% str_split("=") %>% unlist() %>%  rlang::parse_exprs()

  df_raw %>% mutate(!!assi[[1]] := ifelse(!!condi, !!assi[[2]], NA_real_))
}




diff_daff <- function(df_raw, df_mod) {
  patch <- daff::diff_data(df_raw, df_mod)
  HTML(daff::render_diff(patch))

}


create_df_sumvar <- function(df_vall) {
  df_vall %>%
    drop_na(`sum var value`) %>%
    select(-`New label`) %>%
    mutate(new_var = paste0("k", var)) %>%
    mutate(orig_var = var) %>%
    group_by(new_var, orig_var) %>%
    mutate(row = paste(row, collapse = ", ")) %>%
    mutate(sheet = "Labels") %>%
    mutate(action = "#SUMVAR") %>%
    select(sheet, action, everything())
}

create_df_new_lab <- function(df_varl) {
  df_varl %>%
    mutate(row = (row_number() + 1) %>% as.character()) %>%
    drop_na(new_label) %>%
    mutate(new_var = var) %>%
    mutate(sheet = "Variables") %>%
    mutate(action = "#NEWLAB")
}


make_free_table <- function(df_f1) {
  df_f1 %>%
    mutate(index = cumsum(coalesce(str_detect(X1, "^#"), FALSE))) %>%
    group_by(index) %>%
    mutate(row = paste(row, collapse = ", ")) %>%
    mutate(action = X1[1]) %>%
    ungroup() %>%
    mutate(sheet = "Free1") %>%
    select(-index) %>%
    severalize() %>%
    group_by(action, row) %>%
    mutate(new_var = case_when(action == "#REC" ~ X3[1],
                               action == "#IF" ~ str_remove(X3, "=.*") %>% str_squish(),
                               action == "#COMP" ~ X2,
                               action == "#VARL" ~ X2,
                               action == "#KG" ~ paste(X2, X3, sep = "_"),
                               action %in% c("#VALL", "#AVALL") ~ X2[1]))
}

create_mod_table <- function(df_varl, df_vall, df_f1) {
  df_vall <-
    df_vall %>%
    mutate(row = row_number() + 1)

  df_f1_commands <- make_free_table(df_f1 %>% severalize())
  create_df_new_lab(df_varl) %>%
    bind_rows(create_df_sumvar(df_vall)) %>%
    bind_rows(df_f1_commands)  %>%
    group_by(sheet, action, row, new_var) %>%
    nest()
}



all_mutes <- function(df_raw, action, data) {
  switch (action,
          "#IF" = mutate_cond(df_raw, data$X2, data$X3),
          "#COMP" = mutate_comp(df_raw, data$X2, data$X3),
          "#REC" = rec_1var_free(data, df_raw),
          "#SUMVAR" = rec_1var(data, df_raw),
          "#NEWLAB" = set_lab(df_raw, data$var, data$new_label),
          "#VARL" = set_lab(df_raw, data$X2, data$X3),
          "#VALL" = set_labs(df_raw, data),
          "#AVALL" = add_labs(df_raw, data),
          "#KG" = kg(df_raw, data$X2, data$X3)
  )
}

reduce_da <- function(df_raw, df_varl, df_vall, df_f1) {
  mod_table <- create_mod_table(df_varl, df_vall, df_f1)

  reduce2(mod_table$action, mod_table$data, all_mutes, .init = df_raw)
}
