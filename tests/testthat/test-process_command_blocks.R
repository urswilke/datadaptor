mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")


mapping_s3 <- Mapping$new(spss_file, mapping_file)
test_that("parameters were built correctly", {
  testthat::expect_snapshot_output(
    mapping_s3$params[!names(mapping_s3$params) %in% c("expr_eval_env", "mapping_file")])
})

cb_err <- mapping_s3$cmd$df_cmd_raw[10,]
cb_err$action <- "uillu"
testthat::expect_error(cbs_err <- cb_err %>% command_block() %>% parse_command_args() %>% list(.) %>% datenanpassr:::new_command_blocks(subclass = "unsafe"))
