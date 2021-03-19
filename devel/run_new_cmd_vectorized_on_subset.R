library(tidyverse)
library(datenanpassr)
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
df <- haven::read_sav(spss_file)

mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
df_cmd <- datenanpassr::mapp_cmd_table(mapping_file, vectorized = TRUE)
df_cmd_old <- datenanpassr::mapp_cmd_table(mapping_file)


generate_cmd_expression_vec <- function(action, data) {
  switch (
    action,
    "#RECNA"  = rlang::expr(set_na_to_filter_except(!!!data)),
    "#MERGE"  = rlang::expr(cmd_merge(!!!data)),
    "#RFUN"   = rlang::expr(cmd_rfun(!!!data)),
    "#R"      = rlang::expr(cmd_r(!!!data)),
    "#IF"     = rlang::expr(cmd_if(!!!data)),
    "#COMP"   = rlang::expr(cmd_comp(!!!data)),
    # TODO: find cleaner way to deal with this!
    "#COMPR"  = rlang::expr(cmd_compr(!!!data)),
    "#REC"    = rlang::expr(cmd_rec(!!!data)),
    "#NEWVALL"= rlang::expr(cmd_add_labs(!!!data)),
    "#AUTOREC"= rlang::expr(cmd_autorec(!!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar(!!!data)),
    "#RENAME" = rlang::expr(cmd_rename(!!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab(!!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab(!!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs(!!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs(!!!data)),
    "#DIC"    = rlang::expr(cmd_dic(!!!data)),
    "#KG"     = rlang::expr(cmd_kg(!!!data)),
    "#verbatim"  = rlang::expr(cmd_verbatim(!!!data)),
    stop("Invalid action command")
  )
}

get_mutate_exprs <- function(action, data, new_var) {
  cmds <- map2(
    action,
    data,
    generate_cmd_expression_vec
  ) %>%
    set_names(~new_var)
  names(cmds)[action %in% c("#MERGE", "#KG", "#R")] <- ""
  cmds
}


# separate mutate / reduce groups -----------------------------------------

split_df_cmd <- function(df_cmd) {
  single_groups <- c("#RECNA", "#RENAME", "#RFUN")
  prepare_groups <- function(df_cmd_group) {
    if (!df_cmd_group$action[1] %in% single_groups) {
      df_cmd_group <- tibble::tibble(
        action = "#GROUP",
        data = list(df_cmd_group$cmd)
      )
    }
    df_cmd_group %>%
      select(action, data)
  }

  df_cmd %>%
    dplyr::mutate(
      i_group = action %in% single_groups,
      i_group = i_group != lag(i_group, default = TRUE),
      i_group = cumsum(i_group)
    ) %>%
    group_split(i_group, .keep = FALSE) %>%
    map_dfr(prepare_groups)
}



generate_group_expr <- function(action, data) {
  # Hack to prevent R CMD CHECK note
  # "no visible binding for global variable ‘df’":
  df <- NULL

  group_expr <- switch (
    action,
    "#RECNA"  = rlang::expr(set_na_to_filter_except(df, !!!data)),
    "#RFUN"   = rlang::expr(cmd_rfun(df, !!!data)),
    "#RENAME" = rlang::expr(cmd_rename(df, !!!data)),
    "#GROUP"  = rlang::expr(df %>% mutate(!!!data))
  )
  group_expr
}

apply_one_group_cmd <- function(df, action, data){
  group_expr <- generate_group_expr(action, data)
  rlang::eval_tidy(group_expr)
}

group_vectorizable_cmds <- function(df_cmd) {
  df_cmd <- df_cmd %>% mutate(cmd = get_mutate_exprs(action, data, new_var))
  df_cmd_groups <- split_df_cmd(df_cmd)
  df_cmd_groups
}
df_cmd_groups <- group_vectorizable_cmds(df_cmd)
df_mod <- reduce2(df_cmd_groups$action, df_cmd_groups$data, apply_one_group_cmd, .init = df)
df_mod_old <- mapp_xl_to_data(df, df_cmd_old)
all.equal(df_mod, df_mod_old)
