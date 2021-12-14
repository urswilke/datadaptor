library(tidyverse)
library(datenanpassr)

source("devel/apply_one_command_s3.R")
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")

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



ApplyMods <- R6::R6Class("apply_mods",
  public = list(
    dat = NULL,
    df_cmd = NULL,
    dat_mod = NULL,
    vectorized = FALSE,
    try_catch = FALSE,
    initialize = function(
      dat,
      df_cmd,
      vectorized = FALSE,
      try_catch = FALSE
    ) {
      self$dat = dat
      self$df_cmd = df_cmd
      dat_mod <- structure(
        dat,
        class = c(datenanpassr:::get_vectorized_try_catch_pair_string(vectorized, try_catch), class(dat))
      )
      attr(dat_mod, "cmd_index") <- 1
      attr(dat_mod, "error_list") <- vector("character", nrow(df_cmd))
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

df_cmd = mapp_cmd_table(mapping_file, vectorized = FALSE)$df_cmd
df_cmd$data[[46]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
df_cmd$data[[47]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
df_cmd$data[[48]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"

rr <- ApplyMods$new(datenanpassr::fake_survey, df_cmd, try_catch = TRUE)
# apply first command in df_cmd:
rr$apply_one_cmd_r6(df_cmd$action[1], df_cmd$data[[1]])
rr$mod_all()
rr$dat_mod

rr <- ApplyMods$new(datenanpassr::fake_survey, df_cmd, vectorized = TRUE)
rr$mod_all()
rr$dat_mod %>% attr("error_list")


# # apply all commands in df_cmd:
# walk2(df_cmd$action, df_cmd$data, rr$mod)
# rr$dat
#
#
#
#
#
#
#
#
# # example with try_catch --------------------------------------------------
#
#
#
# apply_one_cmd_safe_to_self <- function(self, action, data) {
#   self$cmd_index <- self$cmd_index + 1
#   res <- tryCatch({
#     err_msg <- NA_character_
#     datenanpassr:::apply_one_cmd.nonvec_unsafe(self$dat_mod, action, data)
#   },
#   error = function(e) {
#     err_msg <- geterrmessage()[1]
#     message(
#       paste(
#         "Error in command",
#         self$cmd_index,
#         ": ",
#         err_msg
#       )
#     )
#     self$error_list[self$cmd_index] <- err_msg
#     self$dat_mod
#   }
#   )
#   self$dat_mod <- res
#   invisible(self)
# }
# mapping <- mapp_cmd_table(mapping_file)
# df_cmd <- mapping$df_cmd
# # change conditions in #IF statements to incorrect syntax:
# df_cmd$data[[46]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
# df_cmd$data[[47]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
# df_cmd$data[[48]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
#
# r6mod <- R6::R6Class(
#   "r6datamod",
#   list(
#     dat_mod = datenanpassr::fake_survey,
#     cmd_index = 0,
#     error_list = vector("character", nrow(df_cmd)),
#     mod = function(action, data){
#       self <- apply_one_cmd_safe_to_self(self, action, data)
#       invisible(self)
#     }
#   )
# )
#
# rr <- r6mod$new()
#
#
# # # apply first command in df_cmd:
# # rr$mod(df_cmd$action[1], df_cmd$data[[1]])
#
# # apply all commands in df_cmd:
# walk2(df_cmd$action, df_cmd$data, rr$mod)
# rr$dat_mod
# rr$cmd_index
# rr$error_list
# rr$mod(df_cmd$action[1], df_cmd$data[[1]])
#
# # more complete example ---------------------------------------------------
# apply_one_cmd_unsafe_to_self <- function(self, action, data){
#   self$dat_mod <- datenanpassr:::apply_one_cmd.nonvec_unsafe(self$dat_mod, action, data)
#   invisible(self)
# }
# # apply_cmds  <- function(self){
# #   walk2(self$df_cmd$action, self$df_cmd$data, ~self$mod(self$dat, .x, .y))
# #   invisible(self)
# # }#,
#
# try_catch_expr <- function(mutate_expr) {
#
#   rlang::expr(
#     tryCatch({
#       print(self$cmd)
#       self$cmd_index <- self$cmd_index + 1
#
#       # err_msg <- NA_character_
#       !!mutate_expr
#     },
#     error = function(e) {
#       err_msg <- geterrmessage()[1]
#       self$error_list[self$cmd_index] <- err_msg
#
#       message(cat(
#         paste(
#           "Error in command",
#           self$cmd_index,
#           ": ",
#           err_msg)
#       ))
#       NULL
#     })
#   )
# }
#
# r6_group_vectorizable_cmds <- function() {
#   datenanpassr:::group_vectorizable_cmds()
# }
#
# datamod <- R6::R6Class(
#   "r6datamod",
#   list(
#     dat = NULL,
#     df_cmd = NULL,
#     cmd_index = 0,
#     error_list = vector("character", nrow(df_cmd)),
#     dat_mod = NULL,
#     df_cmd_group = NULL,
#     mapping = NULL,
#     initialize = function(dat, df_cmd, vectorized = FALSE, try_catch = FALSE){
#       stopifnot(is.data.frame(df_cmd))
#       stopifnot(is.data.frame(dat))
#       if (try_catch) {
#         self$df_cmd_group[!self$df_cmd_group$action %in% c("#RECNA", "#RENAME", "#DROP", "#RFUN")] <-
#           self$df_cmd_group[!self$df_cmd_group$action %in% c("#RECNA", "#RENAME", "#DROP", "#RFUN")] %>% purrr::map(try_catch_expr)
#       }
#       self$mapping <- datenanpassr::mapp_cmd_table(mapping_file, vectorized = vectorized, try_catch = try_catch)
#       if (vectorized) {
#         self$df_cmd_group <- r6_group_vectorizable_cmds()
#       }
#       else {
#         self$df_cmd_group <- df_cmd
#       }
#       self$dat <- dat
#       self$dat_mod <- dat
#       self$df_cmd <- df_cmd
#     },
#     apply_cmds = function(){
#       walk2(self$df_cmd_group$action, self$df_cmd_group$data, ~self$one_mod(.x, .y))
#       self$df_cmd <- self$df_cmd %>% mutate(error = self$error_list)
#       invisible(self)
#     },
#     one_mod = function(action, data){
#       self <- apply_one_cmd_safe_to_self(self, action, data)
#       invisible(self)
#     }
#   )
# )
# a <- datamod$new(datenanpassr::fake_survey, df_cmd, TRUE, TRUE)
# a$apply_cmds()
# a$dat
# a$dat_mod
# a$df_cmd_group
# a$cmd_index
# a$df_cmd_group %>% View
#
