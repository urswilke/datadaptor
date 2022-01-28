mapping_file <- "excel/test_stata_output.xlsx"
expect_message(m <- Mapping$new(dat = fake_survey, mapping_file = mapping_file))
stata_output_file <- "stata_output_Free1_1.dta"

test_that("stata output seems to work", {

  withr::with_file(stata_output_file, {
    m$modify_data()
    stata_output_df <- haven::read_dta(stata_output_file)
    vallabs <- attr(stata_output_df$q1, "labels")
    expect_true(
      "FILTER" %in% names(vallabs)
    )

  })
})
