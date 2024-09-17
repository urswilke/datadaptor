mapping_file <- "excel/mapping_old.xlsx" |> testthat::test_path()
spss_file <- "spss/fake_survey.sav" |> testthat::test_path()
dat <- haven::read_sav(spss_file)

mapping <- Mapping$new(dat, mapping_file)
