write_csvs <- function(self, path = paste0(self$params$save_path, "")) {
  sheet_data_raw <- self$cmd$sheet_data_raw
  verbatim_data <- sheet_data_raw$Verbatims
  sheet_data_raw$Verbatims <- NULL
  filepaths <- paste0(path, "/", names(sheet_data_raw), ".tsv")
  sheet_data_raw %>%
    set_names(filepaths) %>%
    iwalk(~readr::write_tsv(.x %>% as_tibble(), .y))

  fileroots <- verbatim_data %>% map_chr("name")
  filepaths <- paste0(path, "/", fileroots, ".tsv")
  verbatim_data %>%
    set_names(fileroots) %>%
    walk(~{
      name <- .x$name
      .x$name <- NULL
      .x$labs <- .x$labs[[1]]
      names(.x) <- paste0(name, "_", names(.x))

      names(.x) <- paste0(path, "/", names(.x), ".tsv")
      .x %>%
        imap(~readr::write_tsv(.x %>% as_tibble(), .y))
      NULL
    })
}
