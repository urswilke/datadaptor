spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
# don't call this dataframe df, as it would mask the dataframe created when
# source()ing the temporary script "mapping.R":
df_test <- haven::read_sav(spss_filepath)
mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
df_cmd <- mapp_cmd_table(mapping_filepath)
df_mod <- mapp_xl_to_data(df_test, df_cmd)

test_that("mapping function reproduces snapshot", {
  testthat::expect_snapshot_output(df_mod %>% str())
})


test_that("mapp_cmd_table() reproduces snapshot", {
  testthat::expect_snapshot_output(df_cmd %>% str())
})

test_that("translate_to_r_script results in the same as mapp_xl_to_data", {
  withr::with_file("mapping.R", {
    df_mod <- mapp_xl_to_data(df_test, df_cmd, na_to_filter = FALSE)
    translate_to_r_script(df_cmd, rscript_name = "mapping.R", spss_filepath)
    source("mapping.R", echo = FALSE)
    testthat::expect_equal(df_mod, df)
  })
})

