generate_cmd_expression_r6 <- function(action, data) {
  # Hack to prevent R CMD CHECK note
  # "no visible binding for global variable ‘df’":
  df <- NULL

  switch (
    action,
    "#GROUP"  = rlang::expr(dplyr::mutate(self$dat_mod,  !!!data)),
    "#RECNA"  = rlang::expr(datenanpassr:::set_na_to_filter_except(self$dat_mod,  !!!data)),
    "#MERGE"  = rlang::expr(datenanpassr:::cmd_merge_df(self$dat_mod,  !!!data)),
    "#RFUN"   = rlang::expr(datenanpassr:::cmd_rfun(self$dat_mod,  !!!data)),
    "#R"      = rlang::expr(datenanpassr:::cmd_r_df(self$dat_mod,  !!!data)),
    "#IF"     = rlang::expr(datenanpassr:::cmd_if_df(self$dat_mod,  !!!data)),
    "#COMP"   = rlang::expr(datenanpassr:::cmd_comp_df(self$dat_mod,  !!!data)),
    # TODO: find cleaner way to deal with this!
    "#COMPR"  = rlang::expr(datenanpassr:::cmd_compr_df(self$dat_mod,  !!!data)),
    "#REC"    = rlang::expr(datenanpassr:::cmd_rec_df(self$dat_mod,  !!!data)),
    "#NEWVALL"= rlang::expr(datenanpassr:::cmd_add_labs_df(self$dat_mod,  !!!data)),
    "#AUTOREC"= rlang::expr(datenanpassr:::cmd_autorec_df(self$dat_mod,  !!!data)),
    "#STR2NUM"= rlang::expr(datenanpassr:::cmd_str_to_num_df(self$dat_mod,  !!!data)),
    "#SUMVAR" = rlang::expr(datenanpassr:::cmd_sumvar_df(self$dat_mod,  !!!data)),
    "#RENAME" = rlang::expr(datenanpassr:::cmd_rename(self$dat_mod,  !!!data)),
    "#DROP"   = rlang::expr(datenanpassr:::cmd_drop(self$dat_mod,  !!!data)),
    "#NEWLAB" = rlang::expr(datenanpassr:::cmd_set_lab_df(self$dat_mod,  !!!data)),
    "#VARL"   = rlang::expr(datenanpassr:::cmd_set_lab_df(self$dat_mod,  !!!data)),
    "#VALL"   = rlang::expr(datenanpassr:::cmd_set_labs_df(self$dat_mod,  !!!data)),
    "#AVALL"  = rlang::expr(datenanpassr:::cmd_add_labs_df(self$dat_mod,  !!!data)),
    "#DIC"    = rlang::expr(datenanpassr:::cmd_dic_df(self$dat_mod,  !!!data)),
    "#KG"     = rlang::expr(datenanpassr:::cmd_kg_df(self$dat_mod,  !!!data)),
    "#verbatim"  = rlang::expr(datenanpassr:::cmd_verbatim_df(self$dat_mod,  !!!data)),
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



Mapping <- R6::R6Class("apply_mods",
                         public = list(
                           dat = NULL,
                           mapping_file = NA_character_,
                           df_cmd = NULL,
                           dat_mod = NULL,
                           vectorized = FALSE,
                           try_catch = FALSE,
                           initialize = function(
                             dat,
                             mapping_file,
                             vectorized = FALSE,
                             try_catch = FALSE
                           ) {
                             self$dat = dat
                             self$mapping_file = mapping_file
                             self$df_cmd = gen_command_table(mapping_file)
                             dat_mod <- structure(
                               dat,
                               class = c(datenanpassr:::get_vectorized_try_catch_pair_string(vectorized, try_catch), class(dat))
                             )
                             attr(dat_mod, "cmd_index") <- 1
                             attr(dat_mod, "error_list") <- vector("character", nrow(self$df_cmd))
                             self$dat_mod = dat_mod
                           },
                           mod_one = function(action, data){
                             self$dat_mod <- apply_one_cmd_nonvec_safe_r6(self$dat_mod, action, data)
                             invisible(self)
                           },
                           mod_all = function() {
                             walk2(self$df_cmd$action, self$df_cmd$data, self$apply_one_cmd_r6)
                             invisible(self)
                           },
                           apply_one_cmd_r6 = function(action, data) {
                             self$dat_mod <- apply_one_cmd_nonvec_safe_r6(self$dat_mod, action, data, self) %>%
                               rlang::eval_tidy()
                             invisible(self)
                           }

                         )
)
