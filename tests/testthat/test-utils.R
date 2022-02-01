df_curly <- data.frame(
  X1 = "#IF",
  X2 = "q{2 3} == 1",
  X3 = "kq{5 6} = {7 8}",
  X4 = NA_character_,
  row = "1"
)

test_that("snapshot of curlychop() is reproduced", {
  testthat::expect_snapshot_output(
    curlychop(df_curly)
  )
})
