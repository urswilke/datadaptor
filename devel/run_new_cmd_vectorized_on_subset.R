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
  filter(!action %in% c("#RECNA", "#RENAME", "#MERGE", "#R", "#RFUN")) %>%
  filter(!str_detect(new_var, "renamed"))

generate_cmd_expression_vec <- function(action, data) {
  # Hack to prevent R CMD CHECK note
  # "no visible binding for global variable ‘df’":

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

cmds <- map2(
  df_cmd_subset$action,
  df_cmd_subset$data,
  generate_cmd_expression_vec
) %>%
  set_names(~df_cmd_subset$new_var)

dfi <- df
dfi[setdiff(df_cmd_subset$new_var, names(df))] <- NA_real_
df_mod <- dfi %>% mutate(!!!cmds)
# df %>% mutate(!!cmds[[2]])

df_cmd_old <- datenanpassr::mapp_cmd_table(mapping_file)
df_cmd_subset_old <- df_cmd_old %>%
  filter(args_contain_renamed == 0) %>%
  filter(!action %in% c("#RECNA", "#RENAME", "#MERGE", "#R", "#RFUN")) %>%
  filter(!str_detect(new_var, "renamed"))
df_mod_old <- mapp_xl_to_data(df, df_cmd_subset_old)
all.equal(df_mod, df_mod_old)
