# snapshot of (the structure of) mapp_free_sheet_cmd_table()

    # A tibble: 23 x 4
       row            action new_var        data            
       <chr>          <chr>  <chr>          <list>          
     1 3              #COMP  x              <tibble [1 x 5]>
     2 4              #IF    abc            <tibble [1 x 5]>
     3 5_1            #IF    kq5            <tibble [1 x 5]>
     4 5_2            #IF    kq6            <tibble [1 x 5]>
     5 7, 8, 9, 10_1  #REC   kq1            <tibble [4 x 5]>
     6 7, 8, 9, 10_2  #REC   kq3            <tibble [4 x 5]>
     7 13             #KG    kq1_q2_renamed <tibble [1 x 5]>
     8 14             #COMP  n              <tibble [1 x 5]>
     9 15             #VARL  n              <tibble [1 x 5]>
    10 17, 18, 19, 20 #VALL  n              <tibble [4 x 5]>
    # ... with 13 more rows
    # i Use `print(n = ...)` to see more rows

---

    tibble [23 x 4] (S3: tbl_df/tbl/data.frame)
     $ row    : chr [1:23] "3" "4" "5_1" "5_2" ...
     $ action : chr [1:23] "#COMP" "#IF" "#IF" "#IF" ...
     $ new_var: chr [1:23] "x" "abc" "kq5" "kq6" ...
     $ data   :List of 23
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#COMP"
      .. ..$ X2: chr "x"
      .. ..$ X3: chr "q1 == 2"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#IF"
      .. ..$ X2: chr "q1 == 1 | q3 == 2"
      .. ..$ X3: chr "abc = 7"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#IF"
      .. ..$ X2: chr "q2_renamed == 1"
      .. ..$ X3: chr "kq5 = 7"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#IF"
      .. ..$ X2: chr "q3 == 1"
      .. ..$ X3: chr "kq6 = 8"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [4 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr [1:4] "#REC" NA NA "."
      .. ..$ X2: chr [1:4] "q1" "1" "3" "4"
      .. ..$ X3: chr [1:4] "kq1" "2" "3" "5"
      .. ..$ X4: chr [1:4] "summarized variable" "1" "2" "3"
      .. ..$ X5: chr [1:4] NA "1-2" "3" "4-5"
      ..$ : tibble [4 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr [1:4] "#REC" NA NA "."
      .. ..$ X2: chr [1:4] "q3" "1" "3" "4"
      .. ..$ X3: chr [1:4] "kq3" "2" "3" "5"
      .. ..$ X4: chr [1:4] "summarized variable" "1" "2" "3"
      .. ..$ X5: chr [1:4] NA "1-2" "3" "4-5"
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#KG"
      .. ..$ X2: chr "kq1"
      .. ..$ X3: chr "q2_renamed"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#COMP"
      .. ..$ X2: chr "n"
      .. ..$ X3: chr "1"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#VARL"
      .. ..$ X2: chr "n"
      .. ..$ X3: chr "my new label"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [4 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr [1:4] "#VALL" NA NA "."
      .. ..$ X2: chr [1:4] "n" "1" "2" "3"
      .. ..$ X3: chr [1:4] "overwrite new label" "also with" "value labels" "now"
      .. ..$ X4: chr [1:4] NA NA NA NA
      .. ..$ X5: chr [1:4] NA NA NA NA
      ..$ : tibble [2 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr [1:2] "#AVALL" "."
      .. ..$ X2: chr [1:2] "n" "4"
      .. ..$ X3: chr [1:2] NA "added label"
      .. ..$ X4: chr [1:2] NA NA
      .. ..$ X5: chr [1:2] NA NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#VARL"
      .. ..$ X2: chr "q3"
      .. ..$ X3: chr "Almost same variable label for q3 and q5"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#VARL"
      .. ..$ X2: chr "q5"
      .. ..$ X3: chr "Almost same variable label for q5 and q3"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#COMP"
      .. ..$ X2: chr "a1"
      .. ..$ X3: chr "3"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#COMP"
      .. ..$ X2: chr "a2"
      .. ..$ X3: chr "4"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#VARL"
      .. ..$ X2: chr "a1"
      .. ..$ X3: chr "same variable label for a1 & a2"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#VARL"
      .. ..$ X2: chr "a2"
      .. ..$ X3: chr "same variable label for a1 & a2"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#DIC"
      .. ..$ X2: chr "q3"
      .. ..$ X3: chr "q4_renamed"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#COMPR"
      .. ..$ X2: chr "r_expr_var"
      .. ..$ X3: chr "haven::labelled(ifelse(q1 == 5, q3 * 10, q1 * 8), label = \"varlab\")"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#MERGE"
      .. ..$ X2: chr "fake_survey.sav"
      .. ..$ X3: chr "id"
      .. ..$ X4: chr "q1 q2"
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#RFUN"
      .. ..$ X2: chr "example_R_function.R"
      .. ..$ X3: chr "calc_sum_of_k_vars"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#R"
      .. ..$ X2: chr "data.frame(a=1)"
      .. ..$ X3: chr NA
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [6 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr [1:6] "#REC" NA NA NA ...
      .. ..$ X2: chr [1:6] "q1" "1" "2" "3" ...
      .. ..$ X3: chr [1:6] "kkq1" NA NA NA ...
      .. ..$ X4: chr [1:6] "vl" "1" "2" "2" ...
      .. ..$ X5: chr [1:6] NA "a" "b" NA ...

