spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
df <- haven::read_sav(spss_file)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
df_cmd <- datenanpassr::mapp_cmd_table(mapping_file)
df_in_out <- tibble(
  input_args = datenanpassr:::find_input_args(df_cmd, df),
  new_vars = get_all_new_vars(make_args_df(df_cmd))) %>%
  mutate(i_command = row_number()) %>%
  full_join(df_cmd %>% transmute(new_var, i_command = row_number))
# %>%
#   unnest(a) %>%
#   mutate(temp = "x") %>%
#   spread(a, temp) %>% View

df_in_out %>%
  transmute(from = input_args, to = new_vars) %>%
  unnest(from) %>%
  unnest(to) %>%
  tidygraph::as_tbl_graph() %>%
  # ggraph::ggraph(layout = "tree") +
  ggraph::ggraph() +
  ggraph::geom_edge_link() +
  ggraph::geom_node_label(aes(label = name))
