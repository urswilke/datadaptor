spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
# don't call this dataframe df, as it would mask the dataframe created when
# source()ing the temporary script "mapping.R":
df_test <- haven::read_sav(spss_file)# %>% dplyr::slice(1:15)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
df_cmd <- mapp_cmd_table(mapping_file)
df_mod <- mapp_xl_to_data(df_test, df_cmd)

test_that("result of the mapping function mapp_xl_to_data()", {
  testthat::expect_snapshot_output(df_mod)
  testthat::expect_snapshot_output(df_mod %>% str())
})


test_that("result of mapp_cmd_table()", {
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

test_that("minimal example for mapp_xl_to_data()", {
  df_cmd <- tibble::tibble(action = "#IF", data = list(list(new_var = "a", new_val = "7", condition = "a == 2")))
  attr(df_cmd, "id_var") <- "id"
  result <- mapp_xl_to_data(data.frame(id = 1:3, a = 1:3), df_cmd) %>% dplyr::pull(a)
  attributes(result) <- NULL
  expect_equal(result, c(1, 7, 3))
})
