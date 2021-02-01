#' Create a table of input argument dataframe variables of the commands in the mapping file
#'
#' @param df dataframe
#' @param df_mod dataframe returned by `mapp_xl_to_data()`
#'
#' @return
#' @export
#'
#' @examples
#' spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_filepath)
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' df_mod <- datenanpassr::mapp_xl_to_data(df, mapping_filepath)
#' mapp_variable_modification_table(df, df_mod)
mapp_variable_modification_table <- function(df, df_mod) {
  if (typeof(df) == "character") {
    df <- haven::read_sav(df)
  }

  df_cmd <- mapp_cmd_table(mapping_filepath, add_r_command_colum = TRUE)
  # translate_to_r_script(df_cmd, spss_filepath)
  df_vars_long <- make_var_mod_table_long(df, df_mod, df_cmd)
  df_vars_long %>%
    dplyr::mutate(temp = "x") %>%
    tidyr::spread(value, temp)
}

make_var_mod_table_long <- function(df, df_mod, df_cmd) {
  all_vars <- dplyr::union(names(df), names(df_mod))
  sourcetools::tokenize_string(df_cmd$`R command` %>% paste(collapse = "\n")) %>%
    tibble::as_tibble() %>%
    dplyr::filter(type == "string") %>%
    dplyr::select(-column, -type) %>%
    dplyr::mutate(value = stringr::str_remove_all(value, '\\"')) %>%
    dplyr::filter(value %in% all_vars) %>%
    dplyr::mutate(value = factor(value, levels = all_vars))
}

#' Plot a table of the dataframe variables contained in the input argument of the commands in the mapping file
#'
#' @param df dataframe
#' @param df_mod dataframe returned by `mapp_xl_to_data()`
#' @param df_cmd dataframe returned by `mapp_cmd_table()`
#'
#' @export
#'
#' @examples
#' spss_filepath <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(spss_filepath)
#' mapping_filepath <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
#' df_mod <- datenanpassr::mapp_xl_to_data(df, mapping_filepath)
#' df_cmd <- mapp_cmd_table(mapping_filepath, add_r_command_colum = TRUE)
#' p <- plot_cmd_table(df, df_mod, df_cmd)
#' p
#' # Interactive version:
#' \dontrun{
#' plotly::ggplotly(p)
#' }
plot_cmd_table <- function(df, df_mod, df_cmd) {
  all_vars <- dplyr::union(names(df), names(df_mod))
  df_plot <- mapp_variable_modification_table(df, df_mod) %>%
    dplyr::full_join(
      df_cmd %>%
        dplyr::ungroup() %>%
        dplyr::transmute(
          row = dplyr::row_number(),
          action,
          `R command`),
      .) %>%
    tidyr::gather(var, temp, -row, -action, -`R command`) %>%
    tidyr::drop_na() %>%
    dplyr::select(-temp) %>%
    dplyr::mutate(var = factor(var, levels = all_vars))
  p <- df_plot %>%
    ggplot2::ggplot(ggplot2::aes(var, -row, fill = action, text = `R command`)) +
    ggplot2::geom_tile() +
    ggplot2::theme_minimal()
  p
}

# this function parses an expression string and extracts all symbols found in it:
extract_expression_string_symbols <- function(expr_string) {
  sourcetools::tokenize_string(expr_string) %>%
    dplyr::filter(type == "symbol") %>%
    dplyr::pull(value)
}

# this function applies extract_expression_string_symbols() to the sublist
# elements in df_cmd$data with the sublist element name `element_name` (if
# present):
extract_nested_data_element <- function(df_cmd, element_name) {
  df_cmd$data %>%
    purrr::map(purrr::pluck, element_name) %>%
    purrr::map_if(
      is_not_null,
      extract_expression_string_symbols
    )
}

# This function extracts the sublist elements in the first character vector:
# (related: https://github.com/tidyverse/purrr/issues/562#issuecomment-439975131)
find_possible_manipulation_inputs_from_expr <- function(df_cmd) {
  # TODO also parse script code!!!
  c("condition", "new_val", "r_code") %>%
    purrr::set_names() %>%
    purrr::map(~extract_nested_data_element(df_cmd, .x)) %>%
    dplyr::as_tibble() %>%
    dplyr::transmute(purrr::map2(condition, new_val, c)) %>%
    dplyr::pull()
}
make_args_df <- function(df_cmd) {
  df_cmd %>%
    dplyr::select(data) %>%
    tidyr::unnest_wider(data)
}
find_possible_manipulation_inputs_from_args <- function(df_cmd) {
  possible_elements <- c("orig_var", "orig_vars", "id", "split_var", "by_var", "var_ziel")
  df_args <- make_args_df(df_cmd)

  df_args %>%
    dplyr::select(!!!possible_elements) %>%
    purrr::transpose() %>%
    purrr::map(~unlist(.x) %>% stats::na.omit() %>% c())

}

# make_union_setdiff <- function(l, x, y){
#   c(l, x) %>% unique() %>% setdiff(y)
# }

get_all_new_vars <- function(df_args) {
  df_args %>%
    dplyr::select(!!!c("new_var", "new_names", "var_ziel", "variable_names")) %>%
    dplyr::rowwise() %>% dplyr::group_split() %>%  purrr::map(~unlist(.x) %>% stats::na.omit() %>% as.vector)
}
# This function tries to determine all variables in the current state of the dataframe:
# get_vars_so_far <- function(df_cmd) {
#   accumulate(
#   # accumulate2(
#     find_possible_manipulation_inputs_from_args(df_cmd),
#     # get_all_new_vars(df_args),
#     # make_union_setdiff,
#     ~c(.x),
#     .init = names(df)
#   ) %>%
#     # the final state isn't input to anything anymore:
#     .[-length(.)] %>%
#     map(unique)
# }

get_vars_so_far <- function(df_cmd, df) {
  df_args <- make_args_df(df_cmd)
  df_add_rem <- df_args %>%
    dplyr::rowwise() %>%
    dplyr::summarise(
      new = list(c(new_var, new_names, var_ziel, variable_names) %>% stats::na.omit() %>% as.vector()),
      removed = list(orig_vars)
    )
  vars_so_far <- purrr::accumulate(
    df_add_rem$new,
    # df_add_rem$removed,
    # make_union_setdiff,
    c,
    .init = names(df)
    ) %>%
    purrr::map(unique) %>%
    .[-length(.)]
}


get_input_arguments_expr <- function(df_cmd, df) {
  possible_inputs <- find_possible_manipulation_inputs_from_expr(df_cmd)
  vars_so_far <- get_vars_so_far(df_cmd, df)
  purrr::map2(
    possible_inputs,
    vars_so_far,
    dplyr::intersect
  )
}

find_input_args <- function(df_cmd, df) {
  args_expr <- get_input_arguments_expr(df_cmd, df)
  args_args <- find_possible_manipulation_inputs_from_args(df_cmd)
  purrr::map2(
    args_expr,
    args_args,
    c
  )
}
