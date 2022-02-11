library(dplyr, warn.conflicts = FALSE)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")

mapping <- Mapping$new(spss_file, mapping_file)
