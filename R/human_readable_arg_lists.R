parse_cmd_block_args <- function(action, data, vectorized) {
  switch (
    action,
    "#RFUN"    = parse_cmd_block_args_rfun(data),
    "#R"       = parse_cmd_block_args_r(data),
    "#MERGE"   = parse_cmd_block_args_merge(data, vectorized),
    "#IF"      = parse_cmd_block_args_if(data, vectorized),
    "#COMP"    = parse_cmd_block_args_comp(data, vectorized),
    "#COMPR"   = parse_cmd_block_args_comp(data, vectorized),
    "#REC"     = parse_cmd_block_args_rec(data, vectorized),
    "#NEWVALL" = parse_cmd_block_args_newvall(data, vectorized),
    "#AUTOREC" = parse_cmd_block_args_autorec(data, vectorized),
    "#STR2NUM" = parse_cmd_block_args_str_to_num(data, vectorized),
    "#SUMVAR"  = parse_cmd_block_args_sumvar(data, vectorized),
    "#RENAME"  = parse_cmd_block_args_rename(data),
    "#DROP"    = parse_cmd_block_args_drop(data),
    "#NEWLAB"  = parse_cmd_block_args_newlab(data, vectorized),
    "#VARL"    = parse_cmd_block_args_varl(data, vectorized),
    "#VALL"    = parse_cmd_block_args_vall(data, vectorized),
    "#AVALL"   = parse_cmd_block_args_avall(data, vectorized),
    "#DIC"     = parse_cmd_block_args_dic(data, vectorized),
    "#KG"      = parse_cmd_block_args_kg(data, vectorized),
    "#verbatim"= parse_cmd_block_args_verbatim(data, vectorized),
    stop("Invalid action command")
  )
}

parse_cmd_block_args_rename <- function(data) {
  d <- data

  res <- list(
    orig_vars = d$vars[[1]],
    new_names = d$new_names[[1]]
  )
  list(res)
}

parse_cmd_block_args_drop <- function(data) {
  d <- data

  res <- list(
    orig_vars = d$vars[[1]]
  )
  list(res)
}

parse_cmd_block_args_newlab <- function(data, vectorized) {
  d <- data

  res <- list(
    orig_var = ifelse(vectorized, rlang::sym(d$var[1]), d$var[1]),
    new_label = d$new_label[1]
  )
  list(res)
}
parse_cmd_block_args_kg <- function(data, vectorized) {
  d <- data

  res <- list(
    split_var = ifelse(vectorized, rlang::sym(d$X3[1]), d$X3[1]),
    by_var = ifelse(vectorized, rlang::sym(d$X2[1]), d$X2[1])
  )
  list(res)
}
parse_cmd_block_args_varl <- function(data, vectorized) {
  d <- data

  res <- list(
    orig_var = ifelse(vectorized, rlang::sym(d$X2[1]), d$X2[1]),
    new_lab = d$X3[1]
  )
  list(res)
}
parse_cmd_block_args_dic <- function(data, vectorized) {
  d <- data

  res <- list(
    orig_var = ifelse(vectorized, rlang::sym(d$X2[1]), d$X2[1]),
    new_var = ifelse(vectorized, rlang::sym(d$X3[1]), d$X3[1])
  )
  list(res)
}
parse_cmd_block_args_comp <- function(data, vectorized) {
  d <- data
  if (vectorized) {
    res <- list(
      x = rlang::sym(d$X2[1]),
      comp_expr = d$X3[1]
    )
  }
  else {
    res <- list(
      new_var = d$X2[1],
      new_val = d$X3[1]
    )
  }
  list(res)
}
parse_cmd_block_args_if <- function(data, vectorized) {
  d <- data
  assignment <- d$X3 %>% stringr::str_split("=") %>% unlist() %>% stringr::str_squish()

  res <- list(
    new_var   = ifelse(vectorized, rlang::sym(assignment[1]), assignment[1]),
    new_val   = assignment[2],
    condition = d$X2
  )
  list(res)
}
parse_cmd_block_args_avall <- function(data, vectorized) {
  d <- data
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  res <- list(
    orig_var  = ifelse(vectorized, rlang::sym(d$X2[1]), d$X2[1]),
    new_lab  = varlab,
    vals_added = d$X2[-1] %>% as.numeric(),
    labs_added = d$X3[-1]
  )
  list(res)
}
parse_cmd_block_args_vall <- function(data, vectorized) {
  d <- data
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  res <- list(
    orig_var  = ifelse(vectorized, rlang::sym(d$X2[1]), d$X2[1]),
    new_lab  = varlab,
    new_vals = d$X2[-1] %>% as.numeric(),
    new_labs = d$X3[-1]
  )
  list(res)
}
parse_cmd_block_args_rec <- function(data, vectorized) {
  d <- data
  res <- list(
    # use orig_var if new_var is NA (empty in Excel file):
    orig_var = ifelse(vectorized, rlang::sym(d$X2[1]), d$X2[1]),
    new_lab = d$X4[1],
    lb  = d$X2[-1] %>% as.numeric(),
    ub  = d$X3[-1] %>% as.numeric(),
    new_vals = d$X4[-1] %>% as.numeric(),
    new_labs = d$X5[-1]
  )
  if (!vectorized) {
    res <- res %>% append(list(new_var  = dplyr::coalesce(d$X3[1], d$X2[1])))
  }
  list(res)
}

parse_cmd_block_args_newvall <- function(data, vectorized) {
  d <- data
  res <- list(
    orig_var = ifelse(vectorized, rlang::sym(d$var[1]), d$var[1]),
    vals_added = d$nv %>% as.numeric(),
    labs_added = d$new_label
  )
  list(res)
}

parse_cmd_block_args_autorec <- function(data, vectorized) {
  d <- data
  res <- list(
    var = ifelse(vectorized, rlang::sym(d$var), d$var)
  )
  list(res)
}

parse_cmd_block_args_str_to_num <- function(data, vectorized) {
  d <- data
  res <- list(
    var = ifelse(vectorized, rlang::sym(d$var), d$var)
  )
  list(res)
}

parse_cmd_block_args_sumvar <- function(data, vectorized) {
  d <- data
  res <- list(
    orig_var = ifelse(vectorized, rlang::sym(d$var[1]), d$var[1]),
    new_lab = d$sum_var_label[1],
    orig_vals  = d$nv %>% as.numeric(),
    new_vals = d$sum_var_value %>% as.numeric(),
    new_labs = d$sum_var_vallab
  )
  if (!vectorized) {
    res <- res %>% append(list(new_var = paste0("k", d$var[1])))
  }
  list(res)
}



parse_cmd_block_args_verbatim <- function(data, vectorized) {
  d <- data
  res <- list(
    var_ziel = ifelse(vectorized, rlang::sym(d$var_ziel), d$var_ziel),
    val_assign  = d$val_assign,
    varlab = d$varlab[[1]],
    vallab  = d$vallab[[1]],
    id = ifelse(vectorized, rlang::sym(d$id_var_str), d$id_var_str),
    id_list = d$id_list[[1]],
    init_val = d$init_val
  )

  list(res)
}


parse_cmd_block_args_merge <- function(data, vectorized) {
  d <- data
  res <- list(
    variable_names  = d$X4[1] %>% stringr::str_split(" ", simplify = T) %>% as.vector(),
    merge_file  = d$X2
  )
  if (vectorized) {
    res <- res %>% append(list(id_var_name = d$X3[1]))
  }
  else {
    res <- res %>% append(list(id = d$X3[1]))
  }

  list(res)
}

parse_cmd_block_args_rfun <- function(data) {
  d <- data
  res <- list(
    r_script  = d$X2,
    fun_name = d$X3
  )
  list(res)
}

parse_cmd_block_args_r <- function(data) {
  d <- data
  res <- list(
    r_code  = d$X2
  )
  list(res)
}

