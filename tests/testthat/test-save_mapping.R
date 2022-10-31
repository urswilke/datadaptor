mapping_file <- "excel/test_save.xlsx"
# expect_message(expect_message(m <- Mapping$new(dat = tibble(a = c(1:3, NA)), mapping_file = mapping_file)))
m <- Mapping$new(dat = tibble(a = c(1:3, NA)), mapping_file = mapping_file)
path <- m$params$save_path
save_file_types <- c("sav", "dta", "xlsx", "Rmd")
filenames <- "myfilename"
output_files <- paste0(path, "/", filenames, ".", save_file_types)
test_that("Mapping$save() seems to work", {

  withr::with_file(output_files, {
    m$modify_data()
    expect_error(m$save(path = paste0(path, "/fafda.luyfafda")))
    m$save(name = filenames, filetype = save_file_types[1:3])
    spss_output_vec  <- haven::read_sav(output_files[1])$a
    stata_output_vec <- haven::read_dta(output_files[2])$a
    excel_output_vec <- readxl::read_excel(output_files[3])$a
    vallabs_sav <- attr(spss_output_vec, "labels")
    vallabs_dta <- attr(stata_output_vec, "labels")
    expect_true(
      unique(c(names(vallabs_dta), names(vallabs_sav))) ==  "FILTER"
    )
    expect_equal(
      unique(c(
        tablab::strip_attributes(stata_output_vec),
        tablab::strip_attributes(spss_output_vec),
        excel_output_vec
      )),
      c(1:3, -2)
    )

  })
})

# I don't want the testthat output cluttered. therefore `if` and not `skip`...:
if (testthat:::on_ci()) {
  test_that("Mapping$save() seems to work for Rmd", {
    # skip_if_not(testthat:::on_ci())

    withr::with_file(output_files, {
      m$modify_data()
      m$save(name = filenames, filetype = save_file_types[4])
      expect_true(file.exists(output_files[4]))
      expect_true(file.exists(str_replace(output_files[4], "Rmd$", "html")))

    })
  })

}
