mapping_file <- system.file("extdata", "mapping_xlsm.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "tablebook.sav", package = "datenanpassr")


mapping_xlsm <- Mapping$new(spss_file, mapping_file, translate_xlsm = T)

mapping_xlsm$modify_data()

cbs <- mapping_xlsm$cmd_tbl$command_blocks
incl_block_bool <-
  !purrr::map_chr(cbs, "action") %in%
  c("#MERGE", "#RFUN")
test_that("command blocks print is reproduced", {
  testthat::expect_snapshot_output({
    cbs[incl_block_bool]
  }

  )
})

test_that("s3 modified data print is reproduced", {
  testthat::expect_snapshot_output({
    mapping_xlsm$dat_mod |> print(width = 10000)
  }

  )
})
test_that("value labels are reproduced", {
  testthat::expect_snapshot_output({
    mapping_xlsm$dat_mod |> tab_vallabs() |> print(n = 10000)
  })
})
test_that("variable labels are reproduced", {
  testthat::expect_snapshot_output({
    mapping_xlsm$dat_mod |> tab_varlabs() |> print(n = 10000)
  })
})


