dat <- data.frame(
  x = haven::labelled(c(1:2, NA_real_), labels = c("xyz" = 1), label = "xyz"),
  q1 = c(1, 1, 2)
)
# random string of 20 letters:
madeup_cmd <- paste(sample(letters, 20, TRUE), collapse = "")
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  madeup_cmd, "x", "q1 == 2", NA, NA
))

testthat::expect_error(
  m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE),
  madeup_cmd
)
