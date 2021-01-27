test_that("extract_sev_lists() works", {
  expect_equal(extract_sev_lists("{1 2}a{3 4}"), c("1a3", "2a4"))
})
