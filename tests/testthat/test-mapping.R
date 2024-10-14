testthat::expect_equal(class(mapping), c("Mapping", "R6"))
testthat::expect_warning(
  Mapping$new(mapping_file = "excel/mapping_with_non_defined_param.xlsx")
)




mapping_file <- "excel/mapping_old.xlsx"
spss_file <- "spss/fake_survey.sav"


mapping_s3 <- mapping$clone(deep = TRUE)

mapping_s3$modify_data()


test_that("s3 modified data print is reproduced", {
  testthat::expect_snapshot_output({
    mapping_s3$dat_mod |> print(width = 10000)
  })
})
test_that("value labels are reproduced", {
  testthat::expect_snapshot_output({
    mapping_s3$dat_mod |>
      tab_vallabs() |>
      print_without_row_numbers(n = 1111)
  })
})
test_that("variable labels are reproduced", {
  testthat::expect_snapshot_output({
    mapping_s3$dat_mod |>
      tab_varlabs() |>
      print_without_row_numbers(n = 1111)
  })
})


# The following 3 lines lead to the same as:
# mapping_trycatch <- Mapping$new(spss_file, mapping_file, error_out = "safe")
mapping_trycatch <- mapping$clone(deep = TRUE)
mapping_trycatch$params$error_out <- "safe"
class(mapping_trycatch$cmd_tbl$command_blocks) <- c("safe", "command_blocks", "list")
mapping_trycatch$cmd_tbl$command_blocks[[62]]$args$ex_cond <- "q1 ==(*%$@ 1 |} q3 == 2"

testthat::expect_message(mapping_trycatch$modify_data())
error_list <- mapping_trycatch$params$error_list
cmd_tbl_error_col <- mapping_trycatch$cmd_tbl$error
err_idx <- which(error_list != "")
err_idx2 <- which(cmd_tbl_error_col != "")
test_that("Non-empty indices of error list are correctly detected", {
  testthat::expect_equal(err_idx, 62)
  testthat::expect_equal(err_idx2, 62)
})
test_that("error string elements were added to cmd_tbl", {
  testthat::expect_snapshot_output({
    mapping_trycatch$cmd_tbl
  })
})

mapping_uppercase <- mapping$clone(deep = TRUE)
mapping_uppercase$dat <- mapping_uppercase$dat[paste0("q", 1:4)] |>
  dplyr::rename_with(toupper)
mapping_uppercase$cmd_tbl <- mapping_uppercase$cmd_tbl |>
  filter(action == "#RENAME_varsheet")

mapping_uppercase$params$lowercase_varnames <- TRUE
mapping_uppercase$modify_data()
mapping_uppercase$dat_mod
testthat::expect_equal(
  c("Q1", "q2_renamed", "Q3", "q4_renamed"),
  mapping_uppercase$dat_mod |> names()
)
