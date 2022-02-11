library(dplyr, warn.conflicts = FALSE)

m <- mapping$clone(deep = TRUE)

cmd_tbl <- m$cmd_tbl %>% filter(!duplicated(action) | action == "#verbatim")

# #RECNA:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(q2 = haven::labelled(NA_real_, label = "xyz"))
cdb_recna <- cmd_tbl %>% filter(action == "#RECNA") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb_recna)$dat_mod$q2

vallabs <- attr(res_vec, "labels")
num_res <- unique(c(
  tablab::strip_attributes(res_vec),
  vallabs,
  m1$params$miss_rec_val
))
testthat::expect_equal(num_res, -2)
testthat::expect_equal(names(vallabs), "FILTER")
testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "xyz")

# #NEWVALL:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(q2 = haven::labelled(NA_real_, labels = c("xyz" = 1)))
cdb <- cmd_tbl %>% filter(action == "#NEWVALL", new_var == "q2") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$q2

vallabs <- attr(res_vec, "labels")
testthat::expect_equal(names(attr(res_vec, "labels", exact = TRUE)), "YES")

# #SUMVAR:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(q5 = haven::labelled(c(1:5, NA_real_), labels = c("xyz" = 1)))
cdb <- cmd_tbl %>% filter(action == "#SUMVAR", new_var == "kq5") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$kq5

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(names(vallabs), c("aaa", "bbb", "ccc"))
testthat::expect_equal(unname(vallabs), 1:3)
testthat::expect_equal(tablab::strip_attributes(res_vec), c(1, 1, 2, 3, 3, NA_real_))

# #DROP:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(q1 = 1, q9 = 2)
cdb <- cmd_tbl %>% filter(action == "#DROP") %>% pull(command_blocks)
res_df <- m1$modify_data(command_blocks = cdb)$dat_mod

testthat::expect_equal(names(res_df), "q1")

# #RENAME:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(q2 = 1, q4 = 2)
cdb <- cmd_tbl %>% filter(action == "#RENAME") %>% pull(command_blocks)
res_df <- m1$modify_data(command_blocks = cdb)$dat_mod

testthat::expect_equal(names(res_df), c("q2_renamed", "q4_renamed"))


# #NEWLAB:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(q1 = 1)
cdb <- cmd_tbl %>% filter(action == "#NEWLAB", new_var == "q1") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$q1

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "Like Product")


# #verbatim EFA:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(id = 1:10, q5 = rep(1:2, 5))
cdb <- cmd_tbl %>% filter(action == "#verbatim", new_var == "q6n") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$q6n
vallabs <- attr(res_vec, "labels")

testthat::expect_equal(
  names(vallabs),
  c("FILTER", "love", "joy", "happiness", "Others", "No answer")
)
testthat::expect_equal(unname(vallabs), c(-2, 1, 2, 3, 97, 99))
testthat::expect_equal(
  tablab::strip_attributes(res_vec),
  c(NA, 3, NA, 2, NA, 2, NA, 1, NA, 1)
)
testthat::expect_null(attr(res_vec, "label", exact = TRUE))




# #COMP:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(
  x = haven::labelled(c(1:2, NA_real_), labels = c("xyz" = 1), label = "xyz"),
  q1 = c(1, 1, 2)
)
cdb <- cmd_tbl %>% filter(action == "#COMP", new_var == "x") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$x

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(names(vallabs), "xyz")
testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "xyz")
testthat::expect_equal(unname(vallabs), 1)
testthat::expect_equal(tablab::strip_attributes(res_vec), c(0, 0, 1))


# #IF:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(
  q3 = 1:3,
  q1 = c(1, 0, 2),
  abc = haven::labelled(rep(NA_real_, 3), labels = c(a =1), label = "b")
)
cdb <- cmd_tbl %>% filter(action == "#IF", new_var == "abc") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$abc

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(names(vallabs), "a")
testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "b")
testthat::expect_equal(unname(vallabs), 1)
testthat::expect_equal(tablab::strip_attributes(res_vec), c(7, 7, NA))

# #REC:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(q1 = haven::labelled(c(1:5, NA_real_), labels = c("xyz" = 1)))
cdb <- cmd_tbl %>% filter(action == "#REC", new_var == "kq1") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$kq1

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "summarized variable")
testthat::expect_equal(names(vallabs), c("1-2", "3", "4-5"))
testthat::expect_equal(unname(vallabs), 1:3)
testthat::expect_equal(tablab::strip_attributes(res_vec), c(1, 1, 2, 3, 3, NA_real_))


# #KG:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(
  q2_renamed = haven::labelled(c(1, 1, 2), labels = c(a =1), label = "b"),
  kq1 = haven::labelled(1:3, labels = c(a =1), label = "b")
)
cdb <- cmd_tbl %>% filter(action == "#KG", new_var == "kq1_q2_renamed") %>% pull(command_blocks)
res_df <- m1$modify_data(command_blocks = cdb)$dat_mod

vallabs1 <- attr(res_df$kq1xq2_renamedk10, "labels")
vallabs2 <- attr(res_df$kq1xq2_renamedk20, "labels")

testthat::expect_equal(vallabs1, vallabs2)
testthat::expect_equal(attr(res_df$kq1xq2_renamedk10, "label", exact = TRUE), "a: b")
testthat::expect_equal(tablab::strip_attributes(res_df$kq1xq2_renamedk10), c(1, 2, NA))
testthat::expect_equal(tablab::strip_attributes(res_df$kq1xq2_renamedk20), c(NA, NA, 3))

# #VARL:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(n = 1)
cdb <- cmd_tbl %>% filter(action == "#VARL", new_var == "n") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$n

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "my new label")


# #VALL:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(n = 1)
cdb <- cmd_tbl %>% filter(action == "#VALL", new_var == "n") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$n
vallabs <- attr(res_vec, "labels")

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "overwrite new label")
testthat::expect_equal(names(vallabs), c("also with", "value labels", "now"))
testthat::expect_equal(unname(vallabs), 1:3)
testthat::expect_equal(tablab::strip_attributes(res_vec), 1)

# #AVALL:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(n = haven::labelled(1:3, labels = c(a =1), label = "b"))
cdb <- cmd_tbl %>% filter(action == "#AVALL", new_var == "n") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$n
vallabs <- attr(res_vec, "labels")

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "b")
testthat::expect_equal(names(vallabs), c("a", "added label"))
testthat::expect_equal(unname(vallabs), c(1, 4))
testthat::expect_equal(tablab::strip_attributes(res_vec), 1:3)


# #DIC:
m1 <- m$clone(deep = TRUE)
m1$dat <- data.frame(
  q4_renamed = 1:3,
  q3 = haven::labelled(1:3, labels = c(a =1), label = "b")
)
cdb <- cmd_tbl %>% filter(action == "#DIC", new_var == "q4_renamed") %>% pull(command_blocks)
res_vec <- m1$modify_data(command_blocks = cdb)$dat_mod$q4_renamed

vallabs <- attr(res_vec, "labels")

testthat::expect_equal(attr(res_vec, "label", exact = TRUE), "b")
testthat::expect_equal(names(vallabs), "a")
testthat::expect_equal(unname(vallabs), 1)
testthat::expect_equal(tablab::strip_attributes(res_vec), 1:3)




