write_mapping_txt <- function(
  self,
  path = paste0(self$opts$da$save_path, "/mapping_raw.txt")
) {
  with_output_sink(
    path,
    with_options(
      list(
        pillar.print_max = 111111
      ),
      print(self$cmd$sheet_data_raw)
    )
  )
}
