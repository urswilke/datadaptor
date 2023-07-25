library(dplyr, warn.conflicts = FALSE)
library(stringr)
library(pillar)
# mapping_file <- "tests/testthat/excel/mapping_old.xlsx"
mapping_file <- "excel/mapping_old.xlsx"
# spss_file <- "tests/testthat/spss/fake_survey.sav"
spss_file <- "spss/fake_survey.sav"
dat <- haven::read_sav(spss_file)

mapping <- Mapping$new(dat, mapping_file)


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
vctrs::s3_register(
  "pillar::ctl_new_rowid_pillar", "pillar_no_rownumber",
  ctl_new_rowid_pillar.pillar_no_rownumber
)
