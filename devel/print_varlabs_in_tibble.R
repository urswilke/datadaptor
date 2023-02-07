library(pillar)
ctl_new_pillar.labelled_tbl <- function(controller, x, ..., title = NULL) {
  out <- NextMethod()
  varlab <- attr(x, "label", exact = TRUE)

  data_width <- attr(out[["data"]], "width")
  type_width <- attr(out[["type"]], "width")
  width <- max(data_width, type_width)
  if (is.null(varlab)) {
    varlab <- rep("-", width) |> paste(collapse = "")
  }
  varlab = stringr::str_trunc(varlab, width, ellipsis = "…") |> cli::col_blue()
  new_pillar(list(
    title = out$title,
    type = out$type,
    varlab = new_pillar_component(list(varlab), width = width),
    data = out$data
  ))
}
N <- 10
# Create an example tibble:
df <- tibble::tibble(
  id = 1:N,
  a = haven::labelled(
    sample(c(1:2, 99, NA), N, TRUE),
    label = "Do you feel good?",
    labels = c(
      `YESSS` = 1,
      `No` = 2,
      `No answer` = 99
    )
  ),
  b = haven::labelled(
    sample(LETTERS[1:N], N, TRUE),
    label = "LETTERS",
    labels = setNames(LETTERS, sample(LETTERS[1:N], N))
  )
)
class(df) <- c("labelled_tbl", class(df))
df

df2 <- df
attr(df2$a, "label") <- "new label"
diffobj::diffPrint(
  df,
  df2,
  mode = "sidebyside", interactive = FALSE
)
df3 <- df2
attr(df3$a, "labels") <- c(
  `Yes` = 1,
  `No` = 2,
  `No answer` = 99
)
diffobj::diffPrint(
  df,
  df3,
  mode = "sidebyside", interactive = FALSE
)
diffobj::diffPrint(
  df,
  df3[2:9,],
  mode = "sidebyside", interactive = FALSE
)
diffobj::diffPrint(
  df,
  df3[2:9,] |> dplyr::mutate(d = NA),
  mode = "sidebyside", interactive = FALSE
)
