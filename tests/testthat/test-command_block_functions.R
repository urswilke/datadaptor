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
  # add value label:
  df1 <- cmd_add_labs(df, orig_var = "x", vals_added = 2, labs_added = c("vallab2"))
  vallabs <- attr(df1$x, "labels", exact = TRUE)
  expect_equal(vallabs, c(vallab1 = 1, vallab2 = 2))
  # replace value label:
  df2 <- cmd_add_labs(df, orig_var = "x", vals_added = 1, labs_added = c("replaced_vallab1"))
  vallabs2 <- attr(df2$x, "labels", exact = TRUE)
  expect_equal(vallabs2, c(replaced_vallab1 = 1))
})

test_that("cmd_if() works for conditions on all NA vectors", {
  x_new <- cmd_if(data.frame(x = 1:3, y = NA_real_), "x", "y == 4", "2") %>% dplyr::pull(x)
  expect_equal(x_new, 1:3)
})

