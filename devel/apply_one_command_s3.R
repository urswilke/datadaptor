#' @export
apply_one_cmd <- function(df, action, data, self) {
  UseMethod("apply_one_cmd")
}

#' @export
apply_one_cmd.nonvec_unsafe <- function(df, action, data, self) {
  cmd <- generate_cmd_expression_r6(action, data)
  rlang::eval_tidy(cmd)
}

#' @export
apply_one_cmd.nonvec_safe <- function(df, action, data, self) {
  cmd_index <- attr(force(df), "cmd_index") + 1
  attr(df, "cmd_index") <- cmd_index
  # cmd_index <- datenanpassr.env$cmd_index + 1
  # datenanpassr.env$cmd_index <- cmd_index
  res <- tryCatch({
    err_msg <- NA_character_
    apply_one_cmd.nonvec_unsafe(df, action, data, self)
  },
  error = function(e) {
    err_msg <- geterrmessage()[1]
    attr(df, "error_list")[cmd_index] <- err_msg
    # datenanpassr.env$error_list[cmd_index] <- err_msg
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


#' @export
apply_one_cmd.vec_unsafe <- function(df, action, data, self){
  group_expr <- generate_cmd_expression_r6(action, data)
  rlang::eval_tidy(group_expr)
}

#' @export
apply_one_cmd.vec_safe <- function(df, action, data, self) {
  if (action != "#GROUP") {
    cmd_index <- attr(df, "cmd_index") + 1
    attr(df, "cmd_index") <- cmd_index
    # datenanpassr.env$cmd_index <- datenanpassr.env$cmd_index + 1
  }

  res <- tryCatch({
    err_msg <- NA_character_
    apply_one_cmd.vec_unsafe(df, action, data, self)
  },
  error = function(e) {
    err_msg <- geterrmessage()[1]
    if (action != "#GROUP") {
      attr(df, "error_list")[cmd_index] <- err_msg
      # datenanpassr.env$error_list[datenanpassr.env$cmd_index] <- err_msg
    }
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
