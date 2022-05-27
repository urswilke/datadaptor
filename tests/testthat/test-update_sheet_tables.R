mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
dat_mod <- dat %>%
  # add a new variable in the first column of the dataframe:
  dplyr::mutate(
    new_var = haven::labelled(
      1,
      label = "variable label of new_var",
      labels = c("value label of value 1 of new_var" = 1)
    ),
    .before = 1
  )
test_that("update_var_table() print is reproduced", {
  testthat::expect_snapshot_output({
    update_var_table(dat_mod, mapping_file) %>% print(n = 1111)
  })
})
test_that("update_label_table() print is reproduced", {
  testthat::expect_snapshot_output({
    update_label_table(dat_mod, mapping_file) %>% print(n = 1111)
  })
})

