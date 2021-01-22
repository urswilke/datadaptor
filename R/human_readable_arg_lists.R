transl_human_read <- function(action, data) {
  switch (
    action,
    "#IF"      = transl_human_read_if(data),
    "#COMP"    = transl_human_read_comp(data),
    "#REC"     = transl_human_read_rec(data),
    "#SUMVAR"  = transl_human_read_sumvar(data),
    "#RENAME"  = transl_human_read_rename(data),
    "#NEWLAB"  = transl_human_read_newlab(data),
    "#VARL"    = transl_human_read_varl(data),
    "#VALL"    = transl_human_read_vall(data),
    "#AVALL"   = transl_human_read_avall(data),
    "#KG"      = transl_human_read_kg(data),
    "#Verba"   = transl_human_read_verbatim(data),
    stop("Invalid action command")
  )
}

transl_human_read_rename <- function(data) {
  d <- data

  res <- list(
    orig_vars = d$vars[[1]],
    new_names = d$new_names[[1]]
  )
  list(res)
}
transl_human_read_newlab <- function(data) {
  d <- data

  res <- list(
    orig_var = d$var[1],
    new_label = d$new_label[1]
  )
  list(res)
}
transl_human_read_kg <- function(data) {
  d <- data

  res <- list(
    split_var = d$X2[1],
    by_var    = d$X3[1]
  )
  list(res)
}
transl_human_read_varl <- function(data) {
  d <- data

  res <- list(
    orig_var = d$X2[1],
    new_lab = d$X3[1]
  )
  list(res)
}
transl_human_read_comp <- function(data) {
  d <- data

  res <- list(
    new_var = d$X2[1],
    new_val = d$X3[1]
  )
  list(res)
}
transl_human_read_if <- function(data) {
  d <- data
  assignment <- d$X3 %>% stringr::str_split("=") %>% unlist() %>% stringr::str_squish()

  res <- list(
    new_var   = assignment[1],
    new_val   = assignment[2],
    condition = d$X2
  )
  list(res)
}
transl_human_read_avall <- function(data) {
  d <- data
  res <- list(
    orig_var  = d$X2[1],
    new_lab  = d$X3[1],
    vals_added = d$X2[-1] %>% as.numeric(),
    labs_added = d$X3[-1]
  )
  list(res)
}
transl_human_read_vall <- function(data) {
  d <- data
  res <- list(
    orig_var  = d$X2[1],
    new_lab  = d$X3[1],
    new_vals = d$X2[-1] %>% as.numeric(),
    new_labs = d$X3[-1]
  )
  list(res)
}
transl_human_read_rec <- function(data) {
  d <- data
  res <- list(
    new_var  = d$X3[1],
    orig_var = d$X2[1],
    new_lab = d$X4[1],
    lb  = d$X2[-1] %>% as.numeric(),
    ub  = d$X3[-1] %>% as.numeric(),
    new_vals = d$X4[-1] %>% as.numeric(),
    new_labs = d$X5[-1]
  )
  list(res)
}

transl_human_read_sumvar <- function(data) {
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



transl_human_read_verbatim <- function(data) {
  d <- data
    res <- list(
    var_ziel = d$var_ziel,
    val_assign  = d$val_assign,
    varlab = d$varlab,
    vallab  = d$vallab[[1]],
    id = d$id_var_str,
    id_list = d$id_list[[1]]
  )
  list(res)
}



