df_free <- mapp_free_sheet_cmd_table(mapping)
test_that("snapshot of (the structure of) mapp_free_sheet_cmd_table()", {
  testthat::expect_snapshot_output(df_free)
  testthat::expect_snapshot_output(
    df_free |>
      # dirty hack to remove absolute path (in order to make the test pass on
      # other systems...):
      dplyr::mutate(data = ifelse(
        action %in% c("#MERGE", "#RFUN"),
        purrr::map(data, ~{.x$X2 <- stringr::str_remove(.x$X2, ".*/"); .x}),
        data)
      ) |>
      str()) |>
    print_without_row_numbers(n = 1111)
})
