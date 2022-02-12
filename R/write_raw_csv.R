write_csvs <- function(self, path = paste0(self$params$save_path, "")) {
  sheet_data_raw <- self$cmd$sheet_data_raw
  verbatim_data <- sheet_data_raw$Verbatims
  sheet_data_raw$Verbatims <- NULL
  filepaths <- paste0(path, "/", names(sheet_data_raw), ".tsv")
  sheet_data_raw %>%
    purrr::set_names(filepaths) %>%
    purrr::iwalk(~readr::write_tsv(.x %>% tibble::as_tibble(), .y))

  fileroots <- verbatim_data %>% purrr::map_chr("name")
  filepaths <- paste0(path, "/", fileroots, ".tsv")
  verbatim_data %>%
    purrr::set_names(fileroots) %>%
    purrr::walk(~{
      name <- .x$name
      .x$name <- NULL
      .x$labs <- .x$labs[[1]]
      names(.x) <- paste0(name, "_", names(.x))

      names(.x) <- paste0(path, "/", names(.x), ".tsv")
      .x %>%
        purrr::imap(~readr::write_tsv(.x %>% tibble::as_tibble(), .y))
      NULL
    })
}
