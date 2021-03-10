# from here: https://github.com/tidyverse/tidyr/issues/250
unfill_vec <- function(x, y) {
  same <- y == dplyr::lag(y)
  ifelse(!is.na(same) & same, NA, x)
}

df_cmd %>%
  mutate(i = row_number()) %>%
  unnest_longer(data, "values", indices_to = "arg_name") %>%
  mutate(values = map_chr(values, ~deparse1(.x, collapse = ", "))) %>%
  mutate(
    across(c(action, new_var, row), ~unfill_vec(.x, i)),
    sheet = unfill_vec(sheet, sheet)
  ) %>%
  relocate(i) %>%
  relocate(values, .after = last_col()) %>%
  writexl::write_xlsx("moegliches_df_cmd_output.xlsx")
