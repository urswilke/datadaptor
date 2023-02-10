mapping_file <- "excel/test_save.xlsx"
expect_message(expect_message(m <- Mapping$new(dat = tibble(a = c(1:3, NA)), mapping_file = mapping_file)))
path <- m$params$save_path
save_file_types <- c("sav", "dta", "xlsx")
filenames <- "myfilename"
output_files <- paste0(path, "/", filenames, ".", save_file_types)
test_that("Mapping$save() seems to work", {

  withr::with_file(output_files, {
    m$modify_data()
    expect_error(m$save(path = paste0(path, "/fafda.luyfafda")))
    m$save(name = filenames, filetype = save_file_types[1:3])
    spss_output_vec  <- haven::read_sav(output_files[1])$a
    stata_output_vec <- haven::read_dta(output_files[2])$a
    excel_output_vec <- readxl::read_xlsx(output_files[3])$a
    vallabs_sav <- attr(spss_output_vec, "labels")
    vallabs_dta <- attr(stata_output_vec, "labels")
    expect_true(
      unique(c(names(vallabs_dta), names(vallabs_sav))) ==  "FILTER"
    )
    expect_equal(
      unique(c(
        strip_attributes(stata_output_vec),
        strip_attributes(spss_output_vec),
        excel_output_vec
      )),
      c(1:3, -2)
    )

  })
})

