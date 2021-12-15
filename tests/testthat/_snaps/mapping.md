# command table is reproduced

    tibble [68 x 5] (S3: tbl_df/tbl/data.frame)
     $ sheet  : chr [1:68] "Config" "Label" "Label" "Variables" ...
     $ action : chr [1:68] "#RECNA" "#NEWVALL" "#SUMVAR" "#STR2NUM" ...
     $ row    : chr [1:68] NA "8" "2, 3, 4, 5, 6" "8" ...
     $ new_var: chr [1:68] NA "q2" "kq1" "q8" ...
     $ data   :List of 68
      ..$ :List of 3
      .. ..$ recode_na_exceptions: chr [1:2] "id" "DC_ID"
      .. ..$ replace_val         : num -2
      .. ..$ replace_label       : chr "FILTER"
      ..$ :List of 3
      .. ..$ orig_var  : chr "q2"
      .. ..$ vals_added: num 1
      .. ..$ labs_added: chr "YES"
      ..$ :List of 6
      .. ..$ orig_var : chr "q1"
      .. ..$ new_lab  : chr "test"
      .. ..$ orig_vals: num [1:5] 1 2 3 4 5
      .. ..$ new_vals : num [1:5] 1 1 2 3 3
      .. ..$ new_labs : chr [1:5] "aaa" NA "bbb" "ccc" ...
      .. ..$ new_var  : chr "kq1"
      ..$ :List of 1
      .. ..$ var: chr "q8"
      ..$ :List of 1
      .. ..$ var: chr "q6"
      ..$ :List of 1
      .. ..$ orig_vars: chr "q9"
      ..$ :List of 2
      .. ..$ orig_vars: chr [1:2] "q2" "q4"
      .. ..$ new_names: chr [1:2] "q2_renamed" "q4_renamed"
      ..$ :List of 2
      .. ..$ orig_var : chr "q1"
      .. ..$ new_label: chr "Like Product"
      ..$ :List of 2
      .. ..$ orig_var : chr "q2_renamed"
      .. ..$ new_label: chr "recommend product"
      ..$ :List of 2
      .. ..$ orig_var : chr "q5"
      .. ..$ new_label: chr "Like best friend"
      ..$ :List of 2
      .. ..$ orig_var : chr "q8"
      .. ..$ new_label: chr "Now the variable is in numeric format."
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:6] -2 1 2 3 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:31] 7 17 23 51 58 65 67 73 74 91 ...
      .. ..$ init_val  : num NA
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n"
      .. ..$ val_assign: num 2
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:6] -2 1 2 3 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:41] 3 13 22 26 35 38 45 47 55 72 ...
      .. ..$ init_val  : num NA
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n"
      .. ..$ val_assign: num 3
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:6] -2 1 2 3 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:24] 5 12 14 39 49 62 79 98 2 15 ...
      .. ..$ init_val  : num NA
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:6] -2 1 2 3 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num NA
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q7n"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "sadness" "fear" "anger" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:19] 77 87 7 9 13 16 32 48 59 79 ...
      .. ..$ init_val  : num NA
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q7n"
      .. ..$ val_assign: num 2
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "sadness" "fear" "anger" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:27] 5 11 19 29 41 46 51 57 61 63 ...
      .. ..$ init_val  : num NA
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q7n"
      .. ..$ val_assign: num 3
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "sadness" "fear" "anger" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:29] 1 28 30 36 40 60 72 83 85 95 ...
      .. ..$ init_val  : num NA
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q7n"
      .. ..$ val_assign: num 4
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "sadness" "fear" "anger" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:25] 6 15 23 27 44 45 49 56 66 69 ...
      .. ..$ init_val  : num NA
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6_1"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "love"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:31] 7 17 23 51 58 65 67 73 74 91 ...
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6_2"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "joy"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:41] 3 13 22 26 35 38 45 47 55 72 ...
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6_3"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "happiness"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:28] 5 12 14 39 49 62 79 98 2 15 ...
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6_4"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "noch wat"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:3] 7 58 73
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6_97"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "Others"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6_99"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "No answer"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6test_1"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "love"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num 1
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6test_2"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "joy"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6test_3"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "happiness"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6test_4"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "noch wat"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6test_97"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "Others"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6test_99"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "No answer"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num 0
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n1"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:31] 7 17 23 51 58 65 67 73 74 91 ...
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n1"
      .. ..$ val_assign: num 2
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:41] 3 13 22 26 35 38 45 47 55 72 ...
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n1"
      .. ..$ val_assign: num 3
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:28] 5 12 14 39 49 62 79 98 2 15 ...
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n2"
      .. ..$ val_assign: num 4
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:3] 7 58 73
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n2"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n3"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n4"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n5"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n6"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n7"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n8"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n9"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 7
      .. ..$ var_ziel  : chr "q6n10"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named num [1:7] -2 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      .. ..$ init_val  : num -2
      ..$ :List of 2
      .. ..$ new_var: chr "x"
      .. ..$ new_val: chr "q1 == 2"
      ..$ :List of 3
      .. ..$ new_var  : chr "abc"
      .. ..$ new_val  : chr "7"
      .. ..$ condition: chr "q1 ==(*%$@ 1 |} q3 == 2"
      ..$ :List of 3
      .. ..$ new_var  : chr "kq5"
      .. ..$ new_val  : chr "7"
      .. ..$ condition: chr "q1 ==(*%$@ 1 |} q3 == 2"
      ..$ :List of 3
      .. ..$ new_var  : chr "kq6"
      .. ..$ new_val  : chr "8"
      .. ..$ condition: chr "q1 ==(*%$@ 1 |} q3 == 2"
      ..$ :List of 7
      .. ..$ orig_var: chr "q1"
      .. ..$ new_lab : chr "summarized variable"
      .. ..$ lb      : num [1:3] 1 3 4
      .. ..$ ub      : num [1:3] 2 3 5
      .. ..$ new_vals: num [1:3] 1 2 3
      .. ..$ new_labs: chr [1:3] "1-2" "3" "4-5"
      .. ..$ new_var : chr "kq1"
      ..$ :List of 7
      .. ..$ orig_var: chr "q3"
      .. ..$ new_lab : chr "summarized variable"
      .. ..$ lb      : num [1:3] 1 3 4
      .. ..$ ub      : num [1:3] 2 3 5
      .. ..$ new_vals: num [1:3] 1 2 3
      .. ..$ new_labs: chr [1:3] "1-2" "3" "4-5"
      .. ..$ new_var : chr "kq3"
      ..$ :List of 2
      .. ..$ split_var: chr "q2_renamed"
      .. ..$ by_var   : chr "kq1"
      ..$ :List of 2
      .. ..$ new_var: chr "n"
      .. ..$ new_val: chr "1"
      ..$ :List of 2
      .. ..$ orig_var: chr "n"
      .. ..$ new_lab : chr "my new label"
      ..$ :List of 4
      .. ..$ orig_var: chr "n"
      .. ..$ new_lab : chr "overwrite new label"
      .. ..$ new_vals: num [1:3] 1 2 3
      .. ..$ new_labs: chr [1:3] "also with" "value labels" "now"
      ..$ :List of 4
      .. ..$ orig_var  : chr "n"
      .. ..$ new_lab   : NULL
      .. ..$ vals_added: num 4
      .. ..$ labs_added: chr "added label"
      ..$ :List of 2
      .. ..$ orig_var: chr "q3"
      .. ..$ new_lab : chr "Almost same variable label for q3 and q5"
      ..$ :List of 2
      .. ..$ orig_var: chr "q5"
      .. ..$ new_lab : chr "Almost same variable label for q5 and q3"
      ..$ :List of 2
      .. ..$ new_var: chr "a1"
      .. ..$ new_val: chr "3"
      ..$ :List of 2
      .. ..$ new_var: chr "a2"
      .. ..$ new_val: chr "4"
      ..$ :List of 2
      .. ..$ orig_var: chr "a1"
      .. ..$ new_lab : chr "same variable label for a1 & a2"
      ..$ :List of 2
      .. ..$ orig_var: chr "a2"
      .. ..$ new_lab : chr "same variable label for a1 & a2"
      ..$ :List of 2
      .. ..$ orig_var: chr "q3"
      .. ..$ new_var : chr "q4_renamed"
      ..$ :List of 2
      .. ..$ new_var: chr "r_expr_var"
      .. ..$ new_val: chr "ifelse(q1 == 5, q3 * 10, q1 * 8) %>% haven::labelled(label = \"varlab\")"
      ..$ :List of 3
      .. ..$ variable_names: chr [1:2] "q1" "q2"
      .. ..$ merge_file    : chr "fake_survey.sav"
      .. ..$ id            : chr "id"
      ..$ :List of 2
      .. ..$ r_script: chr "example_R_function.R"
      .. ..$ fun_name: chr "calc_sum_of_k_vars"
      ..$ :List of 1
      .. ..$ r_code: chr "data.frame(a=1)"
      ..$ :List of 7
      .. ..$ orig_var: chr "q1"
      .. ..$ new_lab : chr "vl"
      .. ..$ lb      : num [1:5] 1 2 3 4 5
      .. ..$ ub      : num [1:5] NA NA NA NA NA
      .. ..$ new_vals: num [1:5] 1 2 2 2 2
      .. ..$ new_labs: chr [1:5] "a" "b" NA NA ...
      .. ..$ new_var : chr "kkq1"
      ..$ :List of 2
      .. ..$ new_var: chr "free2_var"
      .. ..$ new_val: chr "3"

