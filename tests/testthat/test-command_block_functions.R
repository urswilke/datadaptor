test_that("cmd_set_lab() works", {
  df <- data.frame(x = 1)
  df <- cmd_set_lab(df, "x", "testlab")
  varlab <- attr(df$x, "label", exact = TRUE)
  expect_equal(varlab, "testlab")
})

test_that("cmd_set_labs() works", {
  df <- data.frame(x = 1)
  df <- cmd_set_labs(df, "x", new_vals = 1:2, new_labs = c("vallab1", "vallab2"))
  vallabs <- attr(df$x, "labels", exact = TRUE)
  expect_equal(vallabs, c(vallab1 = 1, vallab2 = 2))
})

test_that("cmd_add_labs() works", {
  x <- haven::labelled(1:2, labels = c("vallab1" = 1), label = "var label")
  df <- data.frame(x)
  df <- cmd_add_labs(df, orig_var = "x", vals_added = 2, labs_added = c("vallab2"))
  vallabs <- attr(df$x, "labels", exact = TRUE)
  expect_equal(vallabs, c(vallab1 = 1, vallab2 = 2))
})

