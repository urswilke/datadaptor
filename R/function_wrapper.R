#' @export
write_var_table <- function(mapping_file, sheet_name = "Variables") {
  mapping <- Mapping$new(mapping_file = mapping_file)
  mapping$cmd$sheet_data_raw[[sheet_name]]
}
#' @export
write_labs_table <- function(mapping_file, sheet_name = "Label") {
  write_var_table(mapping_file, sheet_name = sheet_name)
}
