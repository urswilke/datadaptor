library(tidyverse)
library(readxl)


verba_file <- "inst/extdata/Verbatims_fake survey_20201204UW.xlsx"
map_file <- "inst/extdata/mapping.xlsx"
df_orig <- haven::read_spss("inst/extdata/fake_survey.sav")


# get a named vector of the sheet names in the verbatim file:
verba_file_sheets <-
  verba_file %>%
  excel_sheets() %>%
  # except "Codestufen", the first sheet:
  .[-1] %>%
  # by setting names, the map function applied later, will assign these names to
  # the created list elements...
  set_names()

read_assigns <- function(sheet_name){
  read_excel(verba_file, skip=31, sheet = sheet_name, col_names = TRUE) %>%
    select(`Orig. Variable`, ID, Antwort, matches("^Zuord "))
}


# gather & prepare all assignments ------------------------------------------
l_assigns_raw <-
  verba_file_sheets %>%
  map(~read_assigns(.x))


mapping_verba_sheet <-
  read_excel(map_file,
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


# * data frame & list containing all assignment information in compact form --------
df_assigns_overview <-
  df_assigns %>%
  group_by(var_ziel, val_assign) %>%
  summarise(assign_cond =
              DC_ID %>%
              paste(., collapse = ", ") %>%
              paste0("DC_ID %in% c(", .) %>% paste0(")"))

# make a list of data frames, each containing the value assignment information for
# the concerned variables:
# l_assigns <- df_assigns %>% split(., .$var_ziel)
l_assigns <-
  df_assigns_overview %>%
  transpose(., .names = paste(.$var_ziel, .$val_assign, sep = " := "))



# verbatim codes assignments ---------------------------------------------------


# * prepare data frame ----------------------------------------------------

# the data frame with the original data is slightly modified, in order to be in
# the format needed to apply the function mutate_vals:
df_add_vals <- df_orig %>% rename(DC_ID = id)

common_cols <- intersect(df_assigns$var_ziel %>% unique,
                          names(df_orig))
new_cols <- setdiff(df_assigns$var_ziel %>% unique,
                          names(df_orig))

# in order to have type stable data, the already existing variables common_cols
# that will be manipulated are changed to numeric (all the labels are removed):
df_add_vals[,common_cols] <- df_add_vals[,common_cols] %>% mutate_all(as.numeric)
# the new columns new_cols are added as NA (numeric also)
df_add_vals[,new_cols] <- NA_real_

# function to assign the verbatim values to the according variables:
mutate_cond <- function(.data, l_assigns, envir = parent.frame()) {
  # the condition in the string is transformed to a logical vector:
  condition <- lazyeval::lazy_eval(l_assigns$assign_cond, data = .data)
  var_ziel <- l_assigns$var_ziel
  val_assign <- l_assigns$val_assign
  # print(var_ziel)
  # this is for speed reasons. When only the concerned columns are selected in
  # the data frame (instead of the whole data frame) to calculate the mutated
  # ones, this is much faster (as the function is called repeatedly, this is of
  # consideral importance...)

  # The first argument of intersect consists of all the names and values in the
  # named vector. Only variable names of the data frame are needed for the
  # mutate assignment to retrieve all the necessary information:
  vars_used <-
    intersect(c(var_ziel, val_assign),
              names(df_add_vals))
  # mutate the sub-data frame according to the assignments in assign_vec (the
  # "!!!" tells R to evaluate the content of the variable and not the text of
  # the variable itself, and furthermore, that several arguments might follow):
  .data[condition, vars_used] <-
    .data[condition, vars_used] %>%
    mutate(!!var_ziel := !!val_assign)
  # return the whole data frame:
  .data
}



# * assign verbatim codes in data frame -----------------------------------

# This assigns the data in the list elements of l_assigns repeatedly to the data
# frame df_add_vals:
# (to assign only the first list element the command would be:)
# df_add_vals %>% mutate_cond(l_assigns[[1]])
df_add_vals <- reduce(l_assigns, mutate_cond, .init = df_add_vals)

# now, this data frame contains the data of the code assignments







# update labels -----------------------------------------------------------

# * data frame containing all updated variable/value labels ---------------
df_cats <-
  df_assigns %>%
  # this extracts all the variables that are assigned var_ziel (the other
  # columns don't add cases...):
  distinct(q_id, var_ziel, code_assign, EFA1MCG2MDG3) %>%
  # the labelled values are joint. Every variable var_ziel will be repeated the
  # number of times, there are different codes in the corresponding sheet in the
  # verbatim file:
  left_join(.,
            read_excel(verba_file,
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
  mutate(var_lab=case_when(EFA1MCG2MDG3 == 3 ~ Beschreibung,
                           EFA1MCG2MDG3 != 3 ~ "")) %>%
  # create a column containing named vectors containing the values & the value
  # labels for each var_ziel:
  group_by(var_ziel) %>%
  summarise(val_labs = list(q_id=setNames(Code, Beschreibung)),
            var_lab  = first(var_lab),
            EFA1MCG2MDG3 = first(EFA1MCG2MDG3)) %>%
  # for mdg variables the value labels that where created make no sense and are
  # not needed (in the future one could add something like "1 = selected"...):
  mutate(val_labs = if_else(EFA1MCG2MDG3 == 3, list(NULL), val_labs))

# function to add the label information:
add_labels <- function(df_add_vals, df_cats){
  df_new_vars <- df_add_vals %>% select(df_cats$var_ziel)
  df_lbl <- map2_dfc(
    df_new_vars,
    df_cats$val_labs,
    ~ haven::labelled(.x, labels = .y)
  )
  bind_cols(df_add_vals %>% select(-c(df_cats$var_ziel)), df_lbl)
}


# * update labels in data frame --------------------------------------------


df_add_labs <- add_labels(df_add_vals, df_cats)


# write sav file ----------------------------------------------------------

haven::write_sav(df_add_labs, "test.sav")




