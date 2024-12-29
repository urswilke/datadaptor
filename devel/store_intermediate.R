library(datadaptor)
library(tidyverse)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datadaptor")
accumulate_command_blocks <- function(m) {
  # generate a list of nrow(`m$cmd_tbl`) command_blocks elements, each
  # containing just one line of `m$cmd_tbl`:
  single_cdbs <- purrr::map(
    seq_len(nrow(m0$cmd_tbl)),
    ~m0$cmd_tbl |> dplyr::slice(.x) |> dplyr::pull(command_blocks)
  )

  # apply each singe row command_blocks to the result of the previous mapping,
  # generating a list of Mapping objects (like purrr::accumulate but for R6):
  gen_intermediate_mapping <- function(cdb, mm = m0) {
    mm$modify_data(reset = FALSE, command_blocks = cdb)$clone(deep = TRUE)
  }
  l <- purrr::map(single_cdbs, gen_intermediate_mapping)
  # Extract R6 field of all Mapping objects in list:
  res <- purrr::map(l, "dat_mod")

  # https://r6.r-lib.org/articles/Introduction.html#finalizers
  rm(l, m0); gc()
  res
}

m <- Mapping$new(fake_survey, mapping_file)
m0 <- m$clone(deep = TRUE)
m0$dat_mod <- m0$dat

l_dat <- accumulate_command_blocks(m0)
