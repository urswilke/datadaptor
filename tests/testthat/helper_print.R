print_without_row_numbers <- function(df, ...) {
  class(df) <- c("pillar_no_rownumber", class(df))
  print(df, ...)
}

# tweaked from https://pillar.r-lib.org/articles/extending.html#row-ids:
ctl_new_rowid_pillar.pillar_no_rownumber <- function(controller, x, width, ...) {
  out <- NextMethod()
  rowid <- ""
  width <- 0
  pillar::new_pillar(
    list(
      title = out$title,
      type = out$type,
      data = pillar::pillar_component(
        pillar::new_pillar_shaft(list(row_ids = rowid),
                         width = width,
                         class = "pillar_rif_shaft"
        )
      )
    ),
    width = width
  )
}

# adapted from here: https://github.com/tidyverse/tibble/blob/4de5c153ca5411fe2a02804a8cafb0edd9c664dc/tests/testthat/helper-pillar.R#L10
vctrs::s3_register(
  "pillar::ctl_new_rowid_pillar", "pillar_no_rownumber",
  ctl_new_rowid_pillar.pillar_no_rownumber
)
