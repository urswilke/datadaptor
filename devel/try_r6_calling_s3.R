library(tidyverse)
library(datenanpassr)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")

# rr <- Mapping$new(spss_file, mapping_file)
# rr$calc_command_table()
# x <- rr$params$df_cmd_raw[47,] %>% command_block_factory() %>% parse_command_args()
# rr$apply_cmd_s3(x)
# rr$dat_mod$kq6 <- haven::labelled(rr$dat_mod$kq6, label = "a")
#
# x <- rr$params$df_cmd_raw[44,] %>% command_block_factory() %>% parse_command_args()
# rr$apply_cmd_s3(x)
#
# x <- rr$params$df_cmd_raw[51,] %>% command_block_factory() %>% parse_command_args()
# rr$apply_cmd_s3(x)
# x <- rr$params$df_cmd_raw[52,] %>% command_block_factory() %>% parse_command_args()
# rr$apply_cmd_s3(x)

rr <- Mapping$new(spss_file, mapping_file)
rr$calc_command_table()
rr$params$df_cmd_raw <- rr$params$df_cmd_raw %>%
  filter(action %in% c("#IF", "#COMP", "#VARL")) %>%
  slice(-3)
rr$apply_all_s3_cmds()
bench::mark(rr$apply_all_s3_cmds())

Mapping$debug("apply_all_s3_cmds")
rr$dat_mod
