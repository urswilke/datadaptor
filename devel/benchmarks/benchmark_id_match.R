library(tidyverse)
n_obs <- 100
ass_by_in <- function(df, var_ziel, id, id_list, val_assign) {
  df[[var_ziel]][df[[id]] %in% id_list] <- val_assign
  df
}
ass_by_match <- function(id_list, df, id, df2, var_ziel, val_assign) {
  match_rows <- match(id_list, df[[id]])
  match_rows <- match_rows[!is.na(match_rows)]
  df2[match_rows, var_ziel] <- val_assign
  df2
}


bench_match <- function(n_obs) {
  df <- data.frame(id = 1:n_obs)
  df2 <- df
  var_ziel <- "test"
  id_list <- sample.int((n_obs * 1.1), n_obs / 2)
  val_assign <- 5
  id <- "id"

  a <- microbenchmark::microbenchmark(
    ass_by_in(df, var_ziel, id, id_list, val_assign),
    ass_by_match(id_list, df, id, df2, var_ziel, val_assign)
  )
  a

}
b <- 10^(1:6) |> set_names() |> map(bench_match)
# all.equal(df, df2)

b |>
  map(as_tibble) |>
  bind_rows(.id = "n") |>
  group_by(expr, n) |>
  summarise(t = mean(time)) |>
  ungroup() |>
  ggplot(aes(n, t, color = expr, group = expr)) +
  geom_line() +
  scale_y_log10()
