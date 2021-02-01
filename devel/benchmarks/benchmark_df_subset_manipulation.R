df_test <- matrix(sample(1:10, 1e8, TRUE), 1e4, 1e4) %>% as_tibble()

mod_whole <- function(df, var = "V1") {
  # df %>% mutate(!!rlang::sym(var) := !!rlang::parse_expr("ifelse(!!rlang::sym(var) == 1, 2, NA_real_)"))
  df %>% mutate(!!rlang::sym(var) := if_else(!!rlang::sym(var) == 1, 2, NA_real_))
}
mod_sub <- function(df, var = "V1") {
  df[var] <-
    df[var] %>% mutate(!!rlang::sym(var) := if_else(!!rlang::sym(var) == 1, 2, NA_real_))
  df
}

# however, AFAIK, the speed of data.table won't work when using reduce(), as a
# copy will be passed for each iteration...:
DT <- data.table::as.data.table(df_test)
var_dt <- "V1"
expr_dt <- rlang::parse_expr("V1 == 3")
ass_dt <- rlang::parse_expr("3 * V1")
mod_dt <- function(DT){
  # DT[eval(expr_dt), V1 := 3 * V1]
  DT[eval(expr_dt), (var_dt) := eval(ass_dt)]
}



microbenchmark::microbenchmark(
  df_test %>% mod_whole(),
  df_test %>% mod_sub(),
  DT %>% mod_dt()
)

