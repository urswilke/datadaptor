# mapp_free_sheet_cmd_table() reproduces snapshot

    # A tibble: 18 x 4
       row            action new_var    data            
       <chr>          <chr>  <chr>      <list>          
     1 3              #COMP  x          <tibble [1 x 5]>
     2 4              #IF    abc        <tibble [1 x 5]>
     3 5_1            #IF    kq5        <tibble [1 x 5]>
     4 5_2            #IF    kq6        <tibble [1 x 5]>
     5 7, 8, 9, 10_1  #REC   kq1        <tibble [4 x 5]>
     6 7, 8, 9, 10_2  #REC   kq3        <tibble [4 x 5]>
     7 13             #COMP  n          <tibble [1 x 5]>
     8 14             #VARL  n          <tibble [1 x 5]>
     9 16, 17, 18, 19 #VALL  n          <tibble [4 x 5]>
    10 21, 22         #AVALL n          <tibble [2 x 5]>
    11 26_1           #VARL  q3         <tibble [1 x 5]>
    12 26_2           #VARL  q5         <tibble [1 x 5]>
    13 29_1           #COMP  a1         <tibble [1 x 5]>
    14 29_2           #COMP  a2         <tibble [1 x 5]>
    15 30_1           #VARL  a1         <tibble [1 x 5]>
    16 30_2           #VARL  a2         <tibble [1 x 5]>
    17 32_1           #DIC   q2_renamed <tibble [1 x 5]>
    18 32_2           #DIC   q4_renamed <tibble [1 x 5]>

---

    tibble [18 x 4] (S3: tbl_df/tbl/data.frame)
     $ row    : chr [1:18] "3" "4" "5_1" "5_2" ...
     $ action : chr [1:18] "#COMP" "#IF" "#IF" "#IF" ...
     $ new_var: chr [1:18] "x" "abc" "kq5" "kq6" ...
     $ data   :List of 18
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
      .. ..$ X3: chr "q2_renamed"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA
      ..$ : tibble [1 x 5] (S3: tbl_df/tbl/data.frame)
      .. ..$ X1: chr "#DIC"
      .. ..$ X2: chr "q3"
      .. ..$ X3: chr "q4_renamed"
      .. ..$ X4: chr NA
      .. ..$ X5: chr NA

