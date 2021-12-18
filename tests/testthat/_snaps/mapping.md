# command table is reproduced

    tibble [68 x 5] (S3: tbl_df/tbl/data.frame)
     $ sheet  : chr [1:68] "Config" "Label" "Label" "Variables" ...
     $ action : chr [1:68] "#RECNA" "#NEWVALL" "#SUMVAR" "#STR2NUM" ...
     $ row    : chr [1:68] NA "8" "23, 24, 25, 26, 27" "8" ...
     $ new_var: chr [1:68] NA "q2" "kq5" "q8" ...
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
      .. ..$ orig_var : chr "q5"
      .. ..$ new_lab  : chr "test"
      .. ..$ orig_vals: num [1:5] 1 2 3 4 5
      .. ..$ new_vals : num [1:5] 1 1 2 3 3
      .. ..$ new_labs : chr [1:5] "aaa" NA "bbb" "ccc" ...
      .. ..$ new_var  : chr "kq5"
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

# modified data is reproduced

    # A tibble: 100 x 50
              q1  q2_renamed       q3  q4_renamed       q5    id      q6 q7       q8
       <dbl+lbl>   <dbl+lbl> <dbl+lb>   <dbl+lbl> <dbl+lb> <dbl> <dbl+l> <chr> <dbl>
     1  3 [norm~  2 [no]     3 [norm~ 4 [much]     2 [a b~     1 3 [bla~ bla ~     2
     2  3 [norm~  1 [YES]    5 [very~ 4 [much]     5 [ver~     2 4 [bla~ bla ~     9
     3  1 [not ~  1 [YES]    3 [norm~ 2 [a bit]    5 [ver~     3 8 [bla~ bla ~     3
     4  3 [norm~ 99 [no ans~ 4 [much] 4 [much]     4 [muc~     4 5 [bla~ bla ~     3
     5  5 [very~ -2 [FILTER] 2 [a bi~ 3 [normal]   3 [nor~     5 7 [bla~ bla ~     9
     6  5 [very~ -2 [FILTER] 4 [much] 3 [normal]   2 [a b~     6 5 [bla~ bla ~     7
     7 99 [no a~  2 [no]     3 [norm~ 4 [much]    -2 [FIL~     7 9 [bla~ bla ~    10
     8  2 [a bi~  2 [no]     5 [very~ 2 [a bit]    1 [not~     8 6 [bla~ bla ~     1
     9 99 [no a~ 99 [no ans~ 1 [not ~ 1 [not at ~  2 [a b~     9 6 [bla~ bla ~     2
    10 99 [no a~  1 [YES]    1 [not ~ 1 [not at ~  4 [muc~    10 3 [bla~ bla ~     4
    # ... with 90 more rows, and 41 more variables: kq5 <dbl+lbl>, q6n <dbl+lbl>,
    #   q7n <dbl+lbl>, q6_1 <dbl+lbl>, q6_2 <dbl+lbl>, q6_3 <dbl+lbl>,
    #   q6_4 <dbl+lbl>, q6_97 <dbl+lbl>, q6_99 <dbl+lbl>, q6test_1 <dbl+lbl>,
    #   q6test_2 <dbl+lbl>, q6test_3 <dbl+lbl>, q6test_4 <dbl+lbl>,
    #   q6test_97 <dbl+lbl>, q6test_99 <dbl+lbl>, q6n1 <dbl+lbl>, q6n2 <dbl+lbl>,
    #   q6n3 <dbl+lbl>, q6n4 <dbl+lbl>, q6n5 <dbl+lbl>, q6n6 <dbl+lbl>,
    #   q6n7 <dbl+lbl>, q6n8 <dbl+lbl>, q6n9 <dbl+lbl>, q6n10 <dbl+lbl>, ...

# class object print is reproduced

    <apply_mods>
      Public:
        apply_all_s3_cmds: function () 
        apply_cmd_s3: function (x) 
        apply_one_cmd_r6: function (action, data) 
        calc_command_table: function () 
        clone: function (deep = FALSE) 
        dat: tbl_df, tbl, data.frame
        dat_mod: nonvec_safe, tbl_df, tbl, data.frame
        df_cmd: tbl_df, tbl, data.frame
        gen_command_table_raw: function () 
        initialize: function (dat = NULL, mapping_file) 
        mapping_file: /home/chief/R/datenanpassr/inst/extdata/mapping.xlsx
        mod_all: function () 
        params: list

# command blocks print is reproduced

    <command_block_rcrd[18]>
     [1] Label #SUMVA new_vr: kq5; org_vr: q5; new_lb: test; org_vl: 1, 2, 3, 4, 5; nw_vls: 1, 1, 2, 3, 3; nw_lbs: aaa, NA, bbb,...               
     [2] Free1 #COMP new_vr: x; new_vl: q1 == 2                                                                                                   
     [3] Free1 #IF new_vr: abc; new_vl: 7; condtn: q1 == 1 | q3 ...                                                                               
     [4] Free1 #IF new_vr: kq6; new_vl: 8; condtn: q3 == 1                                                                                        
     [5] Free1 #REC org_vr: q1; new_vr: kq1; new_lb: summarized va...; lb: 1, 3, 4; ub: 2, 3, 5; nw_vls: 1, 2, 3; nw_lbs: 1-2, 3, 4-5             
     [6] Free1 #REC org_vr: q3; new_vr: kq3; new_lb: summarized va...; lb: 1, 3, 4; ub: 2, 3, 5; nw_vls: 1, 2, 3; nw_lbs: 1-2, 3, 4-5             
     [7] Free1 #COMP new_vr: n; new_vl: 1                                                                                                         
     [8] Free1 #VARL org_vr: n; new_lb: my new label                                                                                              
     [9] Free1 #VALL org_vr: n; new_lb: overwrite new...; nw_vls: 1, 2, 3; nw_lbs: also with, va...                                               
    [10] Free1 #AVALL org_vr: n; new_lb: ; vls_dd: 4; lbs_dd: added label                                                                         
    [11] Free1 #VARL org_vr: q3; new_lb: Almost same v...                                                                                         
    [12] Free1 #VARL org_vr: q5; new_lb: Almost same v...                                                                                         
    [13] Free1 #COMP new_vr: a1; new_vl: 3                                                                                                        
    [14] Free1 #COMP new_vr: a2; new_vl: 4                                                                                                        
    [15] Free1 #VARL org_vr: a1; new_lb: same variable...                                                                                         
    [16] Free1 #VARL org_vr: a2; new_lb: same variable...                                                                                         
    [17] Free1 #REC org_vr: q1; new_vr: kkq1; new_lb: vl; lb: 1, 2, 3, 4, 5; ub: NA, NA, NA, N...; nw_vls: 1, 2, 2, 2, 2; nw_lbs: a, b, NA, NA, NA
    [18] Free2 #COMP new_vr: free2_var; new_vl: 3                                                                                                 

# s3 modified data print is reproduced

    # A tibble: 100 x 13
          q8    q9       kq5 x       abc   kq6       kq1     kq3       n    a1    a2
       <dbl> <dbl> <dbl+lbl> <lgl> <dbl> <dbl> <dbl+lbl> <dbl+l> <dbl+l> <dbl> <dbl>
     1     2    NA   1 [aaa] FALSE    NA    NA   2 [3]   2 [3]   1 [als~     3     4
     2     9    NA   3 [ccc] FALSE    NA    NA   2 [3]   3 [4-5] 1 [als~     3     4
     3     3    NA   3 [ccc] FALSE     7    NA   1 [1-2] 2 [3]   1 [als~     3     4
     4     3    NA   3 [ccc] FALSE    NA    NA   2 [3]   3 [4-5] 1 [als~     3     4
     5     9    NA   2 [bbb] FALSE     7    NA   3 [4-5] 1 [1-2] 1 [als~     3     4
     6     7    NA   1 [aaa] FALSE    NA    NA   3 [4-5] 3 [4-5] 1 [als~     3     4
     7    10    NA  NA       FALSE    NA    NA  NA       2 [3]   1 [als~     3     4
     8     1    NA   1 [aaa] TRUE     NA    NA   1 [1-2] 3 [4-5] 1 [als~     3     4
     9     2    NA   1 [aaa] FALSE    NA     8  NA       1 [1-2] 1 [als~     3     4
    10     4    NA   3 [ccc] FALSE    NA     8  NA       1 [1-2] 1 [als~     3     4
    # ... with 90 more rows, and 2 more variables: kkq1 <dbl+lbl>, free2_var <dbl>

