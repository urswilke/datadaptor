spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
# don't call this dataframe df, as it would mask the dataframe created when
# source()ing the temporary script "mapping.R":
df_test <- haven::read_sav(spss_file)# %>% dplyr::slice(1:15)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
# get rid of
# "New names:
# * `` -> ...2"
# message
# &
# Note: Using an external vector in selections is ambiguous.
# ℹ Use `all_of(.x)` instead of `.x` to silence this message.
# ℹ See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
# This message is displayed once per session.
testthat::expect_message(testthat::expect_message(mapping_file_struc <- mapp_cmd_table(mapping_file)))
df_mod <- mapp_xl_to_data(df_test, mapping_file_struc)

testthat::expect_message(mapping_file_struc_vec <- mapp_cmd_table(mapping_file, vectorized = TRUE))
df_mod_vec <- mapp_xl_to_data(df_test, mapping_file_struc_vec, vectorized = TRUE)

test_that("vectorized vesion of mapp_xl_to_data() results in the same", {
  testthat::expect_equal(df_mod_vec %>% tibble::as_tibble(), df_mod %>% tibble::as_tibble())
})


test_that("result of the mapping function mapp_xl_to_data()", {
  testthat::expect_snapshot_output(df_mod)
  testthat::expect_snapshot_output(df_mod %>% str())
})


test_that("result of mapp_cmd_table()", {
  testthat::expect_snapshot_output(
    mapping_file_struc[["df_cmd"]] %>%
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

test_that("translate_to_r_script results in the same as mapp_xl_to_data", {
  withr::with_file("mapping.R", {
    df_mod <- mapp_xl_to_data(df_test, mapping_file_struc) %>% tibble::as_tibble()
    attr(df_mod, "cmd_index") <- NULL
    attr(df_mod, "error_list") <- NULL
    translate_to_r_script(mapping_file_struc, rscript_name = "mapping.R", spss_file)
    source("mapping.R", echo = FALSE)
    testthat::expect_equal(df_mod, df)
  })
})


# TODO??: make it work with new OOP structure
# test_that("minimal example for mapp_xl_to_data()", {
#   df_cmd <- tibble::tibble(action = "#IF", data = list(list(new_var = "a", new_val = "7", condition = "a == 2")))
#   attr(df_cmd, "id_var") <- "id"
#   attr(df_cmd, "vectorized") <- FALSE
#   result <- mapp_xl_to_data(data.frame(id = 1:3, a = 1:3), df_cmd) %>% dplyr::pull(a)
#   attributes(result) <- NULL
#   expect_equal(result, c(1, 7, 3))
# })


test_that("mapp_xl_to_data() throws error for erroneous code, and message if try_catch = TRUE", {
  mapping_file_struc[["df_cmd"]] <- mapping_file_struc[["df_cmd"]] %>% dplyr::filter(action == "#IF") %>% dplyr::slice(1)
  mapping_file_struc[["df_cmd"]]$data[[1]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
  testthat::expect_error(df_mod <- mapp_xl_to_data(df, mapping_file_struc))
  testthat::expect_message(df_mod <- mapp_xl_to_data(df, mapping_file_struc, try_catch = TRUE))
})

