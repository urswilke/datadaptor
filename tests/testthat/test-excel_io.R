path <- "mapping.xlsx"

test_that("mapping xlsx generation works", {
  withr::with_file(
    path,
    {
      testthat::expect_message(
        create_mapping(dat, path),
        regexp = paste0("Excel mapping file written to '", path, "'")
      )

      sheet_names <- readxl::excel_sheets(path)
      suppressMessages(l <- purrr::map(
        sheet_names,
        ~ readxl::read_xlsx(path, sheet = .x)
      ))

      testthat::expect_snapshot(
        l |>
          purrr::set_names(sheet_names)
      )
    }
  )
})
