#' @export
apply_one_cmd <- function(df, action, data) {
  UseMethod("apply_one_cmd")
}

#' @export
apply_one_cmd.nonvec_unsafe <- function(df, action, data) {
  cmd <- generate_cmd_expression(action, data)
  rlang::eval_tidy(cmd)
}

#' @export
apply_one_cmd.nonvec_safe <- function(df, action, data) {
  cmd_index <- datenanpassr.env$cmd_index + 1
  datenanpassr.env$cmd_index <- cmd_index
  res <- tryCatch({
    err_msg <- NA_character_
    apply_one_cmd.nonvec_unsafe(df, action, data)
  },
  error = function(e) {
    err_msg <- geterrmessage()[1]
    datenanpassr.env$error_list[cmd_index] <- err_msg
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
apply_one_cmd.vec_unsafe <- function(df, action, data){
  group_expr <- generate_group_expr(action, data)
  rlang::eval_tidy(group_expr)
}

#' @export
apply_one_cmd.vec_safe <- function(df, action, data) {
  if (action != "#GROUP") {
    datenanpassr.env$cmd_index <- datenanpassr.env$cmd_index + 1
  }

  res <- tryCatch({
    err_msg <- NA_character_
    apply_one_cmd.vec_unsafe(df, action, data)
  },
  error = function(e) {
    err_msg <- geterrmessage()[1]
    if (action != "#GROUP") {
      datenanpassr.env$error_list[datenanpassr.env$cmd_index] <- err_msg
    }
    message(
      paste(
        "Error in command",
        datenanpassr.env$cmd_index,
        ": ",
        err_msg)
    )
    df1
  }
  )
  res
}
