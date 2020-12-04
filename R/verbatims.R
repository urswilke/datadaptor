

mapp_prepare_verba_data <- function(map_file, verba_file = mapp_extract_verbatim_file(map_file)) {
  verba_file_sheets <-
    verba_file %>%
    readxl::excel_sheets() %>%
    # except "Codestufen", the first sheet:
    .[-1] %>%
    # by setting names, the map function applied later, will assign these names to
    # the created list elements...
    set_names()

  read_assigns <- function(sheet_name){
    readxl::read_excel(verba_file, skip=31, sheet = sheet_name, col_names = TRUE) %>%
      select(`Orig. Variable`, ID, Antwort, matches("^Zuord "))
  }


  # gather & prepare all assignments ------------------------------------------
  l_assigns_raw <-
    verba_file_sheets %>%
    map(~read_assigns(.x))


  mapping_verba_sheet <-
    readxl::read_excel(map_file,
               skip = 14,
               sheet = "Verbatims",
               col_names = TRUE) %>%
    drop_na(VariableOriginal) %>%
    select(VariableOriginal:`Tabellen-blatt`, VariableZiel)





  # * gather all assignments in a long data frame ------------------------------------------

  #function to replace the term {OT...} in var_ziel by the corresponding substring
  #in orig_var:
  un_OT_ize <- function(var_ziel,orig_var){
    # exctract the three digits in {OT...} :
    copyDigits <- str_match(var_ziel,"\\{OT(.*?)\\}")[,2]
    # the first two digits in the beginning represent the starting positition:
    cp1stPos <- copyDigits %>% str_match("^\\d\\d") %>% as.numeric()
    # the last digit in the end represent the length:
    cpLength <- copyDigits %>% str_match("\\d$") %>% as.numeric()
    # extract substring of orig_var:
    replaceStr <- str_sub(orig_var, cp1stPos, cp1stPos + cpLength - 1)
    # replace the term {OT...} by the latter substring:
    var_name <- str_replace(var_ziel,"\\{OT\\d\\d\\d\\}",replaceStr)
    var_name
  }

  df_assigns <-
    l_assigns_raw %>%
    # write all the assignments in the same data frame:
    bind_rows(.id = "q_id") %>%
    # add the EFA1MCG2MDG3 information & VariableZiel from the verbatim sheet in
    # the mapping file:
    full_join(., mapping_verba_sheet, by = c("Orig. Variable" = "VariableOriginal")) %>%
    # gather all the assignments in two columns: i_assign is the index of the
    # column (Zuord 1, ..., 5) and code_assign is the assigned code:
    gather(i_assign, code_assign, starts_with("Zuord")) %>%
    # this removes the data where nothing was assigned. If one wants to have a
    # stable number of variables assigned, this should be changed:
    drop_na(code_assign) %>%
    # remove the substring "Zuord ":
    mutate(i_assign = str_remove(i_assign, "^Zuord ")) %>%
    # replace the {OT...} term:
    mutate(VariableZiel = un_OT_ize(VariableZiel, `Orig. Variable`)) %>%
    # depending on the variable type, the name of the variable to be assigned is
    # created by replacing the "{nn}" term: if one wants to allow multiple
    # assigned variable for EFA, the first line has to be adapted according to the
    # second...
    mutate(var_ziel = case_when(EFA1MCG2MDG3 == 1 ~ str_remove(VariableZiel, "\\{nn\\}"),
                                EFA1MCG2MDG3 == 2 ~ str_replace(VariableZiel, "\\{nn\\}", as.character(i_assign)),
                                EFA1MCG2MDG3 == 3 ~ str_replace(VariableZiel, "\\{nn\\}", as.character(code_assign)))) %>%
    # if there are several assignment columns for EFA variables, this line removes
    # them:
    # filter(!(EFA1MCG2MDG3 == 1 & i_assign != 1)) %>%
    # the value to be assigned for mdg variables is 1, otherwise code_assign:
    mutate(val_assign = if_else(EFA1MCG2MDG3 == 3, 1, code_assign)) %>%
    # the column code_assign is only needed for mdg variables to assign the right
    # variable labels later. Therefore, it is set to NA for the other variables:
    mutate(code_assign = if_else(EFA1MCG2MDG3 != 3, NA_real_, code_assign)) %>%
    select(-i_assign) %>%
    rename(DC_ID = ID) %>%
    # the sorting of DC_ID is probably very important that the assigning of the
    # verbatim codes later is done in the correct order:
    arrange(DC_ID)


  df_cats <-
    df_assigns %>%
    # this extracts all the variables that are assigned var_ziel (the other
    # columns don't add cases...):
    distinct(q_id, var_ziel, code_assign, EFA1MCG2MDG3) %>%
    # the labelled values are joint. Every variable var_ziel will be repeated the
    # number of times, there are different codes in the corresponding sheet in the
    # verbatim file:
    left_join(.,
              readxl::read_excel(verba_file,
                         sheet = "Codestufen",
                         col_names = TRUE) %>%
                # in the Codestufen sheet there is no title for the code column; R
                # automatically has given the name X__1; change it to "Code"...:
                rename(Code=1) %>%
                gather(q_id, Beschreibung, -Code) %>%
                # only retain codes where a category ("Beschreibung") exists:
                drop_na(Beschreibung),
              by = "q_id") %>%
    # for mdg types, the only line with the correct variable label is the one
    # where the assigned code code_assign is equal to the Code in the Codestufen
    # sheet:
    filter(EFA1MCG2MDG3 != 3 | code_assign == Code) %>%
    # for mdg variables, a variable label column is created, for the other types
    # the variable label is set to the empty string:
    mutate(varlab=case_when(EFA1MCG2MDG3 == 3 ~ Beschreibung,
                             EFA1MCG2MDG3 != 3 ~ "")) %>%
    # create a column containing named vectors containing the values & the value
    # labels for each var_ziel:
    group_by(var_ziel) %>%
    summarise(vallabs = list(q_id=setNames(Code, Beschreibung)),
              varlab  = first(varlab),
              EFA1MCG2MDG3 = first(EFA1MCG2MDG3)) %>%
    # for mdg variables the value labels that where created make no sense and are
    # not needed (in the future one could add something like "1 = selected"...):
    mutate(vallab = if_else(EFA1MCG2MDG3 == 3, list(NULL), vallabs))
  # %>%
  #   mutate(vallabs = map(vallabs, ~ enframe(.x, "vallab", "val_assign"))) %>%
  #   unnest(vallabs)


  df_assigns_overview <-
    df_assigns %>%
    left_join(df_cats) %>%
    group_by(var_ziel, val_assign, vallab, varlab) %>%
    summarise(
      id_list = list(as.numeric(DC_ID)),
      # old:
      assign_cond =
                DC_ID %>%
                paste(., collapse = ", ") %>%
                paste0("DC_ID %in% c(", .) %>% paste0(")"))
  # %>%
  #   group_by(var_ziel)
  df_assigns_overview %>%
    mutate(
      sheet = "verbatims",
      new_var = var_ziel,
      action = "#Verba",
      row = cur_group_id() %>% as.character()
      ) %>%
    ungroup()  %>%
    dplyr::group_by(sheet, action, row, new_var) %>%
    tidyr::nest()
  # %>%
  #   transpose()
  # %>%
  #   rowwise() %>%
  #   group_split()
}

# l <- mapp_prepare_verba_data(map_file)

assign_verba_val <- function(df_raw, l) {
  # print(l$id_list)
  new_val <- l$val_assign
  # print(new_val)
  if (!l$var_ziel %in% names(df_raw)) {
    df_raw[l$var_ziel] <- NA_real_
  }
  df_raw[[l$var_ziel]][df_raw$id %in% l$id_list[[1]]] <- new_val
  y <- haven::labelled(
    df_raw[[l$var_ziel]],
    labels = l$vallab[[1]],
    label = l$varlab
  )
  df_raw[[l$var_ziel]] <- y
  # does the same
  # df_raw <- df_raw %>%
  #   mutate(
  #     !!rlang::sym(l$var_ziel) := ifelse(
  #       id %in% l$id_list[[1]],
  #       new_val,
  #       !!rlang::sym(l$var_ziel)
  #     )
  #   )



  # df_raw[[l$var_ziel]] <- haven::labelled(
  #   df_raw[[l$var_ziel]],
  #   labels =
  # )
  df_raw
}
# l$data %>% reduce(assign_verba_val, .init = df_orig)
# mapp_verbatims(df_orig, verba_file, map_file)
mapp_extract_verbatim_file <- function(mapping_file) {
  readxl::read_xlsx(
    mapping_file,
    sheet = "Verbatims",
    range = cellranger::cell_cols(c("B:D")),
    skip = 0
  ) %>%
    dplyr::rename_all(~LETTERS[2:4]) %>%
    dplyr::filter(B == "Filename input") %>%
    dplyr::pull(D)
}

