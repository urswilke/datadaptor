# main function reproduces snapshot

    # A tibble: 100 x 42
             q1 q2_renamed      q3 q4_renamed       q5    id q6    q7         kq1
       <dbl+lb>  <dbl+lbl> <dbl+l>  <dbl+lbl> <dbl+lb> <dbl> <chr> <chr> <dbl+lb>
     1  3 [nor~  2 [no]    3 [nor~ 4 [much]    2 [a b~     1 bla ~ bla ~  2 [bbb]
     2  3 [nor~  1 [yes]   5 [ver~ 4 [much]    5 [ver~     2 bla ~ bla ~  2 [bbb]
     3  1 [not~  1 [yes]   3 [nor~ 2 [a bit]   5 [ver~     3 bla ~ bla ~  1 [aaa]
     4  3 [nor~ 99 [no an~ 4 [muc~ 4 [much]    4 [muc~     4 bla ~ bla ~  2 [bbb]
     5  5 [ver~ -2 [FILTE~ 2 [a b~ 3 [normal]  3 [nor~     5 bla ~ bla ~  3 [ccc]
     6  5 [ver~ -2 [FILTE~ 4 [muc~ 3 [normal]  2 [a b~     6 bla ~ bla ~  3 [ccc]
     7 99 [no ~  2 [no]    3 [nor~ 4 [much]   -2 [FIL~     7 bla ~ bla ~ NA      
     8  2 [a b~  2 [no]    5 [ver~ 2 [a bit]   1 [not~     8 bla ~ bla ~  1 [aaa]
     9 99 [no ~ 99 [no an~ 1 [not~ 1 [not at~  2 [a b~     9 bla ~ bla ~ NA      
    10 99 [no ~  1 [yes]   1 [not~ 1 [not at~  4 [muc~    10 bla ~ bla ~ NA      
    # ... with 90 more rows, and 33 more variables: q6n <dbl+lbl>, q7n <dbl+lbl>,
    #   q6_1 <dbl+lbl>, q6_2 <dbl+lbl>, q6_3 <dbl+lbl>, q6_4 <dbl+lbl>,
    #   q6_97 <dbl+lbl>, q6_99 <dbl+lbl>, q6test_1 <dbl+lbl>, q6test_2 <dbl+lbl>,
    #   q6test_3 <dbl+lbl>, q6test_4 <dbl+lbl>, q6test_97 <dbl+lbl>,
    #   q6test_99 <dbl+lbl>, q6n1 <dbl+lbl>, q6n2 <dbl+lbl>, q6n3 <dbl+lbl>,
    #   q6n4 <dbl+lbl>, q6n5 <dbl+lbl>, q6n6 <dbl+lbl>, q6n7 <dbl+lbl>,
    #   q6n8 <dbl+lbl>, q6n9 <dbl+lbl>, q6n10 <dbl+lbl>, x <dbl>, abc <dbl>,
    #   kq5 <dbl>, kq6 <dbl>, kq3 <dbl+lbl>, n <dbl+lbl>, a1 <dbl+lbl>,
    #   a2 <dbl+lbl>, free2_var <dbl>

# mapp_cmd_table() reproduces snapshot

    # A tibble: 53 x 6
    # Rowwise: 
       sheet    action  row         new_var            data          sev_command_row
       <chr>    <chr>   <chr>       <chr>              <list>                  <int>
     1 Label    #SUMVAR 2, 3, 4, 5~ kq1                <named list ~              NA
     2 Variabl~ #RENAME 3, 5        q2_renamed, q4_re~ <named list ~              NA
     3 Variabl~ #NEWLAB 2           q1                 <named list ~              NA
     4 Variabl~ #NEWLAB 3           q2_renamed         <named list ~              NA
     5 Variabl~ #NEWLAB 6           q5                 <named list ~              NA
     6 Verbati~ #Verba  1           q6n                <named list ~              NA
     7 Verbati~ #Verba  1           q6n                <named list ~              NA
     8 Verbati~ #Verba  1           q6n                <named list ~              NA
     9 Verbati~ #Verba  2           q7n                <named list ~              NA
    10 Verbati~ #Verba  2           q7n                <named list ~              NA
    # ... with 43 more rows

