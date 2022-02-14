write_mapping_txt <- function(self, path = paste0(self$params$save_path, "/mapping_raw.txt")) {
  filepath <- path
  withr::with_output_sink(
    filepath,
    withr::with_options(
      list(
        pillar.print_max = 111111#,
        # pillar.width = 111111
      ),
      print(self$cmd$sheet_data_raw)
    )
  )
}
