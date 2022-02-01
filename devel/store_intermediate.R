library(datenanpassr)
library(tidyverse)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
accumulate_command_blocks <- function(m, gen_intermediate_mapping = gen_intermediate_mapping_change) {


  single_cdbs <- purrr::map(1:nrow(m$cmd_tbl), ~m$cmd_tbl %>% dplyr::slice(.x) %>% dplyr::pull(command_blocks))

    l <- purrr::map(single_cdbs, gen_intermediate_mapping)
  res <- purrr::map(l, "dat_mod")
  # https://r6.r-lib.org/articles/Introduction.html#finalizers
  rm(l); gc()
  res
}

gen_intermediate_mapping_keep <- function(cdb, m = m0) {
  m$clone(deep = TRUE)$modify_data(reset = FALSE, command_blocks = cdb)
}
gen_intermediate_mapping_change <- function(cdb, m = m0) {
  m$modify_data(reset = FALSE, command_blocks = cdb)$clone(deep = TRUE)
}

m <- Mapping$new(fake_survey, mapping_file)
m0 <- m$clone(deep = TRUE)
m0$dat_mod <- m0$dat
# doesn't work for cmd_rename ??? :
# l_dat <- accumulate_command_blocks(m0, gen_intermediate_mapping_keep)
l_dat <- accumulate_command_blocks(m0)
