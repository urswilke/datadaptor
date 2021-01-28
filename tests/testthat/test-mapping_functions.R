spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
df <- haven::read_sav(spss_filepath)
mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")

test_that("mapping function reproduces snapshot", {
  df_mod <- mapp_xl_to_data(df, mapping_filepath)
  testthat::expect_snapshot_output(df_mod %>% str())
})


test_that("mapp_cmd_table() reproduces snapshot", {
  df_cmd <- mapp_cmd_table(mapping_filepath)
  testthat::expect_snapshot_output(df_cmd %>% str())
})

