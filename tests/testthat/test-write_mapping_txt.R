m <- mapping$clone(deep = TRUE)
path <- "mapping_raw.txt"

txt_test_wrapper <- function(path) {
  write_mapping_txt(m, path)
  path
}
test_that("mapping txt export works", {
  withr::with_file(
    path, {
      write_mapping_txt(m, path)
      testthat::expect_snapshot(cat(readLines(path), sep = "\n"))
    })
})
