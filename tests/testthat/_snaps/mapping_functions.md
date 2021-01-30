# mapping function reproduces snapshot

    tibble [100 x 44] (S3: tbl_df/tbl/data.frame)
     $ q2_renamed: dbl+lbl [1:100]  2,  1,  1, 99, -2, -2,  2,  2, 99,  1, 99,  2,  2, 99...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "Almost same variable label for q3 and q5"
     $ q3        : dbl+lbl [1:100]  3,  5,  3,  4,  2,  4,  3,  5,  1,  1,  5, 99,  4,  2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "Almost same variable label for q3 and q5"
     $ q4_renamed: dbl+lbl [1:100]  4,  4,  2,  4,  3,  3,  4,  2,  1,  1,  2, -2,  5,  2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "Almost same variable label for q3 and q5"
     $ q5        : dbl+lbl [1:100]  2,  5,  5,  4,  3,  2, -2,  1,  2,  4,  2,  5,  1, 99...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "Almost same variable label for q5 and q3"
     $ id        : dbl+lbl [1:100]  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14...
       ..@ labels: Named num -2
       .. ..- attr(*, "names")= chr "FILTER"
     $ q6        : chr [1:100] "bla bla bla love" "bla bla happiness" "bla joy" "bla bla joy" ...
      ..- attr(*, "label")= chr "Tell me something positive."
      ..- attr(*, "format.spss")= chr "A21"
     $ q7        : chr [1:100] "bla bla bla anger" "bla bla bla sadness" "bla bla bla sadness" "bla bla anger" ...
      ..- attr(*, "label")= chr "Tell me something negative."
      ..- attr(*, "format.spss")= chr "A19"
     $ kq1       : dbl+lbl [1:100]  2,  2,  1,  2,  3,  3, NA,  1, NA, NA,  3, NA,  2,  1...
       ..@ labels: Named num [1:3] 1 2 3
       .. ..- attr(*, "names")= chr [1:3] "1-2" "3" "4-5"
       ..@ label : chr "summarized variable"
     $ q6n       : dbl+lbl [1:100] 1, 3, 2, 2, 3, 2, 1, 1, 1, 1, 2, 3, 2, 3, 3, 1, 1, 3, ...
       ..@ labels: Named num [1:5] 1 2 3 97 99
       .. ..- attr(*, "names")= chr [1:5] "love" "joy" "happiness" "Others" ...
     $ q7n       : dbl+lbl [1:100] 3, 1, 1, 3, 2, 4, 1, 3, 1, 3, 2, 3, 1, 2, 4, 1, 4, 2, ...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "sadness" "fear" "anger" "pain" ...
     $ q6_1      : dbl+lbl [1:100]  1, NA, NA, NA, NA, NA,  1,  1,  1,  1, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "love"
     $ q6_2      : dbl+lbl [1:100] NA, NA,  1,  1, NA,  1, NA, NA, NA, NA,  1, NA,  1, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "joy"
     $ q6_3      : dbl+lbl [1:100] NA,  1, NA, NA,  1, NA, NA, NA, NA, NA, NA,  1, NA,  1...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "happiness"
     $ q6_4      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA,  1, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "noch wat"
     $ q6_97     : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "Others"
     $ q6_99     : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "No answer"
     $ q6test_1  : dbl+lbl [1:100]  1, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "love"
     $ q6test_2  : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "joy"
     $ q6test_3  : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "happiness"
     $ q6test_4  : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "noch wat"
     $ q6test_97 : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "Others"
     $ q6test_99 : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "No answer"
     $ q6n1      : dbl+lbl [1:100] 1, 3, 2, 2, 3, 2, 1, 1, 1, 1, 2, 3, 2, 3, 3, 1, 1, 3, ...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n2      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA,  4, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n3      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n4      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n5      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n6      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n7      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n8      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n9      : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ q6n10     : dbl+lbl [1:100] NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
     $ x         : num [1:100] 0 0 0 0 0 0 0 1 0 0 ...
     $ abc       : num [1:100] NA NA 7 NA 7 NA NA NA NA NA ...
     $ kq5       : num [1:100] NA 7 7 NA NA NA NA NA NA 7 ...
     $ kq6       : num [1:100] NA NA NA NA NA NA NA NA 8 8 ...
     $ kq3       : dbl+lbl [1:100]  2,  3,  2,  3,  1,  3,  2,  3,  1,  1,  3, NA,  3,  1...
       ..@ labels: Named num [1:3] 1 2 3
       .. ..- attr(*, "names")= chr [1:3] "1-2" "3" "4-5"
       ..@ label : chr "summarized variable"
     $ n         : dbl+lbl [1:100] 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
       ..@ labels: Named num [1:4] 1 2 3 4
       .. ..- attr(*, "names")= chr [1:4] "also with" "value labels" "now" "added label"
       ..@ label : chr NA
     $ a1        : dbl+lbl [1:100] 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, ...
       ..@ label: chr "same variable label for a1 & a2"
     $ a2        : dbl+lbl [1:100] 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, ...
       ..@ label: chr "same variable label for a1 & a2"
     $ r_expr_var: num [1:100] 24 24 8 24 20 40 792 16 792 792 ...
     $ q1        : dbl+lbl [1:100]  3,  3,  1,  3,  5,  5, 99,  2, 99, 99,  4, 99,  3,  1...
       ..@ label      : chr "How much do you like the product?"
       ..@ format.spss: chr "F8.2"
       ..@ labels     : Named num [1:6] 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:6] "not at all" "a bit" "normal" "much" ...
     $ q2        : dbl+lbl [1:100]  2,  1,  1, 99, NA, NA,  2,  2, 99,  1, 99,  2,  2, 99...
       ..@ label      : chr "Do you want to recommend the product?"
       ..@ format.spss: chr "F8.2"
       ..@ labels     : Named num [1:3] 1 2 99
       .. ..- attr(*, "names")= chr [1:3] "yes" "no" "no answer"
     $ free2_var : num [1:100] 3 3 3 3 3 3 3 3 3 3 ...

# mapp_cmd_table() reproduces snapshot

    tibble [58 x 5] (S3: rowwise_df/tbl_df/tbl/data.frame)
     $ sheet  : chr [1:58] "Label" "Variables" "Variables" "Variables" ...
     $ action : chr [1:58] "#SUMVAR" "#RENAME" "#NEWLAB" "#NEWLAB" ...
     $ row    : chr [1:58] "2, 3, 4, 5, 6" "3, 5" "2" "3" ...
     $ new_var: chr [1:58] "kq1" "q2_renamed, q4_renamed" "q1" "q2_renamed" ...
     $ data   :List of 58
      ..$ :List of 6
      .. ..$ new_var  : chr "kq1"
      .. ..$ orig_var : chr "q1"
      .. ..$ new_lab  : chr "test"
      .. ..$ orig_vals: num [1:5] 1 2 3 4 5
      .. ..$ new_vals : num [1:5] 1 1 2 3 3
      .. ..$ new_labs : chr [1:5] "aaa" NA "bbb" "ccc" ...
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
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:5] 1 2 3 97 99
      .. .. ..- attr(*, "names")= chr [1:5] "love" "joy" "happiness" "Others" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:31] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n"
      .. ..$ val_assign: num 2
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:5] 1 2 3 97 99
      .. .. ..- attr(*, "names")= chr [1:5] "love" "joy" "happiness" "Others" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:41] 3 13 22 26 35 38 45 47 55 72 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n"
      .. ..$ val_assign: num 3
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:5] 1 2 3 97 99
      .. .. ..- attr(*, "names")= chr [1:5] "love" "joy" "happiness" "Others" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:28] 5 12 14 39 49 62 79 98 2 15 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q7n"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "sadness" "fear" "anger" "pain" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:19] 77 87 7 9 13 16 32 48 59 79 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q7n"
      .. ..$ val_assign: num 2
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "sadness" "fear" "anger" "pain" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:27] 5 11 19 29 41 46 51 57 61 63 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q7n"
      .. ..$ val_assign: num 3
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "sadness" "fear" "anger" "pain" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:29] 1 28 30 36 40 60 72 83 85 95 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q7n"
      .. ..$ val_assign: num 4
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "sadness" "fear" "anger" "pain" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:25] 6 15 23 27 44 45 49 56 66 69 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6_1"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "love"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:31] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6_2"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "joy"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:41] 3 13 22 26 35 38 45 47 55 72 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6_3"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "happiness"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:28] 5 12 14 39 49 62 79 98 2 15 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6_4"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "noch wat"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:3] 7 58 73
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6_97"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "Others"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6_99"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "No answer"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6test_1"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "love"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num 1
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6test_2"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "joy"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6test_3"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "happiness"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6test_4"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "noch wat"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6test_97"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "Others"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6test_99"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : chr "No answer"
      .. ..$ vallab    : Named num [1:2] 0 1
      .. .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
      .. ..$ id        : chr "id"
      .. ..$ id_list   : NULL
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n1"
      .. ..$ val_assign: num 1
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:31] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n1"
      .. ..$ val_assign: num 2
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:41] 3 13 22 26 35 38 45 47 55 72 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n1"
      .. ..$ val_assign: num 3
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:28] 5 12 14 39 49 62 79 98 2 15 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n2"
      .. ..$ val_assign: num 4
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:3] 7 58 73
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n2"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:97] 17 23 51 65 67 74 91 100 3 13 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n3"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:100] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n4"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:100] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n5"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:100] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n6"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:100] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n7"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:100] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n8"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:100] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n9"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:100] 7 17 23 51 58 65 67 73 74 91 ...
      ..$ :List of 6
      .. ..$ var_ziel  : chr "q6n10"
      .. ..$ val_assign: num NA
      .. ..$ varlab    : NULL
      .. ..$ vallab    : Named int [1:6] 1 2 3 4 97 99
      .. .. ..- attr(*, "names")= chr [1:6] "love" "joy" "happiness" "noch wat" ...
      .. ..$ id        : chr "id"
      .. ..$ id_list   : num [1:100] 7 17 23 51 58 65 67 73 74 91 ...
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
      .. ..$ new_var : chr "kq1"
      .. ..$ orig_var: chr "q1"
      .. ..$ new_lab : chr "summarized variable"
      .. ..$ lb      : num [1:3] 1 3 4
      .. ..$ ub      : num [1:3] 2 3 5
      .. ..$ new_vals: num [1:3] 1 2 3
      .. ..$ new_labs: chr [1:3] "1-2" "3" "4-5"
      ..$ :List of 7
      .. ..$ new_var : chr "kq3"
      .. ..$ orig_var: chr "q3"
      .. ..$ new_lab : chr "summarized variable"
      .. ..$ lb      : num [1:3] 1 3 4
      .. ..$ ub      : num [1:3] 2 3 5
      .. ..$ new_vals: num [1:3] 1 2 3
      .. ..$ new_labs: chr [1:3] "1-2" "3" "4-5"
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
      .. ..$ new_lab   : chr NA
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
      .. ..$ new_var : chr "q2_renamed"
      ..$ :List of 2
      .. ..$ orig_var: chr "q3"
      .. ..$ new_var : chr "q4_renamed"
      ..$ :List of 2
      .. ..$ new_var: chr "r_expr_var"
      .. ..$ new_val: chr "ifelse(q1 == 5, q3 * 10, q1 * 8) %>% haven::labelled(label = \"varlab\")"
      ..$ :List of 3
      .. ..$ variable_names: chr [1:2] "q1" "q2"
      .. ..$ id            : chr "id"
      .. ..$ merge_file    : chr "/home/chief/R/datenanpassr/inst/extdata/fake_survey.sav"
      ..$ :List of 2
      .. ..$ new_var: chr "free2_var"
      .. ..$ new_val: chr "3"
     - attr(*, "groups")= tibble [58 x 1] (S3: tbl_df/tbl/data.frame)
      ..$ .rows: list<int> [1:58] 
      .. ..$ : int 1
      .. ..$ : int 2
      .. ..$ : int 3
      .. ..$ : int 4
      .. ..$ : int 5
      .. ..$ : int 6
      .. ..$ : int 7
      .. ..$ : int 8
      .. ..$ : int 9
      .. ..$ : int 10
      .. ..$ : int 11
      .. ..$ : int 12
      .. ..$ : int 13
      .. ..$ : int 14
      .. ..$ : int 15
      .. ..$ : int 16
      .. ..$ : int 17
      .. ..$ : int 18
      .. ..$ : int 19
      .. ..$ : int 20
      .. ..$ : int 21
      .. ..$ : int 22
      .. ..$ : int 23
      .. ..$ : int 24
      .. ..$ : int 25
      .. ..$ : int 26
      .. ..$ : int 27
      .. ..$ : int 28
      .. ..$ : int 29
      .. ..$ : int 30
      .. ..$ : int 31
      .. ..$ : int 32
      .. ..$ : int 33
      .. ..$ : int 34
      .. ..$ : int 35
      .. ..$ : int 36
      .. ..$ : int 37
      .. ..$ : int 38
      .. ..$ : int 39
      .. ..$ : int 40
      .. ..$ : int 41
      .. ..$ : int 42
      .. ..$ : int 43
      .. ..$ : int 44
      .. ..$ : int 45
      .. ..$ : int 46
      .. ..$ : int 47
      .. ..$ : int 48
      .. ..$ : int 49
      .. ..$ : int 50
      .. ..$ : int 51
      .. ..$ : int 52
      .. ..$ : int 53
      .. ..$ : int 54
      .. ..$ : int 55
      .. ..$ : int 56
      .. ..$ : int 57
      .. ..$ : int 58
      .. ..@ ptype: int(0) 
     - attr(*, "id_var")= chr "id"

