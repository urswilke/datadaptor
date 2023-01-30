test_that("gen_data_table() works", {
  testthat::expect_snapshot_output({
    gen_data_table(fake_survey) |> dplyr::as_tibble() |> print(n=1111)
  })
})

mapping_dd <- mapping$clone(deep = TRUE)
mapping_dd$modify_data()
test_that("diff_data() works", {
  testthat::expect_snapshot_output({
    df1 <- mapping_dd$dat
    df2 <- mapping_dd$dat_mod |> select(any_of(names(df1)))
    diff_data(df1, df2, "id") |> print(n=1111)
  })
})


