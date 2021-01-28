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

test_that("cmd_sumvar() works", {
  orig_var <- 1:5
  new_vals <- new_vals <- c(1, 1, 2, 3, 3)
  new_labs <- c("a", "b", "c")
  new_lab <- "new variable label"
  orig_vals <- 1:5
  new_labs <- c("a", NA, "b", "c", NA)
  df <- data.frame(orig_var)
  df <- cmd_sumvar(df, "new_var", "orig_var", new_lab, orig_vals, new_vals, new_labs)
  x_new <- df$new_var
  varlab <- attr(x_new, "label", exact = TRUE)
  vallabs <- attr(x_new, "labels", exact = TRUE)
  attributes(x_new) <- NULL
  expect_equal(x_new, c(1, 1, 2, 3, 3))
  expect_equal(varlab, "new variable label")
  expect_equal(vallabs, c(a = 1, b = 2, c = 3))
})

test_that("cmd_rec() works", {
  orig_var <- 1:5
  df <- data.frame(orig_var)
  lb = c(1, 3, 4)
  ub = c(2, NA, 5)
  new_lab <- "abc"
  new_vals <- 1:3
  new_labs <- c("a", "b", "c")
  df <- cmd_rec(
    df,
    orig_var = "orig_var",
    new_var = "new_var",
    new_lab = new_lab,
    lb = lb,
    ub = ub,
    new_vals = new_vals,
    new_labs = new_labs
  )

  x_new <- df$new_var
  varlab <- attr(x_new, "label", exact = TRUE)
  vallabs <- attr(x_new, "labels", exact = TRUE)
  attributes(x_new) <- NULL
  expect_equal(x_new, c(1, 1, 2, 3, 3))
  expect_equal(varlab, "abc")
  expect_equal(vallabs, c(a = 1, b = 2, c = 3))
})

test_that("cmd_comp() works", {
  df <- cmd_comp(data.frame(x = c(1, 2, NA)), "y", "x * 2")
  expect_equal(df$y, c(2, 4, NA))
})

test_that("cmd_verbatim() works", {
  df <- data.frame(id_var = 1:3)
  df <- cmd_verbatim(
    df,
    var_ziel = "new_var",
    val_assign = 2,
    varlab = "abc",
    vallab = c("vallab2" = 2),
    id = "id_var",
    id_list = c(1, 1, 4)
  )
  x_new <- df$new_var
  varlab <- attr(x_new, "label", exact = TRUE)
  vallabs <- attr(x_new, "labels", exact = TRUE)
  attributes(x_new) <- NULL
  expect_equal(x_new, c(2, NA, NA))
  expect_equal(varlab, "abc")
  expect_equal(vallabs, c(vallab2 = 2))
})

