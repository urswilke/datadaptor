mapping_s3 <- mapping$clone(deep = TRUE)
test_that("parameters (except those containing filepaths) were built correctly", {
  testthat::expect_snapshot_output(
    mapping_s3$params[!names(mapping_s3$params) %in% c(
      "expr_eval_env",
      "mapping_file",
      "save_path"
    )]
  )
})


mapping_raw_list <- list(Variables = tibble(
  var = "q1",
  op = NA_character_,
  new_name = NA_character_,
  new_label = "hello"
))
mapping_from_list <- Mapping$new(
  dat = "spss/q1_1.sav",
  mapping_file = mapping_raw_list
)
mapping_from_list$modify_data()
mapping_from_list$dat_mod$q1
testthat::expect_equal(
  attr(mapping_from_list$dat_mod$q1, "label", exact = TRUE),
  "hello"
)
