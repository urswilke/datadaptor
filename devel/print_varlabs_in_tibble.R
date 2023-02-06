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

spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
df <- haven::read_sav(spss_file)
df$chr_var <- haven::labelled(sample(LETTERS, 100, TRUE), labels = setNames(LETTERS, sample(LETTERS, 26)))
class(df) <- c("labelled_tbl", class(df))
df
