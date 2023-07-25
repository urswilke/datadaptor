mapping_file <- "excel/mapping_old.xlsx"
spss_file <- "spss/fake_survey.sav"
dat_mod <- dat |>
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
    update_var_table(dat_mod, mapping_file) |> print(n = 1111)
  })
})
test_that("update_label_table() print is reproduced", {
  testthat::expect_snapshot_output({
    update_label_table(dat_mod, mapping_file) |> print(n = 1111)
  })
})
# dat_with_non_na <- dat
# dat_with_non_na$q3[is.na(dat_with_non_na$q3)] <- 1
# mapping_label_checks <- Mapping$new(dat = dat_with_non_na, mapping_file = mapping_file)
mapping_label_checks <- mapping$clone(deep = TRUE)
mapping_label_checks$modify_data()
test_that("gen_var_table_raw() print is reproduced", {
  testthat::expect_snapshot_output({
    gen_var_table_raw(mapping_label_checks$dat_mod) |> as.data.frame() |> print(row.names = FALSE)
  })
})
test_that("gen_label_table_raw() print is reproduced", {
  testthat::expect_snapshot_output({
    tab_vallabs(mapping_label_checks$dat_mod) |> as.data.frame() |> print(row.names = FALSE)
  })
})
