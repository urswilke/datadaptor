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
