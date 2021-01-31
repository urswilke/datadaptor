spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
# don't call this dataframe df, as it would mask the dataframe created when
# source()ing the temporary script "mapping.R":
df_test <- haven::read_sav(spss_file)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
df_cmd <- mapp_cmd_table(mapping_file)
df_mod <- mapp_xl_to_data(df_test, df_cmd)

test_that("snapshot of the structure of the result of the mapping function mapp_xl_to_data()", {
  testthat::expect_snapshot_output(df_mod %>% str())
})


test_that("snapshot of the structure of the result of mapp_cmd_table()", {
  testthat::expect_snapshot_output(df_cmd %>% str())
})

test_that("translate_to_r_script results in the same as mapp_xl_to_data", {
  withr::with_file("mapping.R", {
    df_mod <- mapp_xl_to_data(df_test, df_cmd, na_to_filter = FALSE)
    translate_to_r_script(df_cmd, rscript_name = "mapping.R", spss_file)
    source("mapping.R", echo = FALSE)
    testthat::expect_equal(df_mod, df)
  })
})

