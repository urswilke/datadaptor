library(tidyverse)
library(datenanpassr)
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
df <- haven::read_sav(spss_file)

mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
df_cmd <- datenanpassr::mapp_cmd_table(mapping_file, vars_as_syms = TRUE)

args_contain_renamed <- df_cmd %>%
  select(data) %>%
  unnest_wider(data) %>%
  select(where(is.character)) %>%
  mutate(a = rowSums(map_dfc(., ~str_detect(.x, "renamed")), na.rm = T)) %>%
  pull(a)

df_cmd_subset <- df_cmd %>%
  filter(args_contain_renamed == 0) %>%
  filter(!action %in% c("#RECNA", "#RENAME", "#RFUN")) %>%
  filter(!str_detect(new_var, "renamed"))

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
cmds <- get_mutate_exprs(df_cmd_subset$action, df_cmd_subset$data, df_cmd_subset$new_var)
df_mod <- df %>% mutate(!!!cmds)
df %>% mutate(!!cmds[[55]])

df_cmd_old <- datenanpassr::mapp_cmd_table(mapping_file)
df_cmd_subset_old <- df_cmd_old %>%
  filter(args_contain_renamed == 0) %>%
  filter(!action %in% c("#RECNA", "#RENAME", "#RFUN")) %>%
  filter(!str_detect(new_var, "renamed"))
df_mod_old <- mapp_xl_to_data(df, df_cmd_subset_old)
all.equal(df_mod, df_mod_old)



# separate mutate / reduce blocks -----------------------------------------

split_df_cmd <- function(df_cmd) {
  df_cmd %>%
    dplyr::mutate(
      i_block = action %in% c("#RECNA", "#RENAME", "#RFUN"),
      i_block = i_block != lag(i_block, default = TRUE),
      i_block = cumsum(i_block)
    ) %>%
    group_split(i_block, .keep = FALSE) %>%
    map_dfr(prepare_blocks)
}
prepare_blocks <- function(df_cmd_block) {
  single_blocks <- c("#RECNA", "#RENAME", "#RFUN")
  if (!df_cmd_block$action[1] %in% single_blocks) {
    df_cmd_block <- tibble::tibble(
      action = "#BLOCK",
      data = list(df_cmd_block$cmd)
    )
  }
  df_cmd_block
}

df_cmd <- df_cmd %>% mutate(cmd = get_mutate_exprs(action, data, new_var))
l_cmd <- split_df_cmd(df_cmd)


apply_block_manips <- function(df, action, data) {
  block_expr <- switch (
    action,
    "#RECNA"  = rlang::expr(set_na_to_filter_except(df, !!!data)),
    "#RFUN"   = rlang::expr(cmd_rfun(df, !!!data)),
    "#RENAME" = rlang::expr(cmd_rename(df, !!!data)),
    "#BLOCK"  = rlang::expr(df %>% mutate(!!!data))
  )
  rlang::eval_tidy(block_expr)
}
df_mod <- reduce2(l_cmd$action, l_cmd$data, apply_block_manips, .init = df)
df_mod_old <- mapp_xl_to_data(df, df_cmd_old)
all.equal(df_mod, df_mod_old)
