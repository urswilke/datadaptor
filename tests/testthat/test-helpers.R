test_that("extract_curly_lists() works", {
  expect_equal(extract_curly_lists("{1 2}a{3 4}"), c("1a3", "2a4"))
})
