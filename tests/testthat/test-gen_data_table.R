test_that("gen_data_table() works", {
  testthat::expect_snapshot_output({
    gen_data_table(fake_survey) |> dplyr::as_tibble() |> print(n=1111)
  })
})
