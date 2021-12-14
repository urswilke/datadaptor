library(tidyverse)
library(datenanpassr)

source("devel/apply_one_command_s3.R")
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")


# df_cmd = mapp_cmd_table(mapping_file, vectorized = FALSE)$df_cmd
df_cmd = Mapping$new(spss_file, mapping_file, vectorized = FALSE)
df_cmd$data[[46]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
df_cmd$data[[47]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
df_cmd$data[[48]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"

rr <- ApplyMods$new(datenanpassr::fake_survey, mapping_file, try_catch = TRUE)
# apply first command in df_cmd:
rr$apply_one_cmd_r6(df_cmd$action[1], df_cmd$data[[1]])
rr$mod_all()
rr$dat_mod

rr <- ApplyMods$new(datenanpassr::fake_survey, df_cmd, vectorized = TRUE)
rr$mod_all()
rr$dat_mod %>% attr("error_list")
