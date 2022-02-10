mapping_s3 <- mapping$clone(deep = TRUE)
test_that("parameters (except those containing filepaths) were built correctly", {
  testthat::expect_snapshot_output(
    mapping_s3$params[!names(mapping_s3$params) %in% c("expr_eval_env", "mapping_file", "save_path")])
})

cb_err <- mapping_s3$cmd$df_cmd_raw[10,]
cb_err$action <- "uillu"
testthat::expect_error(cbs_err <- cb_err %>% command_block() %>% parse_command_args() %>% list(.) %>% datenanpassr:::new_command_blocks(subclass = "unsafe"))
