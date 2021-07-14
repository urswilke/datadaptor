library(tidyverse)
library(datenanpassr)
mapping_file <- system.file("extdata", "mapping.xlsx", package = "datenanpassr")
spss_file <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")

r6mod <- R6::R6Class(
  "r6datamod",
  list(
    dat = datenanpassr::fake_survey,
    mod = function(action, data){
      self$dat <- datenanpassr:::apply_one_cmd.nonvec_unsafe(self$dat, action, data)
      invisible(self)
    }
  )
)

rr <- r6mod$new()

df_cmd = mapp_cmd_table(mapping_file)$df_cmd
# apply first command in df_cmd:
rr$mod(df_cmd$action[1], df_cmd$data[[1]])

# apply all commands in df_cmd:
walk2(df_cmd$action, df_cmd$data, rr$mod)
rr$dat








# example with try_catch --------------------------------------------------



apply_one_cmd_safe_to_self <- function(self, action, data) {
  self$cmd_index <- self$cmd_index + 1
  res <- tryCatch({
    err_msg <- NA_character_
    datenanpassr:::apply_one_cmd.nonvec_unsafe(self$dat, action, data)
  },
  error = function(e) {
    err_msg <- geterrmessage()[1]
    message(
      paste(
        "Error in command",
        self$cmd_index,
        ": ",
        err_msg
      )
    )
    self$error_list[self$cmd_index] <- err_msg
    self$dat
  }
  )
  self$dat <- res
  invisible(self)
}
mapping <- mapp_cmd_table(mapping_file)
df_cmd <- mapping$df_cmd
# change conditions in #IF statements to incorrect syntax:
df_cmd$data[[46]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
df_cmd$data[[47]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"
df_cmd$data[[48]]$condition <- "q1 ==(*%$@ 1 |} q3 == 2"

r6mod <- R6::R6Class(
  "r6datamod",
  list(
    dat = datenanpassr::fake_survey,
    cmd_index = 0,
    error_list = vector("character", nrow(df_cmd)),
    mod = function(action, data){
      self <- apply_one_cmd_safe_to_self(self, action, data)
      invisible(self)
    }
  )
)

rr <- r6mod$new()


# # apply first command in df_cmd:
# rr$mod(df_cmd$action[1], df_cmd$data[[1]])

# apply all commands in df_cmd:
walk2(df_cmd$action, df_cmd$data, rr$mod)
rr$dat
rr$cmd_index
rr$error_list
rr$mod(df_cmd$action[1], df_cmd$data[[1]])

# more complete example ---------------------------------------------------
apply_one_cmd_unsafe_to_self <- function(self, action, data){
  self$dat <- datenanpassr:::apply_one_cmd.nonvec_unsafe(self$dat, action, data)
  invisible(self)
}
apply_cmds  <- function(self){
  walk2(self$df_cmd$action, self$df_cmd$data, ~self$mod(self$dat, .x, .y))
  invisible(self)
}#,

datamod <- R6::R6Class(
  "r6datamod",
  list(
    dat = NULL,
    df_cmd = NULL,
    cmd_index = 0,
    error_list = vector("character", nrow(df_cmd)),
    initialize = function(dat, df_cmd){
      self$dat <- dat
      self$df_cmd <- df_cmd
    },
    apply_cmds = function(){
      walk2(self$df_cmd$action, self$df_cmd$data, ~self$one_mod(.x, .y))
      invisible(self)
    },
    one_mod = function(action, data){
      self <- apply_one_cmd_unsafe_to_self(self, action, data)
      invisible(self)
    }
    # mod = apply_one_cmd_unsafe_to_self(self$df_cmd$action, self$df_cmd$data)
  )
)
a <- datamod$new(datenanpassr::fake_survey, df_cmd)
a$apply_cmds()
a$dat
a$df_cmd
a$cmd_index

