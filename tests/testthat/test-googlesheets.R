test_that("googlesheet mapping works", {
  testthat::skip_if_offline()
  googlesheets4::gs4_deauth()
  mapping_file <- "1NKTyTOKNXCimUNDImlQpiI7DK4FW_GK7EcqYnkMbpCY"
  m <- Mapping$new(mtcars_labelled, mapping_file, mapping_type = "google")
  m$modify_data()
  testthat::expect_snapshot_output({
    m$dat_mod |> tab_vallabs() |> print(n = 10000)
  })
  testthat::expect_snapshot_output({
    m$dat_mod |> tab_varlabs() |> print(n = 10000)
  })
  testthat::expect_snapshot_output({
    m$dat_mod |> print(width = 10000)
  })
})
