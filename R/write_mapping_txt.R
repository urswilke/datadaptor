write_mapping_txt <- function(self,
                              path = paste0(self$params$save_path, "/mapping.txt")) {
  write_object(self$cmd$sheet_data_raw, path)
}
write_varlabs_txt <-
  function(self,
           path = paste0(self$params$save_path, "/varlabs", suffix, ".txt"),
           dat = self$dat_mod,
           suffix = "") {
    if (!is.null(dat)) {
      write_object(tablab::tab_varlabs(dat), path)
    }
  }
write_vallabs_txt <-
  function(self,
           path = paste0(
             self$params$save_path,
             "/vallabs",
             suffix,
             ".txt"
           ),
           dat = self$dat_mod,
           suffix = ""
           ) {
    if (!is.null(dat)) {
      write_object(tablab::tab_vallabs(dat), path)
    }
  }
write_varlabs_raw_txt <- function(self,
                                  path = paste0(self$params$save_path, "/varlabs", suffix, ".txt"),
                                  dat = self$dat,
                                  suffix = "_raw") {
  write_object(tablab::tab_varlabs(dat), path)
}
write_vallabs_raw_txt <- function(
  self,
  path = paste0(self$params$save_path, "/vallabs", suffix, ".txt"),
  dat = self$dat,
  suffix = "_raw"
) {
  write_object(tablab::tab_vallabs(dat), path)
}
write_counts_txt <- function(
  self,
  path = paste0(self$params$save_path, "/counts", suffix, ".txt"),
  dat = self$dat_mod,
  suffix = ""
) {
  dat %>%
    dplyr::select(where(is.numeric)) %>%
    tidyr::pivot_longer(dplyr::everything()) %>%
    dplyr::count(name, value) %>%
    dplyr::group_by(name) %>%
    dplyr::filter(dplyr::n() != nrow(m$dat)) %>%
    dplyr::ungroup() %>%
    write_object(path)
}
write_counts_raw_txt <- function(
  self,
  path = paste0(self$params$save_path, "/counts", suffix, ".txt"),
  dat = self$dat,
  suffix = "_raw"
) {
  dat %>%
    dplyr::select(where(is.numeric)) %>%
    tidyr::pivot_longer(dplyr::everything()) %>%
    dplyr::count(name, value) %>%
    dplyr::group_by(name) %>%
    dplyr::filter(dplyr::n() != nrow(m$dat)) %>%
    dplyr::ungroup() %>%
    write_object(path)
}
write_object <- function(
  obj,
  path,
  # pillar.width = 111111,
  ...
) {
  withr::with_output_sink(
    path,
    withr::with_options(
      list(
        # pillar.width = pillar.width,
        pillar.print_max = 111111,
        ...
      ),
      print(obj)
    )
  )
}
