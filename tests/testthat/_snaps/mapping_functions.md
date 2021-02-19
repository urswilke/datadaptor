# result of the mapping function mapp_xl_to_data()

    # A tibble: 100 x 54
             q1 q2_renamed      q3 q4_renamed       q5    id q6    q7         kq1
       <dbl+lb>  <dbl+lbl> <dbl+l>  <dbl+lbl> <dbl+lb> <dbl> <chr> <chr> <dbl+lb>
     1  3 [nor~  2 [no]    3 [nor~ 4 [much]    2 [a b~     1 bla ~ bla ~  2 [3]  
     2  3 [nor~  1 [YES]   5 [ver~ 4 [much]    5 [ver~     2 bla ~ bla ~  2 [3]  
     3  1 [not~  1 [YES]   3 [nor~ 2 [a bit]   5 [ver~     3 bla ~ bla ~  1 [1-2]
     4  3 [nor~ 99 [no an~ 4 [muc~ 4 [much]    4 [muc~     4 bla ~ bla ~  2 [3]  
     5  5 [ver~ -2 [FILTE~ 2 [a b~ 3 [normal]  3 [nor~     5 bla ~ bla ~  3 [4-5]
     6  5 [ver~ -2 [FILTE~ 4 [muc~ 3 [normal]  2 [a b~     6 bla ~ bla ~  3 [4-5]
     7 99 [no ~  2 [no]    3 [nor~ 4 [much]   -2 [FIL~     7 bla ~ bla ~ NA      
     8  2 [a b~  2 [no]    5 [ver~ 2 [a bit]   1 [not~     8 bla ~ bla ~  1 [1-2]
     9 99 [no ~ 99 [no an~ 1 [not~ 1 [not at~  2 [a b~     9 bla ~ bla ~ NA      
    10 99 [no ~  1 [YES]   1 [not~ 1 [not at~  4 [muc~    10 bla ~ bla ~ NA      
    # ... with 90 more rows, and 45 more variables: q6n <dbl+lbl>, q7n <dbl+lbl>,
    #   q6_1 <dbl+lbl>, q6_2 <dbl+lbl>, q6_3 <dbl+lbl>, q6_4 <dbl+lbl>,
    #   q6_97 <dbl+lbl>, q6_99 <dbl+lbl>, q6test_1 <dbl+lbl>, q6test_2 <dbl+lbl>,
    #   q6test_3 <dbl+lbl>, q6test_4 <dbl+lbl>, q6test_97 <dbl+lbl>,
    #   q6test_99 <dbl+lbl>, q6n1 <dbl+lbl>, q6n2 <dbl+lbl>, q6n3 <dbl+lbl>,
    #   q6n4 <dbl+lbl>, q6n5 <dbl+lbl>, q6n6 <dbl+lbl>, q6n7 <dbl+lbl>,
    #   q6n8 <dbl+lbl>, q6n9 <dbl+lbl>, q6n10 <dbl+lbl>, x <dbl>, abc <dbl>,
    #   kq5 <dbl>, kq6 <dbl>, kq3 <dbl+lbl>, q1xq2_renamed_minus2 <dbl+lbl>,
    #   q1xq2_renamed_1 <dbl+lbl>, q1xq2_renamed_2 <dbl+lbl>,
    #   q1xq2_renamed_99 <dbl+lbl>, q3xq2_renamed_minus2 <dbl+lbl>,
    #   q3xq2_renamed_1 <dbl+lbl>, q3xq2_renamed_2 <dbl+lbl>,
    #   q3xq2_renamed_99 <dbl+lbl>, n <dbl+lbl>, a1 <dbl+lbl>, a2 <dbl+lbl>,
    #   r_expr_var <dbl>, q2 <dbl+lbl>, sum_of_k_vars <dbl>, a <dbl>,
    #   free2_var <dbl>

---

    tibble [100 x 54] (S3: tbl_df/tbl/data.frame)
     $ q1                  : dbl+lbl [1:100]  3,  3,  1,  3,  5,  5, 99,  2, 99, 99,  4, 99,  3,  1...
       ..@ label      : chr "How much do you like the product?"
       ..@ format.spss: chr "F8.2"
       ..@ labels     : Named num [1:6] 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:6] "not at all" "a bit" "normal" "much" ...
     $ q2_renamed          : dbl+lbl [1:100]  2,  1,  1, 99, -2, -2,  2,  2, 99,  1, 99,  2,  2, 99...
       ..@ labels: Named num [1:4] -2 1 2 99
       .. ..- attr(*, "names")= chr [1:4] "FILTER" "YES" "no" "no answer"
       ..@ label : chr "recommend product"
     $ q3                  : dbl+lbl [1:100]  3,  5,  3,  4,  2,  4,  3,  5,  1,  1,  5, 99,  4,  2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "Almost same variable label for q3 and q5"
     $ q4_renamed          : dbl+lbl [1:100]  4,  4,  2,  4,  3,  3,  4,  2,  1,  1,  2, -2,  5,  2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "Almost same variable label for q3 and q5"
     $ q5                  : dbl+lbl [1:100]  2,  5,  5,  4,  3,  2, -2,  1,  2,  4,  2,  5,  1, 99...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "Almost same variable label for q5 and q3"
     $ id                  : num [1:100] 1 2 3 4 5 6 7 8 9 10 ...
      ..- attr(*, "format.spss")= chr "F8.0"
     $ q6                  : chr [1:100] "bla bla bla love" "bla bla happiness" "bla joy" "bla bla joy" ...
      ..- attr(*, "label")= chr "Tell me something positive."
      ..- attr(*, "format.spss")= chr "A21"
     $ q7                  : chr [1:100] "bla bla bla anger" "bla bla bla sadness" "bla bla bla sadness" "bla bla anger" ...
      ..- attr(*, "label")= chr "Tell me something negative."
      ..- attr(*, "format.spss")= chr "A19"
     $ kq1                 : dbl+lbl [1:100]  2,  2,  1,  2,  3,  3, NA,  1, NA, NA,  3, NA,  2,  1...
       ..@ labels: Named num [1:3] 1 2 3
       .. ..- attr(*, "names")= chr [1:3] "1-2" "3" "4-5"
       ..@ label : chr "summarized variable"
     $ q6n                 : dbl+lbl [1:100] 1, 3, 2, 2, 3, 2, 1, 1, 1, 1, 2, 3, 2, 3, 3, 1, 1, 3, ...
       ..@ labels: Named num [1:6] -2 1 2 3 97 99
       .. ..- attr(*, "names")= chr [1:6] "FILTER" "love" "joy" "happiness" ...
     $ q7n                 : dbl+lbl [1:100] 3, 1, 1, 3, 2, 4, 1, 3, 1, 3, 2, 3, 1, 2, 4, 1, 4, 2, ...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "sadness" "fear" "anger" ...
     $ q6_1                : dbl+lbl [1:100] 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "love"
     $ q6_2                : dbl+lbl [1:100] 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "joy"
     $ q6_3                : dbl+lbl [1:100] 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "happiness"
     $ q6_4                : dbl+lbl [1:100] 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "noch wat"
     $ q6_97               : dbl+lbl [1:100] 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "Others"
     $ q6_99               : dbl+lbl [1:100] 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "No answer"
     $ q6test_1            : dbl+lbl [1:100] 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "love"
     $ q6test_2            : dbl+lbl [1:100] 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "joy"
     $ q6test_3            : dbl+lbl [1:100] 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "happiness"
     $ q6test_4            : dbl+lbl [1:100] 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "noch wat"
     $ q6test_97           : dbl+lbl [1:100] 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "Others"
     $ q6test_99           : dbl+lbl [1:100] 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
       ..@ labels: Named num [1:2] 0 1
       .. ..- attr(*, "names")= chr [1:2] "unselected" "selected"
       ..@ label : chr "No answer"
     $ q6n1                : dbl+lbl [1:100] 1, 3, 2, 2, 3, 2, 1, 1, 1, 1, 2, 3, 2, 3, 3, 1, 1, 3, ...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n2                : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2,  4, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n3                : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n4                : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n5                : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n6                : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n7                : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n8                : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n9                : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ q6n10               : dbl+lbl [1:100] -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 97 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "love" "joy" "happiness" ...
     $ x                   : num [1:100] 0 0 0 0 0 0 0 1 0 0 ...
     $ abc                 : num [1:100] NA NA 7 NA 7 NA NA NA NA NA ...
     $ kq5                 : num [1:100] NA 7 7 NA NA NA NA NA NA 7 ...
     $ kq6                 : num [1:100] NA NA NA NA NA NA NA NA 8 8 ...
     $ kq3                 : dbl+lbl [1:100]  2,  3,  2,  3,  1,  3,  2,  3,  1,  1,  3, NA,  3,  1...
       ..@ labels: Named num [1:3] 1 2 3
       .. ..- attr(*, "names")= chr [1:3] "1-2" "3" "4-5"
       ..@ label : chr "summarized variable"
     $ q1xq2_renamed_minus2: dbl+lbl [1:100] NA, NA, NA, NA,  5,  5, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:6] "not at all" "a bit" "normal" "much" ...
       ..@ label : chr "recommend product - FILTER: Like Product"
     $ q1xq2_renamed_1     : dbl+lbl [1:100] NA,  3,  1, NA, NA, NA, NA, NA, NA, 99, NA, NA, NA, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:6] "not at all" "a bit" "normal" "much" ...
       ..@ label : chr "recommend product - YES: Like Product"
     $ q1xq2_renamed_2     : dbl+lbl [1:100]  3, NA, NA, NA, NA, NA, 99,  2, NA, NA, NA, 99,  3, NA...
       ..@ labels: Named num [1:6] 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:6] "not at all" "a bit" "normal" "much" ...
       ..@ label : chr "recommend product - no: Like Product"
     $ q1xq2_renamed_99    : dbl+lbl [1:100] NA, NA, NA,  3, NA, NA, NA, NA, 99, NA,  4, NA, NA,  1...
       ..@ labels: Named num [1:6] 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:6] "not at all" "a bit" "normal" "much" ...
       ..@ label : chr "recommend product - no answer: Like Product"
     $ q3xq2_renamed_minus2: dbl+lbl [1:100] NA, NA, NA, NA,  2,  4, NA, NA, NA, NA, NA, NA, NA, NA...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "recommend product - FILTER: How likely will you go dancing this weekend?"
     $ q3xq2_renamed_1     : dbl+lbl [1:100] NA,  5,  3, NA, NA, NA, NA, NA, NA,  1, NA, NA, NA, NA...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "recommend product - YES: How likely will you go dancing this weekend?"
     $ q3xq2_renamed_2     : dbl+lbl [1:100]  3, NA, NA, NA, NA, NA,  3,  5, NA, NA, NA, 99,  4, NA...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "recommend product - no: How likely will you go dancing this weekend?"
     $ q3xq2_renamed_99    : dbl+lbl [1:100] NA, NA, NA,  4, NA, NA, NA, NA,  1, NA,  5, NA, NA,  2...
       ..@ labels: Named num [1:7] -2 1 2 3 4 5 99
       .. ..- attr(*, "names")= chr [1:7] "FILTER" "not at all" "a bit" "normal" ...
       ..@ label : chr "recommend product - no answer: How likely will you go dancing this weekend?"
     $ n                   : dbl+lbl [1:100] 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
       ..@ labels: Named num [1:4] 1 2 3 4
       .. ..- attr(*, "names")= chr [1:4] "also with" "value labels" "now" "added label"
       ..@ label : chr "overwrite new label"
     $ a1                  : dbl+lbl [1:100] 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, ...
       ..@ label: chr "same variable label for a1 & a2"
     $ a2                  : dbl+lbl [1:100] 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, ...
       ..@ label: chr "same variable label for a1 & a2"
     $ r_expr_var          : num [1:100] 24 24 8 24 20 40 792 16 792 792 ...
     $ q2                  : dbl+lbl [1:100]  2,  1,  1, 99, NA, NA,  2,  2, 99,  1, 99,  2,  2, 99...
       ..@ label      : chr "Do you want to recommend the product?"
       ..@ format.spss: chr "F8.2"
       ..@ labels     : Named num [1:3] 1 2 99
       .. ..- attr(*, "names")= chr [1:3] "yes" "no" "no answer"
     $ sum_of_k_vars       : num [1:100] 4 12 10 5 4 6 2 4 9 16 ...
     $ a                   : num [1:100] 1 1 1 1 1 1 1 1 1 1 ...
     $ free2_var           : num [1:100] 3 3 3 3 3 3 3 3 3 3 ...

# result of mapp_cmd_table()

    tibble [64 x 5] (S3: tbl_df/tbl/data.frame)
     $ sheet  : chr [1:64] "Config" "Label" "Label" "Variables" ...
     $ action : chr [1:64] "#RECNA" "#NEWVALL" "#SUMVAR" "#RENAME" ...
     $ row    : chr [1:64] NA "8" "2, 3, 4, 5, 6" "3, 5" ...
     $ new_var: chr [1:64] NA "q2" "kq1" "q2_renamed, q4_renamed" ...
     $ data   :List of 64
      ..$ :List of 3
      .. ..$ recode_na_exceptions: chr [1:3] "q1" "id" "DC_ID"
      .. ..$ replace_val         : num -2
      .. ..$ replace_label       : chr "FILTER"
      ..$ :List of 3
      .. ..$ orig_var  : chr "q2"
      .. ..$ vals_added: num 1
      .. ..$ labs_added: chr "YES"
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
      .. ..$ split_var: chr "q2_renamed"
      .. ..$ by_var   : chr "q1"
      ..$ :List of 2
      .. ..$ split_var: chr "q2_renamed"
      .. ..$ by_var   : chr "q3"
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
      .. ..$ id            : chr "id"
      .. ..$ merge_file    : chr "fake_survey.sav"
      ..$ :List of 2
      .. ..$ r_script: chr "example_R_function.R"
      .. ..$ fun_name: chr "calc_sum_of_k_vars"
      ..$ :List of 1
      .. ..$ r_code: chr "df %>% dplyr::mutate(a=1)"
      ..$ :List of 2
      .. ..$ new_var: chr "free2_var"
      .. ..$ new_val: chr "3"
     - attr(*, "id_var")= chr "id"

