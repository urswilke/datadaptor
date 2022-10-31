library(dplyr, warn.conflicts = FALSE)
library(stringr)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
dat <- haven::read_sav(spss_file)

mapping <- Mapping$new(dat, mapping_file)
mapping$wb <- NULL
mapping$verbatim_wbs <- NULL
