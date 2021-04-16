generate_cmd_expression <- function(action, data) {
  # Hack to prevent R CMD CHECK note
  # "no visible binding for global variable ‘df’":
  df <- NULL

  switch (
    action,
    "#GROUP"  = rlang::expr(dplyr::mutate(df, !!!data)),
    "#RECNA"  = rlang::expr(set_na_to_filter_except(df, !!!data)),
    "#MERGE"  = rlang::expr(cmd_merge_df(df, !!!data)),
    "#RFUN"   = rlang::expr(cmd_rfun(df, !!!data)),
    "#R"      = rlang::expr(cmd_r_df(df, !!!data)),
    "#IF"     = rlang::expr(cmd_if_df(df, !!!data)),
    "#COMP"   = rlang::expr(cmd_comp_df(df, !!!data)),
    # TODO: find cleaner way to deal with this!
    "#COMPR"  = rlang::expr(cmd_compr_df(df, !!!data)),
    "#REC"    = rlang::expr(cmd_rec_df(df, !!!data)),
    "#NEWVALL"= rlang::expr(cmd_add_labs_df(df, !!!data)),
    "#AUTOREC"= rlang::expr(cmd_autorec_df(df, !!!data)),
    "#STR2NUM"= rlang::expr(cmd_str_to_num_df(df, !!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar_df(df, !!!data)),
    "#RENAME" = rlang::expr(cmd_rename(df, !!!data)),
    "#DROP"   = rlang::expr(cmd_drop(df, !!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab_df(df, !!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab_df(df, !!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs_df(df, !!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs_df(df, !!!data)),
    "#DIC"    = rlang::expr(cmd_dic_df(df, !!!data)),
    "#KG"     = rlang::expr(cmd_kg_df(df, !!!data)),
    "#verbatim"  = rlang::expr(cmd_verbatim_df(df, !!!data)),
    stop("Invalid action command")
  )
}

generate_cmd_expression_vec <- function(action, data) {
  switch (
    action,
    "#RECNA"  = rlang::expr(set_na_to_filter_except(!!!data)),
    "#MERGE"  = rlang::expr(cmd_merge(!!!data)),
    "#RFUN"   = rlang::expr(cmd_rfun(!!!data)),
    "#R"      = rlang::expr(cmd_r(!!!data)),
    "#IF"     = rlang::expr(cmd_if(!!!data)),
    "#COMP"   = rlang::expr(cmd_comp(!!!data)),
    # TODO: find cleaner way to deal with this!
    "#COMPR"  = rlang::expr(cmd_compr(!!!data)),
    "#REC"    = rlang::expr(cmd_rec(!!!data)),
    "#NEWVALL"= rlang::expr(cmd_add_labs(!!!data)),
    "#AUTOREC"= rlang::expr(cmd_autorec(!!!data)),
    "#STR2NUM"= rlang::expr(cmd_str_to_num(!!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar(!!!data)),
    "#RENAME" = rlang::expr(cmd_rename(!!!data)),
    "#DROP"   = rlang::expr(cmd_drop(!!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab(!!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab(!!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs(!!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs(!!!data)),
    "#DIC"    = rlang::expr(cmd_dic(!!!data)),
    "#KG"     = rlang::expr(cmd_kg(!!!data)),
    "#verbatim"  = rlang::expr(cmd_verbatim(!!!data)),
    stop("Invalid action command")
  )
}

# see here: https://stackoverflow.com/a/12605694
datenanpassr.env <- new.env(parent = emptyenv())


group_vectorizable_cmds <- function(df_cmd, try_catch = FALSE) {
  df_cmd <- df_cmd %>% dplyr::mutate(cmd = get_mutate_exprs(.data$action, .data$data, .data$new_var, try_catch))
  df_cmd_groups <- split_df_cmd(df_cmd)
  df_cmd_groups
}

get_mutate_exprs <- function(action, data, new_var, try_catch = FALSE) {
  cmds <- purrr::map2(
    action,
    data,
    generate_cmd_expression_vec
  )
  if (try_catch ==  TRUE) {
    cmds[!action %in% c("#RECNA", "#RENAME", "#DROP", "#RFUN")] <-
      cmds[!action %in% c("#RECNA", "#RENAME", "#DROP", "#RFUN")] %>% purrr::map(try_catch_expr)
  }
  cmds <- cmds %>%
    purrr::set_names(~new_var)
  names(cmds)[action %in% c("#MERGE", "#KG", "#R")] <- ""
  cmds
}

try_catch_expr <- function(mutate_expr) {

  rlang::expr(
    tryCatch({
      datenanpassr.env$cmd_index <- datenanpassr.env$cmd_index + 1

      # err_msg <- NA_character_
      !!mutate_expr
    },
    error = function(e) {
      err_msg <- geterrmessage()[1]
      datenanpassr.env$error_list[datenanpassr.env$cmd_index] <- err_msg

      message(cat(
        paste(
          "Error in command",
          datenanpassr.env$cmd_index,
          ": ",
          err_msg)
      ))
      NULL
    })
  )
}




split_df_cmd <- function(df_cmd) {
  single_groups <- c("#RECNA", "#RENAME", "#DROP", "#RFUN")
  prepare_groups <- function(df_cmd_group) {
    if (!df_cmd_group$action[1] %in% single_groups) {
      df_cmd_group <- tibble::tibble(
        action = "#GROUP",
        new_var = NA_character_,
        data = list(df_cmd_group$cmd)
      )
    }
    df_cmd_group %>%
      dplyr::select(.data$action, .data$new_var, .data$data)
  }

  df_cmd %>%
    dplyr::mutate(
      i_group = .data$action %in% single_groups,
      i_group = .data$i_group != dplyr::lag(.data$i_group, default = TRUE),
      i_group = cumsum(.data$i_group)
    ) %>%
    dplyr::group_split(.data$i_group, .keep = FALSE) %>%
    purrr::map_dfr(prepare_groups)
}





