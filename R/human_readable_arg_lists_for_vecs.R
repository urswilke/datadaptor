parse_cmd_block_args_vec <- function(action, data) {
  switch (
    action,
    "#RFUN"    = parse_cmd_block_args_rfun_vec(data),
    "#R"       = parse_cmd_block_args_r_vec(data),
    "#MERGE"   = parse_cmd_block_args_merge_vec(data),
    "#IF"      = parse_cmd_block_args_if_vec(data),
    "#COMP"    = parse_cmd_block_args_comp_vec(data),
    "#COMPR"   = parse_cmd_block_args_comp_vec(data),
    "#REC"     = parse_cmd_block_args_rec_vec(data),
    "#NEWVALL" = parse_cmd_block_args_newvall_vec(data),
    "#AUTOREC" = parse_cmd_block_args_autorec_vec(data),
    "#SUMVAR"  = parse_cmd_block_args_sumvar_vec(data),
    "#RENAME"  = parse_cmd_block_args_rename_vec(data),
    "#NEWLAB"  = parse_cmd_block_args_newlab_vec(data),
    "#VARL"    = parse_cmd_block_args_varl_vec(data),
    "#VALL"    = parse_cmd_block_args_vall_vec(data),
    "#AVALL"   = parse_cmd_block_args_avall_vec(data),
    "#DIC"     = parse_cmd_block_args_dic_vec(data),
    "#KG"      = parse_cmd_block_args_kg_vec(data),
    "#verbatim"= parse_cmd_block_args_verbatim_vec(data),
    stop("Invalid action command")
  )
}

parse_cmd_block_args_rename_vec <- function(data) {
  d <- data

  res <- list(
    orig_vars = d$vars[[1]],
    new_names = d$new_names[[1]]
  )
  list(res)
}
parse_cmd_block_args_newlab_vec <- function(data) {
  d <- data

  res <- list(
    orig_var = rlang::sym(d$var[1]),
    new_label = d$new_label[1]
  )
  list(res)
}
parse_cmd_block_args_kg_vec <- function(data) {
  d <- data

  res <- list(
    split_var = rlang::sym(d$X3[1]),
    by_var    = rlang::sym(d$X2[1])
  )
  list(res)
}
parse_cmd_block_args_varl_vec <- function(data) {
  d <- data

  res <- list(
    orig_var = rlang::sym(d$X2[1]),
    new_lab = d$X3[1]
  )
  list(res)
}
parse_cmd_block_args_dic_vec <- function(data) {
  d <- data

  res <- list(
    orig_var = rlang::sym(d$X2[1]),
    new_var = rlang::sym(d$X3[1])
  )
  list(res)
}
parse_cmd_block_args_comp_vec <- function(data) {
  d <- data

  res <- list(
    x = rlang::sym(d$X2[1]),
    comp_expr = d$X3[1]
  )
  list(res)
}
parse_cmd_block_args_if_vec <- function(data) {
  d <- data
  assignment <- d$X3 %>% stringr::str_split("=") %>% unlist() %>% stringr::str_squish()

  res <- list(
    new_var   = rlang::sym(assignment[1]),
    new_val   = assignment[2],
    condition = d$X2
  )
  list(res)
}
parse_cmd_block_args_avall_vec <- function(data) {
  d <- data
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  res <- list(
    orig_var  = rlang::sym(d$X2[1]),
    new_lab  = varlab,
    vals_added = d$X2[-1] %>% as.numeric(),
    labs_added = d$X3[-1]
  )
  list(res)
}
parse_cmd_block_args_vall_vec <- function(data) {
  d <- data
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  res <- list(
    orig_var  = rlang::sym(d$X2[1]),
    new_lab  = varlab,
    new_vals = d$X2[-1] %>% as.numeric(),
    new_labs = d$X3[-1]
  )
  list(res)
}
parse_cmd_block_args_rec_vec <- function(data) {
  d <- data
  res <- list(
    # use orig_var if new_var is NA (empty in Excel file):
    orig_var = rlang::sym(d$X2[1]),
    new_lab = d$X4[1],
    lb  = d$X2[-1] %>% as.numeric(),
    ub  = d$X3[-1] %>% as.numeric(),
    new_vals = d$X4[-1] %>% as.numeric(),
    new_labs = d$X5[-1]
  )
  list(res)
}

parse_cmd_block_args_newvall_vec <- function(data) {
  d <- data
  res <- list(
    orig_var  = rlang::sym(d$var[1]),
    vals_added = d$nv %>% as.numeric(),
    labs_added = d$new_label
  )
  list(res)
}

parse_cmd_block_args_autorec_vec <- function(data) {
  d <- data
  res <- list(
    var = rlang::sym(d$var)
  )
  list(res)
}
parse_cmd_block_args_sumvar_vec <- function(data) {
  d <- data
  res <- list(
    # new_var = rlang::sym(paste0("k", d$var[1])),
    orig_var  = rlang::sym(d$var[1]),
    new_lab = d$sum_var_label[1],
    orig_vals  = d$nv %>% as.numeric(),
    new_vals = d$sum_var_value %>% as.numeric(),
    new_labs = d$sum_var_vallab
  )
  list(res)
}



parse_cmd_block_args_verbatim_vec <- function(data) {
  d <- data
  res <- list(
    var_ziel = rlang::sym(d$var_ziel),
    val_assign  = d$val_assign,
    varlab = d$varlab[[1]],
    vallab  = d$vallab[[1]],
    id = rlang::sym(d$id_var_str),
    id_list = d$id_list[[1]],
    init_val = d$init_val
  )
  list(res)
}


parse_cmd_block_args_merge_vec <- function(data) {
  d <- data
  res <- list(
    variable_names  = d$X4[1] %>% stringr::str_split(" ", simplify = T) %>% as.vector(),
    id_var_name = d$X3[1],
    merge_file  = d$X2
  )
  list(res)
}

parse_cmd_block_args_rfun_vec <- function(data) {
  d <- data
  res <- list(
    r_script  = d$X2,
    fun_name = d$X3
  )
  list(res)
}

parse_cmd_block_args_r_vec <- function(data) {
  d <- data
  res <- list(
    r_code  = d$X2
  )
  list(res)
}

