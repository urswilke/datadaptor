write_mapping_txt <- function(self, path = paste0(self$params$save_path, "/mapping_raw.txt")) {
  withr::with_output_sink(
    path,
    withr::with_options(
      list(
        # pillar.width = 111111,
        pillar.print_max = 111111
      ),
      print(self$cmd$sheet_data_raw)
    )
  )
}
