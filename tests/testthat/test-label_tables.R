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
    update_var_table(dat_mod, mapping_file) |>
      print_without_row_numbers(n = 1111)
  })
})
test_that("update_label_table() print is reproduced", {
  testthat::expect_snapshot_output({
    update_label_table(dat_mod, mapping_file) |>
      print_without_row_numbers(n = 1111)
  })
})
mapping_label_checks <- mapping$clone(deep = TRUE)
mapping_label_checks$dat$q3[is.na(mapping_label_checks$dat$q3)] <- 1
mapping_label_checks$modify_data()
test_that("gen_var_table_raw() print is reproduced", {
  testthat::expect_snapshot_output({
    gen_var_table_raw(mapping_label_checks$dat_mod) |>
      print_without_row_numbers(n = 1111)
  })
})
test_that("gen_label_table_raw() print is reproduced", {
  testthat::expect_snapshot_output({
    tab_vallabs(mapping_label_checks$dat_mod) |>
      print_without_row_numbers(n = 1111)
  })
})

dat_s <- data.frame(
  q2 = haven::labelled(NA_real_, label = "xyz", labels = c(aaa = 1)),
  q3 = haven::labelled(NA_character_, labels = c(aaa = "a")),
  q4 = haven::labelled(NA_character_, labels = c(bbb = "b"))
)
test_that("gen_label_table() print is reproduced with labelled string variables", {
  testthat::expect_snapshot_output({
    testthat::expect_warning(
      res <- dat_s |> gen_label_table()
    )
    res |> print_without_row_numbers(n = 1111)
  })
})
