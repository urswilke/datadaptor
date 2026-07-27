qs2_file <- tempfile(fileext = ".qs2")
test_that("roundtripping example data to the qs2 format works", {
  withr::with_file(qs2_file, {
    example_data <- data.frame(x = haven::labelled(1, c(a = 1)))
    qs2::qs_save(example_data, qs2_file)
    m <- datadaptor::Mapping$new(qs2_file, mapping_file)

    expect_identical(
      m$dat,
      example_data
    )
  })
})
