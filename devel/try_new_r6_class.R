# library(tidyverse)
library(datenanpassr)

# source("devel/apply_one_command_s3.R")
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")


rr <- Mapping$new(spss_file, mapping_file, try_catch = TRUE)
rr$calc_command_table()

rr$df_cmd$data[[46]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
rr$df_cmd$data[[47]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
rr$df_cmd$data[[48]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"

rr$mod_all()
rr$dat_mod

Mapping$debug("initialize")
