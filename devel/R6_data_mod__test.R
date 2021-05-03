library(tidyverse)
library(datenanpassr)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")

r6mod <- R6::R6Class(
  "r6datamod",
  list(
    dat = datenanpassr::fake_survey,
    mod = function(action, data){
      self$dat <- datenanpassr:::apply_one_cmd.nonvec_unsafe(self$dat, action, data)
      invisible(self)
    }
  )
)

rr <- r6mod$new()

df_cmd = mapp_cmd_table(mapping_file)$df_cmd
rr$mod(df_cmd$action[1], df_cmd$data[[1]])

walk2(df_cmd$action, df_cmd$data, rr$mod)
rr$dat

