library(tidyverse)
library(datenanpassr)
df <- haven::read_sav('/home/chief/R/x86_64-pc-linux-gnu-library/4.0/datenanpassr/extdata/fake_survey.sav')
df <- 
  cmd_set_lab(df, orig_var = "q1", new_label = "Like Product")
df <- 
  cmd_set_lab(df, orig_var = "q2", new_label = "recommend product")
df <- 
  cmd_set_lab(df, orig_var = "q5", new_label = "Like best friend")
df <- 
  cmd_sumvar(df, new_var = "kq1", orig_var = "q1", new_lab = "test", 
      orig_vals = c(1, 2, 3, 4, 5), new_vals = c(1, 1, 2, 3, 3), 
      new_labs = c("aaa", NA, "bbb", "ccc", NA))
df <- 
  cmd_verba(df, var_ziel = "q6n", val_assign = 1, varlab = NA_character_, 
      vallab = structure(1:3, .Names = c("love", "joy", "happiness"
      )), id_list = c(1, 7, 8, 9, 10, 16, 17, 23, 24, 30, 32, 33, 
      36, 41, 42, 51, 53, 58, 61, 65, 67, 68, 70, 73, 74, 75, 82, 
      86, 91, 93, 100))
df <- 
  cmd_verba(df, var_ziel = "q6n", val_assign = 2, varlab = NA_character_, 
      vallab = structure(1:3, .Names = c("love", "joy", "happiness"
      )), id_list = c(3, 4, 6, 11, 13, 19, 20, 22, 25, 26, 28, 
      29, 34, 35, 38, 44, 45, 46, 47, 50, 52, 54, 55, 56, 57, 66, 
      71, 72, 77, 78, 81, 83, 84, 85, 87, 88, 89, 90, 94, 96, 97
      ))
df <- 
  cmd_verba(df, var_ziel = "q6n", val_assign = 3, varlab = NA_character_, 
      vallab = structure(1:3, .Names = c("love", "joy", "happiness"
      )), id_list = c(2, 5, 12, 14, 15, 18, 21, 27, 31, 37, 39, 
      40, 43, 48, 49, 59, 60, 62, 63, 64, 69, 76, 79, 80, 92, 95, 
      98, 99))
df <- 
  cmd_verba(df, var_ziel = "q6n1", val_assign = 1, varlab = NA_character_, 
      vallab = structure(1:4, .Names = c("love", "joy", "happiness", 
      "noch wat")), id_list = c(1, 7, 8, 9, 10, 16, 17, 23, 24, 
      30, 32, 33, 36, 41, 42, 51, 53, 58, 61, 65, 67, 68, 70, 73, 
      74, 75, 82, 86, 91, 93, 100))
df <- 
  cmd_verba(df, var_ziel = "q6n1", val_assign = 2, varlab = NA_character_, 
      vallab = structure(1:4, .Names = c("love", "joy", "happiness", 
      "noch wat")), id_list = c(3, 4, 6, 11, 13, 19, 20, 22, 25, 
      26, 28, 29, 34, 35, 38, 44, 45, 46, 47, 50, 52, 54, 55, 56, 
      57, 66, 71, 72, 77, 78, 81, 83, 84, 85, 87, 88, 89, 90, 94, 
      96, 97))
df <- 
  cmd_verba(df, var_ziel = "q6n1", val_assign = 3, varlab = NA_character_, 
      vallab = structure(1:4, .Names = c("love", "joy", "happiness", 
      "noch wat")), id_list = c(2, 5, 12, 14, 15, 18, 21, 27, 31, 
      37, 39, 40, 43, 48, 49, 59, 60, 62, 63, 64, 69, 76, 79, 80, 
      92, 95, 98, 99))
df <- 
  cmd_verba(df, var_ziel = "q6n2", val_assign = 4, varlab = NA_character_, 
      vallab = structure(1:4, .Names = c("love", "joy", "happiness", 
      "noch wat")), id_list = c(7, 58, 73))
df <- 
  cmd_verba(df, var_ziel = "q6_1", val_assign = 1, varlab = "love", 
      vallab = NULL, id_list = c(1, 7, 8, 9, 10, 16, 17, 23, 24, 
      30, 32, 33, 36, 41, 42, 51, 53, 58, 61, 65, 67, 68, 70, 73, 
      74, 75, 82, 86, 91, 93, 100))
df <- 
  cmd_verba(df, var_ziel = "q6_2", val_assign = 1, varlab = "joy", 
      vallab = NULL, id_list = c(3, 4, 6, 11, 13, 19, 20, 22, 25, 
      26, 28, 29, 34, 35, 38, 44, 45, 46, 47, 50, 52, 54, 55, 56, 
      57, 66, 71, 72, 77, 78, 81, 83, 84, 85, 87, 88, 89, 90, 94, 
      96, 97))
df <- 
  cmd_verba(df, var_ziel = "q6_3", val_assign = 1, varlab = "happiness", 
      vallab = NULL, id_list = c(2, 5, 12, 14, 15, 18, 21, 27, 
      31, 37, 39, 40, 43, 48, 49, 59, 60, 62, 63, 64, 69, 76, 79, 
      80, 92, 95, 98, 99))
df <- 
  cmd_verba(df, var_ziel = "q6_4", val_assign = 1, varlab = "noch wat", 
      vallab = NULL, id_list = c(7, 58, 73))
df <- 
  cmd_verba(df, var_ziel = "q7n", val_assign = 1, varlab = NA_character_, 
      vallab = structure(1:4, .Names = c("sadness", "fear", "anger", 
      "pain")), id_list = c(2, 3, 7, 9, 13, 16, 32, 34, 42, 47, 
      48, 59, 62, 77, 79, 82, 87, 91, 99))
df <- 
  cmd_verba(df, var_ziel = "q7n", val_assign = 2, varlab = NA_character_, 
      vallab = structure(1:4, .Names = c("sadness", "fear", "anger", 
      "pain")), id_list = c(5, 11, 14, 18, 19, 20, 21, 26, 29, 
      33, 41, 46, 50, 51, 57, 61, 63, 67, 68, 73, 75, 78, 84, 88, 
      90, 92, 96))
df <- 
  cmd_verba(df, var_ziel = "q7n", val_assign = 3, varlab = NA_character_, 
      vallab = structure(1:4, .Names = c("sadness", "fear", "anger", 
      "pain")), id_list = c(1, 4, 8, 10, 12, 22, 28, 30, 36, 37, 
      38, 39, 40, 43, 53, 55, 60, 64, 65, 72, 74, 83, 85, 86, 89, 
      93, 95, 97, 100))
df <- 
  cmd_verba(df, var_ziel = "q7n", val_assign = 4, varlab = NA_character_, 
      vallab = structure(1:4, .Names = c("sadness", "fear", "anger", 
      "pain")), id_list = c(6, 15, 17, 23, 24, 25, 27, 31, 35, 
      44, 45, 49, 52, 54, 56, 58, 66, 69, 70, 71, 76, 80, 81, 94, 
      98))
df <- 
  cmd_comp(df, new_var = "x", new_val = "1")
df <- 
  cmd_if(df, new_var = "abc", new_val = "7", condition = "q1 == 1")
df <- 
  cmd_if(df, new_var = "kq5", new_val = "7", condition = "q2 == 1")
df <- 
  cmd_if(df, new_var = "kq6", new_val = "8", condition = "q3 == 1")
df <- 
  cmd_rec(df, new_var = "kq3", orig_var = "q3", new_lab = "summarized variable", 
      lb = c(1, 3, 4), ub = c(2, 3, 5), new_vals = c(1, 2, 3), 
      new_labs = c("1-2", "3", "4-5"))
df <- 
  cmd_kg(df, split_var = "q2", by_var = "q1")
df <- 
  cmd_comp(df, new_var = "n", new_val = "1")
df <- 
  cmd_set_lab(df, orig_var = "n", new_lab = "my new label")
df <- 
  cmd_set_labs(df, orig_var = "n", new_lab = "overwrite new label", 
      new_vals = c(1, 2, 3), new_labs = c("also with", "value labels", 
      "now"))
df <- 
  cmd_add_labs(df, orig_var = "n", new_lab = NA_character_, vals_added = 4, 
      labs_added = "added label")
df <- 
  cmd_comp(df, new_var = "free2_var", new_val = "3")
