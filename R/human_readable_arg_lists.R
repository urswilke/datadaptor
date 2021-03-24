parse_cmd_block_args <- function(action, data) {
  switch (
    action,
    "#RFUN"    = parse_cmd_block_args_rfun(data),
    "#R"       = parse_cmd_block_args_r(data),
    "#MERGE"   = parse_cmd_block_args_merge(data),
    "#IF"      = parse_cmd_block_args_if(data),
    "#COMP"    = parse_cmd_block_args_comp(data),
    "#COMPR"   = parse_cmd_block_args_comp(data),
    "#REC"     = parse_cmd_block_args_rec(data),
    "#NEWVALL" = parse_cmd_block_args_newvall(data),
    "#AUTOREC" = parse_cmd_block_args_autorec(data),
    "#STR2NUM" = parse_cmd_block_args_str_to_num(data),
    "#SUMVAR"  = parse_cmd_block_args_sumvar(data),
    "#RENAME"  = parse_cmd_block_args_rename(data),
    "#DROP"    = parse_cmd_block_args_drop(data),
    "#NEWLAB"  = parse_cmd_block_args_newlab(data),
    "#VARL"    = parse_cmd_block_args_varl(data),
    "#VALL"    = parse_cmd_block_args_vall(data),
    "#AVALL"   = parse_cmd_block_args_avall(data),
    "#DIC"     = parse_cmd_block_args_dic(data),
    "#KG"      = parse_cmd_block_args_kg(data),
    "#verbatim"= parse_cmd_block_args_verbatim(data),
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

parse_cmd_block_args_newlab <- function(data) {
  d <- data

  res <- list(
    orig_var = d$var[1],
    new_label = d$new_label[1]
  )
  list(res)
}
parse_cmd_block_args_kg <- function(data) {
  d <- data

  res <- list(
    split_var = d$X3[1],
    by_var    = d$X2[1]
  )
  list(res)
}
parse_cmd_block_args_varl <- function(data) {
  d <- data

  res <- list(
    orig_var = d$X2[1],
    new_lab = d$X3[1]
  )
  list(res)
}
parse_cmd_block_args_dic <- function(data) {
  d <- data

  res <- list(
    orig_var = d$X2[1],
    new_var = d$X3[1]
  )
  list(res)
}
parse_cmd_block_args_comp <- function(data) {
  d <- data

  res <- list(
    new_var = d$X2[1],
    new_val = d$X3[1]
  )
  list(res)
}
parse_cmd_block_args_if <- function(data) {
  d <- data
  assignment <- d$X3 %>% stringr::str_split("=") %>% unlist() %>% stringr::str_squish()

  res <- list(
    new_var   = assignment[1],
    new_val   = assignment[2],
    condition = d$X2
  )
  list(res)
}
parse_cmd_block_args_avall <- function(data) {
  d <- data
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  res <- list(
    orig_var  = d$X2[1],
    new_lab  = varlab,
    vals_added = d$X2[-1] %>% as.numeric(),
    labs_added = d$X3[-1]
  )
  list(res)
}
parse_cmd_block_args_vall <- function(data) {
  d <- data
  varlab <- d$X3[1]
  if (is.na(varlab)) {
    varlab <- NULL
  }
  res <- list(
    orig_var  = d$X2[1],
    new_lab  = varlab,
    new_vals = d$X2[-1] %>% as.numeric(),
    new_labs = d$X3[-1]
  )
  list(res)
}
parse_cmd_block_args_rec <- function(data) {
  d <- data
  res <- list(
    # use orig_var if new_var is NA (empty in Excel file):
    new_var  = dplyr::coalesce(d$X3[1], d$X2[1]),
    orig_var = d$X2[1],
    new_lab = d$X4[1],
    lb  = d$X2[-1] %>% as.numeric(),
    ub  = d$X3[-1] %>% as.numeric(),
    new_vals = d$X4[-1] %>% as.numeric(),
    new_labs = d$X5[-1]
  )
  list(res)
}

parse_cmd_block_args_newvall <- function(data) {
  d <- data
  res <- list(
    orig_var  = d$var[1],
    vals_added = d$nv %>% as.numeric(),
    labs_added = d$new_label
  )
  list(res)
}

parse_cmd_block_args_autorec <- function(data) {
  d <- data
  res <- list(
    var = d$var
  )
  list(res)
}

parse_cmd_block_args_str_to_num <- function(data) {
  d <- data
  res <- list(
    var = d$var
  )
  list(res)
}

parse_cmd_block_args_sumvar <- function(data) {
  d <- data
  res <- list(
    new_var = paste0("k", d$var[1]),
    orig_var  = d$var[1],
    new_lab = d$sum_var_label[1],
    orig_vals  = d$nv %>% as.numeric(),
    new_vals = d$sum_var_value %>% as.numeric(),
    new_labs = d$sum_var_vallab
  )
  list(res)
}



parse_cmd_block_args_verbatim <- function(data) {
  d <- data
    res <- list(
    var_ziel = d$var_ziel,
    val_assign  = d$val_assign,
    varlab = d$varlab[[1]],
    vallab  = d$vallab[[1]],
    id = d$id_var_str,
    id_list = d$id_list[[1]],
    init_val = d$init_val
  )
  list(res)
}


parse_cmd_block_args_merge <- function(data) {
  d <- data
  res <- list(
    variable_names  = d$X4[1] %>% stringr::str_split(" ", simplify = T) %>% as.vector(),
    id = d$X3[1],
    merge_file  = d$X2
  )
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

