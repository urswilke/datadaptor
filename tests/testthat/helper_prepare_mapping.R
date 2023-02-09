library(dplyr, warn.conflicts = FALSE)
library(stringr)
mapping_file <- "excel/mapping_old.xlsx"
spss_file <- "spss/fake_survey.sav"
dat <- haven::read_sav(spss_file)

mapping <- Mapping$new(dat, mapping_file)
