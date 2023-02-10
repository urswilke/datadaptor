# tibble(q1 = 1) |> haven::write_sav("tests/testthat/spss/q1_1.sav")
# m_unrefreshed <- Mapping$new(dat = "tests/testthat/spss/q1_1.sav", mapping_file = "tests/testthat/excel/mapping_comp.xlsx")
m_unrefreshed <- Mapping$new(dat = "spss/q1_1.sav", mapping_file = "excel/mapping_comp.xlsx")
# m_unrefreshed$mapping_file <- "tests/testthat/excel/mapping_refresh.xlsx"
# pretend as if the file was modified, by changing the mapping_file in the
# Mapping object:
m_unrefreshed$mapping_file <- "excel/mapping_refresh.xlsx" |>
  as_mapping_file_string()
m_unrefreshed$params$refresh_sheet <- TRUE
m_unrefreshed$modify_data()

testthat::expect_equal(m_unrefreshed$dat_mod$b, 3)
# check that only the commands of the active sheet were modified:
testthat::expect_equal(m_unrefreshed$dat_mod$a, 1)


