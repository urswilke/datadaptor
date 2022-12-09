#' Turn code blocks into multiple by replacing the curly braces by each of the parts inside
#'
#' This function turns the first line of code blocks of the "Free" sheets into
#' multiple by replacing the curly braces
#' by each of the parts inside (separated by spaces). This can help to save yourself
#' from repetitive writing without diving into something like regular expressions.
#'
#' @param df_free_raw code blocks read in by \code{mapp_free_sheet_cmd_table_raw()}
#'
#' @return Dataframe containing multiple code blocks. The number of returned code blocks
#'  corresponds to the number of space separated parts in the curly brackets.
#'  The part embraced by the curly braces of the
#'  initial code block is replaced by each of the space separated parts.
#' @export
#'
#' @examples
#' # Minimal example:
#' df_curly <- data.frame(
#'   X1 = "#IF",
#'   X2 = "q{2 3} == 1",
#'   X3 = "kq{5 6} = {7 8}",
#'   X4 = NA_character_,
#'   row = "1"
#' )
#' curlychop(df_curly)
#'
#' # Extensive example:
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' df_free_raw <- datenanpassr:::mapp_free_sheet_cmd_table_raw(mapping_file) %>%
#'   dplyr::filter(stringr::str_detect(X2, "\\{"))
#' curlychop(df_free_raw)
#' # For reference, open the "Free1" sheet in the Excel file via:
#' \dontrun{
#' utils::browseURL(mapping_file)
#' }
curlychop <- function(df_free_raw) {
  df_prep <- df_free_raw %>%
    dplyr::mutate(raw_index = cumsum(is_true_vec(stringr::str_detect(.data$X1, "^#")))) %>%
    dplyr::group_by(.data$raw_index) %>%
    dplyr::mutate(
      row = paste(row, collapse = ", "),
      is_curly_group = dplyr::if_any(.fns = ~ stringr::str_detect(.x[1], "\\{")) %>% is_true_vec()
    ) %>%
    dplyr::add_count(.data$raw_index) %>%
    dplyr::group_by(.data$raw_index)

  df_curly_headers <- df_prep %>%
    dplyr::filter(dplyr::if_any(c("X2", "X3"), ~ stringr::str_detect(.x, "\\{.*\\}")))
  if (nrow(df_curly_headers) == 0) {
    return(df_prep %>%
      dplyr::select(-dplyr::all_of(c("is_curly_group", "n"))))
  }
  df_headers_curliplied <- df_curly_headers %>%
    curlychop_headers()

  l_commands <- df_prep %>%
    dplyr::group_split()
  command_has_curlies_lgl <- df_prep %>%
    dplyr::summarise(lgl = .data$is_curly_group[1], .groups = "drop") %>%
    dplyr::pull(.data$lgl)

  l_commands[command_has_curlies_lgl] <- purrr::map2(
    df_headers_curliplied %>% dplyr::group_by(.data$raw_index) %>% dplyr::group_split(),
    l_commands[command_has_curlies_lgl],
    add_further_rows_to_multiline_curlies
  )

  dplyr::bind_rows(l_commands) %>%
    dplyr::select(-dplyr::all_of(c("is_curly_group", "n")))
}

curlychop_headers <- function(df) {
  df |>
    dplyr::mutate(dplyr::across(c(X2, X3), ~list(split_curly_parts(.x))))|>
    tidyr::unnest(c(X2, X3))
}
split_curly_parts <- function(string,
                              opener = "\\{",
                              closer = "\\}") {

  open_or_closer <- paste0("[", opener, closer, "]")

  if (!isTRUE(str_detect(string, open_or_closer))) {
    return(string)
  }
  # split the string into different parts. either:
  # - extract everything (.*) (lazily (?), if there are multiple parts,
  #   each between
  #   opener & cloder) between opener and closer, OR
  # - extract the parts that are NOT
  #   (implemented with negative look-arounds, see https://stackoverflow.com/a/2973495)
  #   between opener & closer
  split_pattern <- paste0(
    # BETWEEN opener & closer:
    opener,
    ".*?",
    closer,
    # OR
    "|",
    # NOT BETWEEN opener & closer:
    # negative look-behind:
    "(?<!", opener, ")",
    # all but opener/closer:
    "[^", opener, closer, "]",
    # occurring at least once (no empty strings):
    "+",
    # negative look-ahead:
    "(?!", closer, ")"
  )
  split_string <- stringr::str_extract_all(string, split_pattern)[[1]]

  is_curly_part <- stringr::str_detect(split_string, open_or_closer)
  inside_curly_parts <- split_string[is_curly_part] |>
    stringr::str_remove_all(open_or_closer) |>
    stringr::str_squish() |>
    stringr::str_split(" ")
  curly_parts_lengthes_over1 <- inside_curly_parts |>
    lengths() |>
    unique() |>
    dplyr::setdiff(1)
  if (length(curly_parts_lengthes_over1) > 1) {
    warning(
      "There are different lengths > 1 in this expression for curlychop():\n",
      string
    )
  }
  parts_list <- as.list(split_string)
  parts_list[is_curly_part] <- inside_curly_parts
  do.call(paste0, parts_list)
}



# first argument are the severalized header lines of the command block,
# the second is the original command block dataframe:
add_further_rows_to_multiline_curlies <- function(df_header_lines, df_block_original) {
  if (df_header_lines$n[1] == 1) {
    return(
      df_header_lines %>%
        dplyr::mutate(row = paste0(row, "_", dplyr::row_number()))
    )
  }
  df_header_lines %>%
    dplyr::rowwise() %>%
    dplyr::group_split() %>%
    purrr::imap_dfr(
      ~ .x %>%
        dplyr::bind_rows(df_block_original[-1, ]) %>%
        dplyr::mutate(row = paste0(row, "_", .y))
    )
}

merge_vallabs <- function(old_vallab_vec, added_vallab_vec) {
  all_vals <- c(old_vallab_vec, added_vallab_vec)
  all_labels <- c(names(old_vallab_vec), names(added_vallab_vec))
  replaced_vals <- duplicated(all_vals, fromLast = TRUE)
  purrr::set_names(
    all_vals[!replaced_vals],
    all_labels[!replaced_vals]
  ) %>%
    sort()
}

# From here: https://github.com/r-lib/vctrs/issues/23
#' Vectorized \code{isTRUE()}
#'
#'
#' @param x Logical vector
#'
#' @return Logical vector that's TRUE if \code{x = TRUE} and \code{FALSE} if \code{x = FALSE or NA}.
#' @export
#'
#' @examples
#' is_true_vec(c(NA, TRUE, FALSE))
is_true_vec <- function(x) Vectorize(isTRUE)(x)

# see https://github.com/tidyverse/magrittr/issues/29#issuecomment-74313262
globalVariables(".")


#' Extract named regions from mapping file
#'
#' The named region starting with "R_" in the Excel mapping file are read into a
#' named list, having their "R_" prefix removed.
#'
#' @return named list
#' @export
#' @rdname gen_mapping_params
#'
#' @examples
#' mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#'
#' extract_excel_params(mapping_file)
extract_excel_params <- function(mapping_file) {
  if (is.null(mapping_file)) {
    return(NULL)
  }
  named_regions <- tibble::as_tibble(openxlsx::getNamedRegions(mapping_file))

  if (nrow(named_regions) == 0) {
    stop('You need to define at least the named region "R_id_var" in the mapping file.')
  }
  # if there is a named region that's empty, it would throw the warning:
  # ℹ No data found on worksheet.
  suppressWarnings(
    configr <- named_regions %>%
      dplyr::filter(grepl("^R_*", .data$value)) %>%
      dplyr::mutate(
        data = purrr::map(
          .x = .data$value,
          ~ openxlsx::read.xlsx(
            xlsxFile = mapping_file,
            namedRegion = .x,
            colNames = FALSE
          )
        ) %>%
          purrr::map_if(
            purrr::negate(is.null),
            dplyr::pull
          )
      )
  )

  l_configr_excel <- configr$data
  names(l_configr_excel) <- stringr::str_sub(configr$value, 3)

  is_correct_idx <- names(l_configr_excel) %in% names(formals(gen_mapping_params))
  if (any(is_correct_idx == FALSE)) {
    warning(
      "The following parameters are unknown:\n",
      paste(names(l_configr_excel[!is_correct_idx]), collapse = ", "),
      "\nsee ?gen_mapping_params for all used parameters."
    )
  }
  l_configr_excel
}


# Function to replace windows backslashes to slashes and replace relative
# filepaths by absolutes, based on the directory of the mapping file:
adapt_filepath <- function(file_path, mapping_file) {
  file_path <- file_path %>%
    stringr::str_replace_all("\\\\", "/")
  if (is.na(file_path)) {
    return(file_path)
  }
  if (fs::is_absolute_path(file_path)) {
    return(file_path)
  } else {
    mapping_dir <- mapping_file %>% fs::path_dir()
    return(paste0(mapping_dir, "/", file_path))
  }
}


# original from here: https://stackoverflow.com/a/18391779
safe_f <- c(
  getGroupMembers("Math"),
  getGroupMembers("Arith"),
  getGroupMembers("Compare"),
  getGroupMembers("Logic"),
  "{", "(",
  "rowSums", "::", "%in%", "ifelse", "data.frame", "is.na", "c", "list",
  "as.numeric", "as.character", "as.logical", ":", "!"
)

#' Environment where expressions from the Excel mapping file are evaluated
#'
#' See `?Mapping`
#'
#' @export
#' @examples
#' safer_env %>% as.list() %>% names()
safer_env <- new.env(parent = emptyenv())

for (f in safe_f) {
  safer_env[[f]] <- get(f, "package:base")
}
safer_env[["case_when"]] <- dplyr::case_when
