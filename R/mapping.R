

#' @export
Mapping <- R6::R6Class(
  "apply_mods",
  public = list(
     dat = NULL,
     mapping_file = NULL,
     df_cmd = NULL,
     dat_mod = NULL,
     params = NULL,
     initialize = function(
       dat = NULL,
       mapping_file
     ) {
       initialize_dat(self, dat)

       self$mapping_file = mapping_file
       set_default_parameters(self)
     },
     calc_command_table = function() {
       load_configr_params(self)
       self$df_cmd = gen_command_table(self)
       dat_mod <- structure(
         self$dat,
         class = c(get_vectorized_try_catch_pair_string(self$params$vectorized, self$params$try_catch), class(self$dat))
       )
       attr(dat_mod, "cmd_index") <- 1
       attr(dat_mod, "error_list") <- vector("character", nrow(self$df_cmd))
       self$dat_mod = dat_mod
     },
     mod_all = function() {
       purrr::walk2(self$df_cmd$action, self$df_cmd$data, self$apply_one_cmd_r6)
       invisible(self)
     },
     apply_one_cmd_r6 = function(action, data) {
       self$dat_mod <- apply_one_cmd_nonvec_safe_r6(self$dat_mod, action, data, self) %>%
         rlang::eval_tidy()
       invisible(self)
     }
  )
)

initialize_dat <- function(self, dat) {
  if (is.null(dat)) {
    self$dat <- NULL
    return(invisible(self))
  }
  if (is.character(dat)) {
    dat <- haven::read_sav(dat)
  }
  self$dat <- dat
  self$dat_mod <- self$dat
  invisible(self)
}


generate_cmd_expression_r6 <- function(action, data) {
  # Hack to prevent R CMD CHECK note
  # "no visible binding for global variable ‘df’":
  df <- NULL

  switch (
    action,
    "#GROUP"  = rlang::expr(dplyr::mutate(self$dat_mod,  !!!data)),
    "#RECNA"  = rlang::expr(set_na_to_filter_except(self$dat_mod,  !!!data)),
    "#MERGE"  = rlang::expr(cmd_merge_df(self$dat_mod,  !!!data)),
    "#RFUN"   = rlang::expr(cmd_rfun(self$dat_mod,  !!!data)),
    "#R"      = rlang::expr(cmd_r_df(self$dat_mod,  !!!data)),
    "#IF"     = rlang::expr(cmd_if_df(self$dat_mod,  !!!data)),
    "#COMP"   = rlang::expr(cmd_comp_df(self$dat_mod,  !!!data)),
    # TODO: find cleaner way to deal with this!
    "#COMPR"  = rlang::expr(cmd_compr_df(self$dat_mod,  !!!data)),
    "#REC"    = rlang::expr(cmd_rec_df(self$dat_mod,  !!!data)),
    "#NEWVALL"= rlang::expr(cmd_add_labs_df(self$dat_mod,  !!!data)),
    "#AUTOREC"= rlang::expr(cmd_autorec_df(self$dat_mod,  !!!data)),
    "#STR2NUM"= rlang::expr(cmd_str_to_num_df(self$dat_mod,  !!!data)),
    "#SUMVAR" = rlang::expr(cmd_sumvar_df(self$dat_mod,  !!!data)),
    "#RENAME" = rlang::expr(cmd_rename(self$dat_mod,  !!!data)),
    "#DROP"   = rlang::expr(cmd_drop(self$dat_mod,  !!!data)),
    "#NEWLAB" = rlang::expr(cmd_set_lab_df(self$dat_mod,  !!!data)),
    "#VARL"   = rlang::expr(cmd_set_lab_df(self$dat_mod,  !!!data)),
    "#VALL"   = rlang::expr(cmd_set_labs_df(self$dat_mod,  !!!data)),
    "#AVALL"  = rlang::expr(cmd_add_labs_df(self$dat_mod,  !!!data)),
    "#DIC"    = rlang::expr(cmd_dic_df(self$dat_mod,  !!!data)),
    "#KG"     = rlang::expr(cmd_kg_df(self$dat_mod,  !!!data)),
    "#verbatim"  = rlang::expr(cmd_verbatim_df(self$dat_mod,  !!!data)),
    stop("Invalid action command")
  )
}


apply_one_cmd_nonvec_safe_r6 <- function(df, action, data, self) {
  cmd_index <- attr(df, "cmd_index") + 1
  attr(df, "cmd_index") <- cmd_index
  res <- tryCatch({
    err_msg <- NA_character_
    apply_one_cmd(df, action, data, self)
  },
  error = function(e) {
    err_msg <- geterrmessage()[1]
    attr(df, "error_list")[cmd_index] <- err_msg
    message(
      paste(
        "Error in command",
        cmd_index,
        ": ",
        err_msg)
    )
    df
  }
  )
  res
}


set_default_parameters <- function(self) {
  self$params <- list(
    na_to_filter = TRUE,
    vectorized = FALSE,
    df_cmd = tibble::tibble(),
    data = tibble::tibble(),
    try_catch = FALSE,
    add_r_command_colum = FALSE,
    rec_fun = purrr::reduce2,
    check_id_is_unique = TRUE,
    mapping_file_attrs = list()
  )
  invisible(self)
}

load_configr_params <- function(self) {
  l_configr <- get_configr_args_list(self$mapping_file)
  id_var <- l_configr$id_var

  self$params$mapping_file_attrs <- l_configr
  self$params$id_var <- id_var
  invisible(self)
}
