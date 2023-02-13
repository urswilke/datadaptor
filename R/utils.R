#' Multiply repetitive parts of command blocks using curly braces
#'
#' This function turns the first line of command blocks of the "Free" sheets into
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
#' df_curly
#' curlychop(df_curly)
curlychop <- function(df_free_raw) {
  df_prep <- df_free_raw |>
    mutate(raw_index = cumsum(is_true_vec(str_detect(.data$X1, "^#")))) |>
    group_by(.data$raw_index) |>
    mutate(
      row = paste(row, collapse = ", "),
      is_curly_group = if_any(
        .cols = everything(),
        .fns = ~ str_detect(.x[1], "\\{")
      ) |>
        is_true_vec()
    ) |>
    add_count(.data$raw_index) |>
    group_by(.data$raw_index)

  df_curly_headers <- df_prep |>
    filter(if_any(c("X2", "X3"), ~ str_detect(.x, "\\{.*\\}")))
  if (nrow(df_curly_headers) == 0) {
    return(df_prep |>
      select(-all_of(c("is_curly_group", "n"))))
  }
  df_headers_curliplied <- df_curly_headers |>
    curlychop_headers()

  l_commands <- df_prep |>
    group_split()
  command_has_curlies_lgl <- df_prep |>
    summarise(lgl = .data$is_curly_group[1], .groups = "drop") |>
    pull(.data$lgl)

  l_commands[command_has_curlies_lgl] <- map2(
    df_headers_curliplied |> group_by(.data$raw_index) |> group_split(),
    l_commands[command_has_curlies_lgl],
    add_further_rows_to_multiline_curlies
  )

  bind_rows(l_commands) |>
    select(-all_of(c("is_curly_group", "n")))
}

curlychop_headers <- function(df) {
  df |>
    mutate(across(c("X2", "X3"), ~list(split_curly_parts(.x)))) |>
    unnest(c("X2", "X3"))
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
  split_string <- str_extract_all(string, split_pattern)[[1]]

  is_curly_part <- str_detect(split_string, open_or_closer)
  inside_curly_parts <- split_string[is_curly_part] |>
    str_remove_all(open_or_closer) |>
    str_squish() |>
    str_split(" ")
  curly_parts_lengthes_over1 <- inside_curly_parts |>
    lengths() |>
    unique() |>
    setdiff(1)
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
      df_header_lines |>
        mutate(row = paste0(row, "_", row_number()))
    )
  }
  df_header_lines |>
    rowwise() |>
    group_split() |>
    imap_dfr(
      ~ .x |>
        bind_rows(df_block_original[-1, ]) |>
        mutate(row = paste0(row, "_", .y))
    )
}

merge_vallabs <- function(old_vallab_vec, added_vallab_vec) {
  all_vals <- c(old_vallab_vec, added_vallab_vec)
  all_labels <- c(names(old_vallab_vec), names(added_vallab_vec))
  replaced_vals <- duplicated(all_vals, fromLast = TRUE)
  set_names(
    all_vals[!replaced_vals],
    all_labels[!replaced_vals]
  ) |>
    sort()
}

# From here: https://github.com/r-lib/vctrs/issues/23
#' Vectorized \code{isTRUE()}
#'
#'
#' @param x Logical vector
#'
#' @return Logical vector that's TRUE if \code{x = TRUE} and \code{FALSE} if \code{x = FALSE or NA}.
#' @keywords internal
#' @export
#'
#' @examples
#' is_true_vec(c(NA, TRUE, FALSE))
is_true_vec <- function(x) Vectorize(isTRUE)(x)

# see https://github.com/tidyverse/magrittr/issues/29#issuecomment-74313262
globalVariables(".")


extract_named_region_params <- function(mapping_file) {
  UseMethod("extract_named_region_params", mapping_file)
}
extract_named_region_params.list <- function(variables) {
  NULL
}

extract_named_region_params.excel <- function(mapping_file) {
  wb <- loadWorkbook(mapping_file) |> suppressWarnings()
  named_regions_raw <- getNamedRegions(wb)
  if (is.null(named_regions_raw)) {
    return(NULL)
  }
  named_regions <- as_tibble(named_regions_raw)


  params_df <- named_regions |>
    filter(grepl("^R_*", .data$value)) |>
    mutate(
      data = map(
        .x = .data$value,
        ~ read.xlsx(
          xlsxFile = wb,
          namedRegion = .x,
          colNames = FALSE
        )
      ) |>
        map_if(
          negate(is.null),
          pull
        )
    )


  named_params_list <- params_df$data
  names(named_params_list) <- str_sub(params_df$value, 3)

  is_correct_idx <- names(named_params_list) %in% names(formals(gen_mapping_params))
  if (any(is_correct_idx == FALSE)) {
    warning(
      "The following parameters are unknown:\n",
      paste(names(named_params_list[!is_correct_idx]), collapse = ", "),
      "\nsee ?gen_mapping_params for all used parameters."
    )
  }
  named_params_list
}

extract_named_region_params.google <- function(mapping_file) {
  gs <- gs4_get(mapping_file |> as.character())
  named_regions <- gs$named_ranges
  if (is.null(named_regions)) {
    return(NULL)
  }

  params_df <- named_regions |>
    filter(grepl("^R_*", .data$name)) |>
    mutate(
      data = map(
        .data$A1_range,
        ~ read_sheet(
          gs,
          range = .x,
          col_names = "data"
        ) |>
          suppressMessages()
      )
    ) |>
    filter(!map_lgl(.data$data, is_empty)) |>
    unnest(.data$data)


  named_params_list <- params_df$data
  names(named_params_list) <- str_sub(params_df$name, 3)

  is_correct_idx <- names(named_params_list) %in% names(formals(gen_mapping_params))
  if (any(is_correct_idx == FALSE)) {
    warning(
      "The following parameters are unknown:\n",
      paste(names(named_params_list[!is_correct_idx]), collapse = ", "),
      "\nsee ?gen_mapping_params for all used parameters."
    )
  }
  named_params_list
}


# Function to replace windows backslashes to slashes and replace relative
# filepaths by absolutes, based on the directory of the mapping file:
adapt_filepath <- function(file_path, mapping_file) {
  file_path <- file_path |>
    str_replace_all("\\\\", "/")
  if (is.na(file_path)) {
    return(file_path)
  }
  if (is_absolute_path(file_path)) {
    return(file_path)
  } else {
    mapping_dir <- mapping_file |> path_dir()
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
#' Execution environment
#'
#' This is the default environment where expressions from the Excel mapping file are evaluated.
#' See argument `expr_eval_env` of `?gen_mapping_params()`. See examples below
#' for the list of included functions. If you need more, you can also use
#' `baseenv()`.
#'
#' @export
#' @examples
#' safer_env |> as.list() |> names()
safer_env <- new.env(parent = emptyenv())

for (f in safe_f) {
  safer_env[[f]] <- get(f, "package:base")
}
safer_env[["case_when"]] <- case_when

#' Remove attributes from a vector
#'
#' @param x vector
#'
#' @return x with attributes removed
#' @noRd
#'
#' @examples
#' x <- haven::labelled(1:3, label = "variable_label")
#' strip_attributes(x)
strip_attributes <- function(x) {
  attributes(x) <- NULL
  x
}
