
test_that("main function works", {
  spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
  df <- haven::read_sav(spss_filepath)
  mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
  df_mod <- mapp_xl_to_data(df, mapping_filepath)
  testthat::expect_snapshot_output(df_mod)
})
