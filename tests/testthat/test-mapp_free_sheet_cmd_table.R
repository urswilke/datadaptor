mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
df_free <- mapp_free_sheet_cmd_table(mapping_filepath)
test_that("snapshot of (the structure of) mapp_free_sheet_cmd_table()", {
  testthat::expect_snapshot_output(df_free)
  testthat::expect_snapshot_output(df_free %>% str())
})
