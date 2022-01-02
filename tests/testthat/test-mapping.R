mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")


mapping_s3 <- Mapping$new(spss_file, mapping_file)
# tests doesnt work on other machines:
# test_that("class object print is reproduced", {
#   testthat::expect_snapshot_output(
#     mapping_s3
#   )
# })
# testthat::expect_message(testthat::expect_message(mapping_s3$gen_command_table_raw()))

# filter commands that are already implemented:
mapping_s3$modify_data()
test_that("command blocks print is reproduced", {
  testthat::expect_snapshot_output({
    mapping_s3$cmd_tbl$command_blocks[mapping_s3$cmd_tbl$command_blocks %>% purrr::map_chr("action") != "#MERGE"]
  }

  )
})

test_that("s3 modified data print is reproduced", {
  testthat::expect_snapshot_output({
    mapping_s3$dat_mod %>% print(width = 10000)
  }

  )
})



mapping_trycatch <- Mapping$new(spss_file, mapping_file)
# testthat::expect_message(mapping_trycatch$gen_command_table_raw())
mapping_trycatch$cmd$df_cmd_raw$raw[[46]]$X2 <- "q1 ==(*%$@ 1 |} q3 == 2"
mapping_trycatch$cmd$df_cmd_raw$raw[[47]]$X2 <- "q1 ==(*%$@ 1 |} q3 == 2"
mapping_trycatch$cmd$df_cmd_raw$raw[[48]]$X2 <- "q1 ==(*%$@ 1 |} q3 == 2"
mapping_trycatch$params$error_out <- "safe"
mapping_trycatch$cmd$command_blocks_raw <- gen_command_blocks_raw(mapping_trycatch)
mapping_trycatch$cmd$command_blocks <- command_blocks(mapping_trycatch)
mapping_trycatch$cmd_tbl <- gen_command_table(mapping_trycatch)

testthat::expect_message(testthat::expect_message(testthat::expect_message(mapping_trycatch$modify_data())))
test_that("error list print is reproduced", {
  testthat::expect_snapshot_output({
    mapping_trycatch$params$error_list[46:48]
  }

  )
})
test_that("error string elements were added to the erroneous command blocks", {
  testthat::expect_snapshot_output({
    mapping_trycatch$cmd_tbl$error[46:48]
  })
})
test_that("error string elements were added to cmd_tbl", {
  testthat::expect_snapshot_output({
    mapping_trycatch$cmd_tbl
  })
})
