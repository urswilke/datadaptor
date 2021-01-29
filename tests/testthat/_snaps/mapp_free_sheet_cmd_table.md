# mapp_free_sheet_cmd_table() reproduces snapshot

    # A tibble: 16 x 6
       row            action sheet new_var    sev_command_row data            
       <chr>          <chr>  <chr> <chr>                <int> <list>          
     1 3              #COMP  Free1 x                        1 <tibble [1 x 5]>
     2 4              #IF    Free1 abc                      2 <tibble [1 x 5]>
     3 5              #IF    Free1 kq5                      3 <tibble [1 x 5]>
     4 5              #IF    Free1 kq6                      4 <tibble [1 x 5]>
     5 7, 8, 9, 10    #REC   Free1 kq3                      0 <tibble [4 x 5]>
     6 13             #COMP  Free1 n                        9 <tibble [1 x 5]>
     7 14             #VARL  Free1 n                       10 <tibble [1 x 5]>
     8 16, 17, 18, 19 #VALL  Free1 n                        0 <tibble [4 x 5]>
     9 21, 22         #AVALL Free1 n                        0 <tibble [2 x 5]>
    10 26             #VARL  Free1 q3                      17 <tibble [1 x 5]>
    11 26             #VARL  Free1 q5                      18 <tibble [1 x 5]>
    12 29             #COMP  Free1 a1                      19 <tibble [1 x 5]>
    13 29             #COMP  Free1 a2                      20 <tibble [1 x 5]>
    14 30             #VARL  Free1 a1                      21 <tibble [1 x 5]>
    15 30             #VARL  Free1 a2                      22 <tibble [1 x 5]>
    16 32             #DIC   Free1 q2_renamed              23 <tibble [1 x 5]>

---

    tibble [16 x 6] (S3: tbl_df/tbl/data.frame)
     $ row            : chr [1:16] "3" "4" "5" "5" ...
     $ action         : chr [1:16] "#COMP" "#IF" "#IF" "#IF" ...
     $ sheet          : chr [1:16] "Free1" "Free1" "Free1" "Free1" ...
     $ new_var        : chr [1:16] "x" "abc" "kq5" "kq6" ...
     $ sev_command_row: int [1:16] 1 2 3 4 0 9 10 0 0 17 ...
     $ data           :List of 16
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

