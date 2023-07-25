set.seed(2)
q2 <- haven::labelled(c(3:1, NA_real_, rep(3, 6)), labels = purrr::set_names(1:3, c(LETTERS[1:2], "Other, namely:")))
q3_1 <- haven::labelled(c(NA, NA, 3, NA, NA, 1, rep(NA, 4)), labels = purrr::set_names(1:4, c(LETTERS[1:4])))
q3_2 <- haven::labelled(c(NA, 2, rep(NA, 4), 2, rep(NA, 3)), labels = purrr::set_names(1:4, c(LETTERS[1:4])))
q3_3 <- haven::labelled(c(4, NA, NA, NA, sample(1:4, 6, replace = TRUE)), labels = purrr::set_names(1:4, paste("rating:", LETTERS[1:4])))


dat <- tibble::tibble(
  id = 1:10,
  q2,
  q3_1,
  q3_2,
  q3_3
)
meta_mdg_custom <- tibble::tibble(
  q_id = "mdg",
  VariableOriginal = "var_containing_open_answer_strings",
  EFA1MCG2MDG3 = "mdg_custom",
  VariableZiel = "q3_{nn}",
  ex_further_cond = 'q2 == 3',
  ex_assign = "q3_3"
)
meta_efa <- tibble::tibble(
  q_id = "mdg",
  VariableOriginal = "var_containing_open_answer_strings",
  EFA1MCG2MDG3 = "1",
  VariableZiel = "q2",
)

assignments <- tibble::tibble(
  ID = 1:10,
  Antwort = LETTERS[1:10],
  `Zuord 1` = c(4, NA, NA, NA, sample(c(1, 2, 4, 5), 6, TRUE)),
)

labs <- tibble::tibble(
  Code = 1:5,
  lab = LETTERS[1:5]
)

name <- "verba_tab_for_variable_map"
make_cdb_raw <- function(name, meta, assignments, labs) {
  cdb_raw <- list(
    name = name,
    meta = meta,
    assignments = assignments,
    labs = list()
  )
  cdb_raw$labs$name <- labs
  cdb_raw
}

# It's important to execute mdg_custom before efa, because
# efa will change the value of of q2 (serving for ex_further_cond of mdg_custom):
cdbs_raw <- list(meta_mdg_custom, meta_efa) |>
  purrr::map(~make_cdb_raw(name = name, meta = .x, assignments = assignments, labs = labs))

m <- Mapping$new(dat, list(Verbatims = cdbs_raw), na_to_filter = FALSE, id_var = "id")

m$modify_data()
test_that("modified data print is reproduced", {
  testthat::expect_snapshot_output(
    m$dat_mod
  )
})
test_that("variable labels are reproduced", {
  testthat::expect_snapshot_output(
    m$dat_mod |> tab_varlabs() |> print_without_row_numbers()
  )
})
test_that("value labels are reproduced", {
  testthat::expect_snapshot_output(
    m$dat_mod |> tab_vallabs() |> print_without_row_numbers(n = 1111)
  )
})



