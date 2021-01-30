library(datenanpassr)

df <- data.frame(a = 1:10000)
action <- "#IF"
data <-  list(
  new_var = "x",
  condition = "a == 3",
  new_val = "2"
)

make_cmd_expression <- function(action, data) {
  switch (
    action,
    "#IF"     = rlang::expr(cmd_if(df, !!!data)),
    "#COMP"   = rlang::expr(cmd_comp(df, !!!data)),
    "#COMPR"   = rlang::expr(cmd_comp(df, !!!data)),
    "#REC"    = rlang::expr(cmd_rec(df, !!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar(df, !!!data)),
    "#RENAME" = rlang::expr(cmd_rename(df, !!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab(df, !!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab(df, !!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs(df, !!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs(df, !!!data)),
    "#KG"     = rlang::expr(cmd_kg(df, !!!data)),
    "#Verba"  = rlang::expr(cmd_verba(df, !!!data)),
    stop("Invalid action command")
  )
}

apply_one_cmd <- function(df, action, data) {
  cmd <- make_cmd_expression(action, data)
  rlang::eval_tidy(cmd)
}


microbenchmark::microbenchmark(
  apply_one_cmd(df, action, data),
  cmd_if(df,   new_var = "x",
         condition = "a == 3",
         new_val = "2")
)
