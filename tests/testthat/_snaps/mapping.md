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
      .. ..$ condition: chr "q1 == 1 | q3 == 2"
      ..$ :List of 3
      .. ..$ new_var  : chr "kq5"
      .. ..$ new_val  : chr "7"
      .. ..$ condition: chr "q2_renamed == 1"
      ..$ :List of 3
      .. ..$ new_var  : chr "kq6"
      .. ..$ new_val  : chr "8"
      .. ..$ condition: chr "q3 == 1"
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
      .. ..$ new_val: chr "haven::labelled(ifelse(q1 == 5, q3 * 10, q1 * 8), label = \"varlab\")"
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

    # A tibble: 100 x 52
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
    # ... with 90 more rows, and 43 more variables: kq5 <dbl+lbl>, q6n <dbl+lbl>,
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
        apply_cmd_s3_safe: function (x) 
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

    <command_block_rcrd[67]>
     [1] Config #RECNA rcd_n_: id, DC_ID; rplc_v: -2; rplc_l: FILTER                                                                              
     [2] Label #NEWVA org_vr: q2; vls_dd: 1; lbs_dd: YES                                                                                          
     [3] Label #SUMVA new_vr: kq5; org_vr: q5; new_lb: test; org_vl: 1, 2, 3, 4, 5; nw_vls: 1, 1, 2, 3, 3; nw_lbs: aaa, NA, bbb,...               
     [4] Varbls #STR2N var: q8                                                                                                                    
     [5] Varbls #AUTOR var: q6                                                                                                                    
     [6] Varbls #DROP org_vr: q9                                                                                                                  
     [7] Varbls #RENAM org_vr: q2, q4; nw_nms: q2_renamed, q...                                                                                   
     [8] Varbls #NEWLA org_vr: q1; nw_lbl: Like Product                                                                                           
     [9] Varbls #NEWLA org_vr: q2_renamed; nw_lbl: recommend pro...                                                                               
    [10] Varbls #NEWLA org_vr: q5; nw_lbl: Like best friend                                                                                       
    [11] Varbls #NEWLA org_vr: q8; nw_lbl: Now the varia...                                                                                       
    [12] Vrbtms #vrbtm var_zl: q6n; vl_ssg: 1; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 7, 17, 23, 51...; int_vl: NA                           
    [13] Vrbtms #vrbtm var_zl: q6n; vl_ssg: 2; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 3, 13, 22, 26...; int_vl: NA                           
    [14] Vrbtms #vrbtm var_zl: q6n; vl_ssg: 3; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 5, 12, 14, 39...; int_vl: NA                           
    [15] Vrbtms #vrbtm var_zl: q6n; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: NA                                          
    [16] Vrbtms #vrbtm var_zl: q7n; vl_ssg: 1; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 77, 87, 7, 9,...; int_vl: NA                           
    [17] Vrbtms #vrbtm var_zl: q7n; vl_ssg: 2; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 5, 11, 19, 29...; int_vl: NA                           
    [18] Vrbtms #vrbtm var_zl: q7n; vl_ssg: 3; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 1, 28, 30, 36...; int_vl: NA                           
    [19] Vrbtms #vrbtm var_zl: q7n; vl_ssg: 4; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 6, 15, 23, 27...; int_vl: NA                           
    [20] Vrbtms #vrbtm var_zl: q6_1; vl_ssg: 1; varlab: love; vallab: 0, 1; id_lst: 7, 17, 23, 51...; int_vl: 0                                   
    [21] Vrbtms #vrbtm var_zl: q6_2; vl_ssg: 1; varlab: joy; vallab: 0, 1; id_lst: 3, 13, 22, 26...; int_vl: 0                                    
    [22] Vrbtms #vrbtm var_zl: q6_3; vl_ssg: 1; varlab: happiness; vallab: 0, 1; id_lst: 5, 12, 14, 39...; int_vl: 0                              
    [23] Vrbtms #vrbtm var_zl: q6_4; vl_ssg: 1; varlab: noch wat; vallab: 0, 1; id_lst: 7, 58, 73; int_vl: 0                                      
    [24] Vrbtms #vrbtm var_zl: q6_97; vl_ssg: 1; varlab: Others; vallab: 0, 1; id_lst: ; int_vl: 0                                                
    [25] Vrbtms #vrbtm var_zl: q6_99; vl_ssg: 1; varlab: No answer; vallab: 0, 1; id_lst: ; int_vl: 0                                             
    [26] Vrbtms #vrbtm var_zl: q6test_1; vl_ssg: 1; varlab: love; vallab: 0, 1; id_lst: 1; int_vl: 0                                              
    [27] Vrbtms #vrbtm var_zl: q6test_2; vl_ssg: 1; varlab: joy; vallab: 0, 1; id_lst: ; int_vl: 0                                                
    [28] Vrbtms #vrbtm var_zl: q6test_3; vl_ssg: 1; varlab: happiness; vallab: 0, 1; id_lst: ; int_vl: 0                                          
    [29] Vrbtms #vrbtm var_zl: q6test_4; vl_ssg: 1; varlab: noch wat; vallab: 0, 1; id_lst: ; int_vl: 0                                           
    [30] Vrbtms #vrbtm var_zl: q6test_97; vl_ssg: 1; varlab: Others; vallab: 0, 1; id_lst: ; int_vl: 0                                            
    [31] Vrbtms #vrbtm var_zl: q6test_99; vl_ssg: 1; varlab: No answer; vallab: 0, 1; id_lst: ; int_vl: 0                                         
    [32] Vrbtms #vrbtm var_zl: q6n1; vl_ssg: 1; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 7, 17, 23, 51...; int_vl: -2                          
    [33] Vrbtms #vrbtm var_zl: q6n1; vl_ssg: 2; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 3, 13, 22, 26...; int_vl: -2                          
    [34] Vrbtms #vrbtm var_zl: q6n1; vl_ssg: 3; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 5, 12, 14, 39...; int_vl: -2                          
    [35] Vrbtms #vrbtm var_zl: q6n2; vl_ssg: 4; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: 7, 58, 73; int_vl: -2                                 
    [36] Vrbtms #vrbtm var_zl: q6n2; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                         
    [37] Vrbtms #vrbtm var_zl: q6n3; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                         
    [38] Vrbtms #vrbtm var_zl: q6n4; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                         
    [39] Vrbtms #vrbtm var_zl: q6n5; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                         
    [40] Vrbtms #vrbtm var_zl: q6n6; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                         
    [41] Vrbtms #vrbtm var_zl: q6n7; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                         
    [42] Vrbtms #vrbtm var_zl: q6n8; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                         
    [43] Vrbtms #vrbtm var_zl: q6n9; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                         
    [44] Vrbtms #vrbtm var_zl: q6n10; vl_ssg: NA; varlab: ; vallab: -2, 1, 2, 3, ...; id_lst: ; int_vl: -2                                        
    [45] Free1 #COMP new_vr: x; new_vl: q1 == 2                                                                                                   
    [46] Free1 #IF new_vr: abc; new_vl: 7; condtn: q1 == 1 | q3 ...                                                                               
    [47] Free1 #IF new_vr: kq5; new_vl: 7; condtn: q2_renamed == 1                                                                                
    [48] Free1 #IF new_vr: kq6; new_vl: 8; condtn: q3 == 1                                                                                        
    [49] Free1 #REC org_vr: q1; new_vr: kq1; new_lb: summarized va...; lb: 1, 3, 4; ub: 2, 3, 5; nw_vls: 1, 2, 3; nw_lbs: 1-2, 3, 4-5             
    [50] Free1 #REC org_vr: q3; new_vr: kq3; new_lb: summarized va...; lb: 1, 3, 4; ub: 2, 3, 5; nw_vls: 1, 2, 3; nw_lbs: 1-2, 3, 4-5             
    [51] Free1 #KG splt_v: q2_renamed; by_var: kq1                                                                                                
    [52] Free1 #COMP new_vr: n; new_vl: 1                                                                                                         
    [53] Free1 #VARL org_vr: n; new_lb: my new label                                                                                              
    [54] Free1 #VALL org_vr: n; new_lb: overwrite new...; nw_vls: 1, 2, 3; nw_lbs: also with, va...                                               
    [55] Free1 #AVALL org_vr: n; new_lb: ; vls_dd: 4; lbs_dd: added label                                                                         
    [56] Free1 #VARL org_vr: q3; new_lb: Almost same v...                                                                                         
    [57] Free1 #VARL org_vr: q5; new_lb: Almost same v...                                                                                         
    [58] Free1 #COMP new_vr: a1; new_vl: 3                                                                                                        
    [59] Free1 #COMP new_vr: a2; new_vl: 4                                                                                                        
    [60] Free1 #VARL org_vr: a1; new_lb: same variable...                                                                                         
    [61] Free1 #VARL org_vr: a2; new_lb: same variable...                                                                                         
    [62] Free1 #DIC org_vr: q3; new_vr: q4_renamed                                                                                                
    [63] Free1 #COMPR new_vr: r_expr_var; new_vl: haven::labell...                                                                                
    [64] Free1 #RFUN r_scrp: /home/chief/R...; fun_nm: calc_sum_of_k...                                                                           
    [65] Free1 #R r_code: data.frame(a=1)                                                                                                         
    [66] Free1 #REC org_vr: q1; new_vr: kkq1; new_lb: vl; lb: 1, 2, 3, 4, 5; ub: NA, NA, NA, N...; nw_vls: 1, 2, 2, 2, 2; nw_lbs: a, b, NA, NA, NA
    [67] Free2 #COMP new_vr: free2_var; new_vl: 3                                                                                                 

# s3 modified data print is reproduced

    # A tibble: 100 x 52
                    q1     q2_renamed             q3     q4_renamed              q5
             <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>       <dbl+lbl>
     1  3 [normal]      2 [no]        3 [normal]     4 [much]        2 [a bit]     
     2  3 [normal]      1 [YES]       5 [very much]  4 [much]        5 [very much] 
     3  1 [not at all]  1 [YES]       3 [normal]     2 [a bit]       5 [very much] 
     4  3 [normal]     99 [no answer] 4 [much]       4 [much]        4 [much]      
     5  5 [very much]  -2 [FILTER]    2 [a bit]      3 [normal]      3 [normal]    
     6  5 [very much]  -2 [FILTER]    4 [much]       3 [normal]      2 [a bit]     
     7 99 [no answer]   2 [no]        3 [normal]     4 [much]       -2 [FILTER]    
     8  2 [a bit]       2 [no]        5 [very much]  2 [a bit]       1 [not at all]
     9 99 [no answer]  99 [no answer] 1 [not at all] 1 [not at all]  2 [a bit]     
    10 99 [no answer]   1 [YES]       1 [not at all] 1 [not at all]  4 [much]      
          id                    q6 q7                         q8       kq5
       <dbl>             <dbl+lbl> <chr>               <dbl+lbl> <dbl+lbl>
     1     1 3 [bla bla bla love]  bla bla bla anger           2   1 [aaa]
     2     2 4 [bla bla happiness] bla bla bla sadness         9   7      
     3     3 8 [bla joy]           bla bla bla sadness         3   7      
     4     4 5 [bla bla joy]       bla bla anger               3   3 [ccc]
     5     5 7 [bla happiness]     bla fear                    9   2 [bbb]
     6     6 5 [bla bla joy]       bla pain                    7   1 [aaa]
     7     7 9 [bla love]          bla bla sadness            10  NA      
     8     8 6 [bla bla love]      bla bla anger               1   1 [aaa]
     9     9 6 [bla bla love]      bla bla sadness             2   1 [aaa]
    10    10 3 [bla bla bla love]  bla bla anger               4   7      
                 q6n         q7n           q6_1           q6_2           q6_3
           <dbl+lbl>   <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>
     1 1 [love]      3 [anger]   1 [selected]   0 [unselected] 0 [unselected]
     2 3 [happiness] 1 [sadness] 0 [unselected] 0 [unselected] 1 [selected]  
     3 2 [joy]       1 [sadness] 0 [unselected] 1 [selected]   0 [unselected]
     4 2 [joy]       3 [anger]   0 [unselected] 1 [selected]   0 [unselected]
     5 3 [happiness] 2 [fear]    0 [unselected] 0 [unselected] 1 [selected]  
     6 2 [joy]       4 [pain]    0 [unselected] 1 [selected]   0 [unselected]
     7 1 [love]      1 [sadness] 1 [selected]   0 [unselected] 0 [unselected]
     8 1 [love]      3 [anger]   1 [selected]   0 [unselected] 0 [unselected]
     9 1 [love]      1 [sadness] 1 [selected]   0 [unselected] 0 [unselected]
    10 1 [love]      3 [anger]   1 [selected]   0 [unselected] 0 [unselected]
                 q6_4          q6_97          q6_99       q6test_1       q6test_2
            <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>
     1 0 [unselected] 0 [unselected] 0 [unselected] 1 [selected]   0 [unselected]
     2 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     3 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     4 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     5 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     6 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     7 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     8 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     9 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
    10 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
             q6test_3       q6test_4      q6test_97      q6test_99          q6n1
            <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>     <dbl+lbl>
     1 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 1 [love]     
     2 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 3 [happiness]
     3 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 2 [joy]      
     4 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 2 [joy]      
     5 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 3 [happiness]
     6 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 2 [joy]      
     7 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 1 [love]     
     8 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 1 [love]     
     9 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 1 [love]     
    10 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 1 [love]     
                q6n2        q6n3        q6n4        q6n5        q6n6        q6n7
           <dbl+lbl>   <dbl+lbl>   <dbl+lbl>   <dbl+lbl>   <dbl+lbl>   <dbl+lbl>
     1 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     2 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     3 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     4 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     5 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     6 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     7  4 [noch wat] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     8 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     9 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
    10 -2 [FILTER]   -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
              q6n8        q6n9       q6n10     x   abc   kq6       kq1       kq3
         <dbl+lbl>   <dbl+lbl>   <dbl+lbl> <int> <dbl> <dbl> <dbl+lbl> <dbl+lbl>
     1 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0    NA    NA   2 [3]     2 [3]  
     2 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0    NA    NA   2 [3]     3 [4-5]
     3 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0     7    NA   1 [1-2]   2 [3]  
     4 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0    NA    NA   2 [3]     3 [4-5]
     5 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0     7    NA   3 [4-5]   1 [1-2]
     6 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0    NA    NA   3 [4-5]   3 [4-5]
     7 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0    NA    NA  NA         2 [3]  
     8 -2 [FILTER] -2 [FILTER] -2 [FILTER]     1    NA    NA   1 [1-2]   3 [4-5]
     9 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0    NA     8  NA         1 [1-2]
    10 -2 [FILTER] -2 [FILTER] -2 [FILTER]     0    NA     8  NA         1 [1-2]
       kq1xq2_renamedkminus20 kq1xq2_renamedk10 kq1xq2_renamedk20 kq1xq2_renamedk990
                    <dbl+lbl>         <dbl+lbl>         <dbl+lbl>          <dbl+lbl>
     1               NA                NA                 2 [3]               NA    
     2               NA                 2 [3]            NA                   NA    
     3               NA                 1 [1-2]          NA                   NA    
     4               NA                NA                NA                    2 [3]
     5                3 [4-5]          NA                NA                   NA    
     6                3 [4-5]          NA                NA                   NA    
     7               NA                NA                NA                   NA    
     8               NA                NA                 1 [1-2]             NA    
     9               NA                NA                NA                   NA    
    10               NA                NA                NA                   NA    
                   n        a1        a2 r_expr_var             q2 sum_of_k_vars
           <dbl+lbl> <dbl+lbl> <dbl+lbl>  <dbl+lbl>      <dbl+lbl>         <dbl>
     1 1 [also with]         3         4         24  2 [no]                    7
     2 1 [also with]         3         4         24  1 [yes]                  14
     3 1 [also with]         3         4          8  1 [yes]                  11
     4 1 [also with]         3         4         24 99 [no answer]            10
     5 1 [also with]         3         4         20 NA                         9
     6 1 [also with]         3         4         40 NA                        10
     7 1 [also with]         3         4        792  2 [no]                    2
     8 1 [also with]         3         4         16  2 [no]                    6
     9 1 [also with]         3         4        792 99 [no answer]            10
    10 1 [also with]         3         4        792  1 [yes]                  16
           a      kkq1 free2_var
       <dbl> <dbl+lbl>     <dbl>
     1     1     2 [b]         3
     2     1     2 [b]         3
     3     1     1 [a]         3
     4     1     2 [b]         3
     5     1     2 [b]         3
     6     1     2 [b]         3
     7     1    NA             3
     8     1     2 [b]         3
     9     1    NA             3
    10     1    NA             3
    # ... with 90 more rows

# error list print is reproduced

    [1] "<text>:1:7: unexpected '*'\n1: q1 ==(*\n          ^"
    [2] "<text>:1:7: unexpected '*'\n1: q1 ==(*\n          ^"
    [3] "<text>:1:7: unexpected '*'\n1: q1 ==(*\n          ^"

# error string elements were added to the erroneous command blocks

    [1] "<text>:1:7: unexpected '*'\n1: q1 ==(*\n          ^"
    [2] "<text>:1:7: unexpected '*'\n1: q1 ==(*\n          ^"
    [3] "<text>:1:7: unexpected '*'\n1: q1 ==(*\n          ^"

