test_that("gen_data_table() works", {
  testthat::expect_snapshot_output({
    gen_data_table(dat) |> dplyr::as_tibble() |> print_without_row_numbers(n = 1111)
  })
})
mapping_dd <- mapping$clone(deep = TRUE)
# mapping_dd$cmd_tbl <- mapping_dd$cmd_tbl |> filter(action != "#FILTER")
mapping_dd$modify_data()
test_that("diff_data() works", {
  testthat::expect_snapshot_output({
    cols_to_diff <- c("id", "q1", "q4", "q6")
    df1 <- mapping_dd$dat[cols_to_diff]
    df2 <- mapping_dd$dat_mod[cols_to_diff]
    testthat::expect_warning(res <- diff_data(df1, df2, "id"))
    # names(res) <- abbreviate(names(res) |> str_replace("_", " "), minlength = 2)
    res |>
      mutate(across(where(is.character), \(x) str_sub(x, end = 5))) |>
      print_without_row_numbers(n = Inf, width = Inf)
  })
})


