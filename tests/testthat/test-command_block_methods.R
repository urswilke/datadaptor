# m <- mapping$clone(deep = TRUE)
#
# cmd_tbl <- m$cmd_tbl |> filter(!duplicated(action) | action == "#verbatim" | new_var == "x")

# #RECNA:
dat <- data.frame(q2 = haven::labelled(NA_real_, label = "xyz"))
m1 <- Mapping$new(dat, list())
res_vec <- m1$modify_data()$dat_mod$q2

vallabs <- attr(res_vec, "labels")
num_res <- unique(c(
  strip_attributes(res_vec),
  vallabs,
  m1$opts$da$miss_rec_val
))
testthat::expect_equal(num_res, -2)
testthat::expect_named(vallabs, "FILTER")
testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "xyz")

# #NEWVALL:
dat <- data.frame(q2 = haven::labelled(NA_real_, labels = c("xyz" = 1)))
cdb <- list(Label = tibble::tribble(
  ~var, ~nv, ~vallab, ~cv, ~new_label, ~sum_var_label, ~sum_var_value, ~sum_var_vallab, ~orig_var,
  "q2",   1,   "yes",  NA,      "YES",             NA,             NA,              NA,      "q2"
))


m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)

res_vec <- m1$modify_data()$dat_mod$q2

vallabs <- attr(res_vec, "labels")
testthat::expect_named(attr(res_vec, "labels", exact = TRUE), "YES")

# #SUMVAR:
dat <- data.frame(q5 = haven::labelled(c(1:5, NA_real_), labels = c("xyz" = 1), label = "a"))
cdb <- list(Label = tibble::tribble(
  ~var, ~nv,      ~vallab, ~cv, ~sum_var_label, ~sum_var_value, ~sum_var_vallab, ~orig_var, ~new_label,
  "q5",   1, "not at all",  NA,         "test",              1,           "aaa",      "q5", "",
  "q5",   2,      "a bit",  NA,             NA,              1,              NA,      "q5", "",
  "q5",   3,     "normal",  NA,             NA,              2,           "bbb",      "q5", "",
  "q5",   4,       "much",  NA,             NA,              3,           "ccc",      "q5", "",
  "q5",   5,  "very much",  NA,             NA,              3,              NA,      "q5", "",
))
m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)

res_vec <- m1$modify_data()$dat_mod$kq5


vallabs <- attr(res_vec, "labels")

testthat::expect_named(vallabs, c("aaa", "bbb", "ccc"))
testthat::expect_equal(unname(vallabs), 1:3)
testthat::expect_equal(strip_attributes(res_vec), c(1, 1, 2, 3, 3, NA_real_))
# check that varlab is preserved if not defined:
m1$cmd_tbl$command_blocks[[2]]$args$varlab <- NA_character_
res_vec <- m1$modify_data()$dat_mod$kq5
testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "a")

# #DROP:
dat <- data.frame(q1 = 1, q9 = 2)
cdb <- list(Variables = tibble(
  var = "q9",
  op = "d",
  new_name = NA_character_,
  new_label = NA_character_
))
m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)

res_df <- m1$modify_data()$dat_mod

testthat::expect_named(res_df, "q1")

# #RENAME_varsheet:
cdb <- list(Variables = tibble(
  var = c("q1", "q9"),
  op = NA_character_,
  new_name = c("q9", "q1"),
  new_label = NA_character_
))
m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)
res_df <- m1$modify_data()$dat_mod

testthat::expect_named(res_df, c("q9", "q1"))

# #RENAME:
cdb <- list(Free1 = tibble::tribble(
  ~X1,        ~X2,  ~X3, ~X4, ~X5,
  "#RENAME", "q1", "q9",  NA,  NA,
  NA,        "q9", "q1",  NA,  NA
))

m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)
res_df <- m1$modify_data()$dat_mod

testthat::expect_named(res_df, c("q9", "q1"))


# #NEWLAB:
dat <- data.frame(q1 = 1)
m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)
cdb <- list(Variables = tibble::tribble(
  ~var,                             ~varlab,    ~type,     ~new_label,
  "q1", "How much do you like the product?", "double", "Like Product"
))
m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)

res_vec <- m1$modify_data()$dat_mod$q1

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "Like Product")


# # #verbatim EFA:
# m1 <- m$clone(deep = TRUE)
# m1$dat <- data.frame(id = 1:10, q5 = rep(1:2, 5))
# cdb <- cmd_tbl |> filter(action == "#verbatim", new_var == "q6n") |> pull(command_blocks)
# res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$q6n
# vallabs <- attr(res_vec, "labels")
#
# testthat::expect_equal(
#   names(vallabs),
#   c("FILTER", "love", "joy", "happiness", "Others", "No answer")
# )
# testthat::expect_equal(unname(vallabs), c(-2, 1, 2, 3, 97, 99))
# testthat::expect_equal(
#   strip_attributes(res_vec),
#   c(NA, 3, NA, 2, NA, 2, NA, 1, NA, 1)
# )
# testthat::expect_null(attr(res_vec, "label", exact = TRUE))




# #COMP:
dat <- data.frame(
  x = haven::labelled(c(1:2, NA_real_), labels = c("xyz" = 1), label = "xyz"),
  q1 = c(1, 1, 2)
)
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  "#COMP", "x", "q1 == 2", NA, NA
))


m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)
res_vec <- m1$modify_data()$dat_mod$x

vallabs <- attr(res_vec, "labels")

testthat::expect_named(vallabs, "xyz")
testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "xyz")
testthat::expect_equal(unname(vallabs), 1)
testthat::expect_equal(strip_attributes(res_vec), c(0, 0, 1))


# #IF:
dat <- data.frame(
  q3 = 1:3,
  q1 = c(1, 0, 2),
  abc = haven::labelled(rep(NA_real_, 3), labels = c(a = 1), label = "b")
)
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  "#IF", "q1 == 1 | q3 == 2", "abc = 7", NA, NA
))

m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)


res_vec <- m1$modify_data()$dat_mod$abc

vallabs <- attr(res_vec, "labels")

testthat::expect_named(vallabs, "a")
testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "b")
testthat::expect_equal(unname(vallabs), 1)
testthat::expect_equal(strip_attributes(res_vec), c(7, 7, NA))

# #REC:
dat <- data.frame(
  q1 = haven::labelled(c(1:5, NA_real_), labels = c("xyz" = 1), label = "aaa"),
  x = 6:11
)
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  "#REC", "q1", "kq1", "summarized variable", NA,
  NA, "1", "2", "1", "1-2",
  NA, "3", "3", "2", "3",
  ".", "4", "5", "3", "4-5"
))

m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)

res_vec <- m1$modify_data()$dat_mod$kq1

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(
  attr(res_vec, "label", exact = TRUE),
  "summarized variable"
)
testthat::expect_named(vallabs, c("1-2", "3", "4-5"))
testthat::expect_equal(unname(vallabs), 1:3)
testthat::expect_equal(strip_attributes(res_vec), c(1, 1, 2, 3, 3, NA_real_))

# check that varlab is preserved if not defined:
cdb_mod <- m1$cmd_tbl$command_blocks
cdb_mod[[1]]$args$varlab <- NA_character_
res_vec <- m1$modify_data(command_blocks = cdb_mod)$dat_mod$kq1
testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "aaa")

# check that partial overwriting of existing variable works:
cdb_mod <- m1$cmd_tbl$command_blocks
cdb_mod[[1]]$args$x <- NA_character_
res_vec <- m1$modify_data(command_blocks = cdb_mod)$dat_mod$q1

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(
  attr(res_vec, "label", exact = TRUE),
  "summarized variable"
)
testthat::expect_named(vallabs, c("1-2", "3", "4-5"))
testthat::expect_equal(unname(vallabs), 1:3)
testthat::expect_equal(strip_attributes(res_vec), c(1, 1, 2, 3, 3, NA_real_))




# #KG:
dat <- data.frame(
  q2_renamed = haven::labelled(c(1, 1, 2), labels = c(a = 1), label = "b"),
  kq1 = haven::labelled(1:3, labels = c(a = 1), label = "b")
)
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  "#KG", "kq1", "q2_renamed", NA, NA
))


m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)

res_df <- m1$modify_data()$dat_mod

vallabs1 <- attr(res_df$kq1xq2_renamedk10, "labels")
vallabs2 <- attr(res_df$kq1xq2_renamedk20, "labels")

testthat::expect_equal(vallabs1, vallabs2)
testthat::expect_equal(
  attr(res_df$kq1xq2_renamedk10, "label", exact = TRUE),
  "a: b"
)
testthat::expect_equal(strip_attributes(res_df$kq1xq2_renamedk10), c(1, 2, NA))
testthat::expect_equal(strip_attributes(res_df$kq1xq2_renamedk20), c(NA, NA, 3))

# #VARL:
dat <- data.frame(n = 1)
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  "#VARL", "n", "my new label", NA, NA
))

m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)

res_vec <- m1$modify_data()$dat_mod$n

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "my new label")


# #VALL:
dat <- data.frame(n = 1)
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  "#VALL", "n", "overwrite new label", NA, NA,
  NA, "1", "also with", NA, NA,
  NA, "2", "value labels", NA, NA,
  ".", "3", "now", NA, NA
))




m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)
res_vec <- m1$modify_data()$dat_mod$n
vallabs <- attr(res_vec, "labels")

testthat::expect_equal(
  attr(res_vec, "label", exact = TRUE),
  "overwrite new label"
)
testthat::expect_named(vallabs, c("also with", "value labels", "now"))
testthat::expect_equal(unname(vallabs), 1:3)
testthat::expect_equal(strip_attributes(res_vec), 1)

# check that varlab is preserved if not defined:
m1$dat <- data.frame(n = haven::labelled(1, label = "aaa"))
m1$cmd_tbl$command_blocks[[1]]$args["varlab"] <- list(NULL)
res_vec <- m1$modify_data()$dat_mod$n

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "aaa")


# #AVALL:
dat <- data.frame(n = haven::labelled(1:3, labels = c(a = 1), label = "b"))
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  "#AVALL", "n", NA, NA, NA,
  ".", "4", "added label", NA, NA
))


m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)
res_vec <- m1$modify_data()$dat_mod$n
vallabs <- attr(res_vec, "labels")

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "b")
testthat::expect_named(vallabs, c("a", "added label"))
testthat::expect_equal(unname(vallabs), c(1, 4))
testthat::expect_equal(strip_attributes(res_vec), 1:3)


# #DIC:
dat <- data.frame(
  q4_renamed = 1:3,
  q3 = haven::labelled(1:3, labels = c(a = 1), label = "b")
)
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  "#DIC", "q3", "q4_renamed", NA, NA
))


m1 <- Mapping$new(dat, cdb, na_to_filter = FALSE)
res_vec <- m1$modify_data()$dat_mod$q4_renamed

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "b")
testthat::expect_named(vallabs, "a")
testthat::expect_equal(unname(vallabs), 1)
testthat::expect_equal(strip_attributes(res_vec), 1:3)

# check that variable is initialized if not already present:
m1$cmd_tbl$command_blocks[[1]]$args$x <- "newvar"
res_vec <- m1$modify_data()$dat_mod$newvar
testthat::expect_equal(strip_attributes(res_vec), rep(NA_real_, 3))


# mapping passes with empty first column on Free sheet, but text in others:
dat <- data.frame(
  q3 = haven::labelled(c(1:2, NA), labels = c(a = 1), label = "b")
)
cdb <- list(Free1 = tibble::tribble(
  ~X1, ~X2, ~X3, ~X4, ~X5,
  NA, "abc", "def", NA, NA
))


m1 <- Mapping$new(dat, cdb)
res_vec <- m1$modify_data()$dat_mod$q3

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(vallabs, c(FILTER = -2L, a = 1L))
testthat::expect_equal(res_vec |> strip_attributes(), c(1, 2, -2))
