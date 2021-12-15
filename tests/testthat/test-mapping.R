mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")


mapping <- Mapping$new(spss_file, mapping_file, try_catch = TRUE)

mapping$calc_command_table()

mapping$df_cmd$data[[46]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
mapping$df_cmd$data[[47]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
mapping$df_cmd$data[[48]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"

mapping$mod_all()
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
