mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")


mapping <- Mapping$new(spss_file, mapping_file)
mapping$params$try_catch <- TRUE
testthat::expect_message(testthat::expect_message(mapping$calc_command_table()))


mapping$df_cmd$data[[46]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
mapping$df_cmd$data[[47]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
mapping$df_cmd$data[[48]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"

testthat::expect_message(testthat::expect_message(testthat::expect_message(mapping$mod_all())))
dat_mod <- mapping$dat_mod

test_that("command table is reproduced", {
  testthat::expect_snapshot_output(
    mapping$df_cmd %>%
      # dirty hack to remove absolute path (in order to make the test pass on
      # other systems...):
      dplyr::mutate(data = ifelse(
        action %in% c("#MERGE"),
        purrr::map(data, ~{.x$merge_file <- stringr::str_remove(.x$merge_file, ".*/"); .x}),
        data)
      ) %>%
      dplyr::mutate(data = ifelse(
        action %in% c("#RFUN"),
        purrr::map(data, ~{.x$r_script <- stringr::str_remove(.x$r_script, ".*/"); .x}),
        data)
      ) %>%
      str())
})

test_that("modified data is reproduced", {
  testthat::expect_snapshot_output(
    dat_mod
  )
})
test_that("class object print is reproduced", {
  testthat::expect_snapshot_output(
    mapping
  )
})
mapping_s3 <- Mapping$new(spss_file, mapping_file)
testthat::expect_message(mapping_s3$gen_command_table_raw())
# filter commands that are already implemented:
mapping_s3$params$df_cmd_raw <- mapping_s3$params$df_cmd_raw %>%
  dplyr::filter(action %in% c("#IF", "#COMP", "#VARL", "#VALL", "#REC", "#SUMVAR", "#AVALL", "#DIC", "#AUTOREC", "STR2NUM", "#RENAME", "#MERGE", "#NEWVALL", "#verbatim", "#NEWLAB", "#DROP", "#KG", "#RFUN", "#R")) #%>%
  # command depends on variables built in those filtered:
  # dplyr::slice(-5)
mapping_s3$apply_all_s3_cmds()
test_that("command blocks print is reproduced", {
  testthat::expect_snapshot_output({
    mapping_s3$params$command_blocks[mapping_s3$params$command_blocks %>% purrr::map_chr("action") != "#MERGE"]
  }

  )
})

test_that("s3 modified data print is reproduced", {
  testthat::expect_snapshot_output({
    mapping_s3$dat_mod %>% print(width = 10000)
  }

  )
})

