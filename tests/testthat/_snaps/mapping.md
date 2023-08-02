# s3 modified data print is reproduced

    # A tibble: 10 x 68
       q2new          q3             q1              q5                 id
       <dbl+lbl>      <dbl+lbl>      <dbl+lbl>       <dbl+lbl>       <dbl>
     1  2 [no]        3 [normal]      3 [normal]      2 [a bit]          1
     2  1 [YES]       5 [very much]   3 [normal]      5 [very much]      2
     3  1 [YES]       3 [normal]      1 [not at all]  5 [very much]      3
     4 99 [no answer] 4 [much]        3 [normal]      4 [much]           4
     5 -2 [FILTER]    2 [a bit]       5 [very much]   3 [normal]         5
     6 -2 [FILTER]    4 [much]        5 [very much]   2 [a bit]          6
     7  2 [no]        3 [normal]     NA              NA                  7
     8  2 [no]        5 [very much]   2 [a bit]       1 [not at all]     8
     9 99 [no answer] 1 [not at all] NA               2 [a bit]          9
    10  2 [no]        3 [normal]      5 [very much]   2 [a bit]         20
       q6                    q7                  q8        kq5       q2            
       <dbl+lbl>             <chr>               <dbl+lbl> <dbl+lbl> <dbl+lbl>     
     1 3 [bla bla bla love]  bla bla bla anger    2         1 [aaa]   2 [no]       
     2 4 [bla bla happiness] bla bla bla sadness  9         7         1 [YES]      
     3 8 [bla joy]           bla bla bla sadness  3         7         1 [YES]      
     4 5 [bla bla joy]       bla bla anger        3         3 [ccc]  99 [no answer]
     5 7 [bla happiness]     bla fear             9         2 [bbb]  -2 [FILTER]   
     6 5 [bla bla joy]       bla pain             7         1 [aaa]  -2 [FILTER]   
     7 9 [bla love]          bla bla sadness     10        NA         2 [no]       
     8 6 [bla bla love]      bla bla anger        1         1 [aaa]   2 [no]       
     9 6 [bla bla love]      bla bla sadness      2         1 [aaa]  99 [no answer]
    10 2 [bla bla bla joy]   bla bla bla fear    10         1 [aaa]   2 [no]       
       q4                q97   q99 q6n            q7n         q6_1          
       <dbl+lbl>       <dbl> <dbl> <dbl+lbl>      <dbl+lbl>   <dbl+lbl>     
     1  4 [much]          10    11  1 [love]      3 [anger]   1 [selected]  
     2  4 [much]          10    11  3 [happiness] 1 [sadness] 0 [unselected]
     3  2 [a bit]         10    11  2 [joy]       1 [sadness] 0 [unselected]
     4  4 [much]          10    11  2 [joy]       3 [anger]   0 [unselected]
     5  3 [normal]        10    11  3 [happiness] 2 [fear]    0 [unselected]
     6  3 [normal]        10    11  2 [joy]       4 [pain]    0 [unselected]
     7  4 [much]          10    11 NA             1 [sadness] 1 [selected]  
     8  2 [a bit]         10    11 NA             3 [anger]   1 [selected]  
     9  1 [not at all]    10    11  1 [love]      1 [sadness] 1 [selected]  
    10 -2 [FILTER]        10    11  2 [joy]       2 [fear]    0 [unselected]
       q6_2           q6_3           q6_4           q6_97          q6_99         
       <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>     
     1 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     2 0 [unselected] 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected]
     3 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     4 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     5 0 [unselected] 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected]
     6 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     7 0 [unselected] 0 [unselected] 1 [selected]   0 [unselected] 0 [unselected]
     8 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     9 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
    10 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
       q6test_1       q6test_2       q6test_3       q6test_4       q6test_97     
       <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>     
     1 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     2 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     3 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     4 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     5 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     6 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     7 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     8 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
     9 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
    10 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected] 0 [unselected]
       q6test_99      q6n1          q6n2          q6n3        q6n4       
       <dbl+lbl>      <dbl+lbl>     <dbl+lbl>     <dbl+lbl>   <dbl+lbl>  
     1 0 [unselected] 1 [love]      -2 [FILTER]   -2 [FILTER] -2 [FILTER]
     2 0 [unselected] 3 [happiness] -2 [FILTER]   -2 [FILTER] -2 [FILTER]
     3 0 [unselected] 2 [joy]       -2 [FILTER]   -2 [FILTER] -2 [FILTER]
     4 0 [unselected] 2 [joy]       -2 [FILTER]   -2 [FILTER] -2 [FILTER]
     5 0 [unselected] 3 [happiness] -2 [FILTER]   -2 [FILTER] -2 [FILTER]
     6 0 [unselected] 2 [joy]       -2 [FILTER]   -2 [FILTER] -2 [FILTER]
     7 0 [unselected] 1 [love]       4 [noch wat] -2 [FILTER] -2 [FILTER]
     8 0 [unselected] 1 [love]      -2 [FILTER]   -2 [FILTER] -2 [FILTER]
     9 0 [unselected] 1 [love]      -2 [FILTER]   -2 [FILTER] -2 [FILTER]
    10 0 [unselected] 2 [joy]       -2 [FILTER]   -2 [FILTER] -2 [FILTER]
       q6n5        q6n6        q6n7        q6n8        q6n9        q6n10      
       <dbl+lbl>   <dbl+lbl>   <dbl+lbl>   <dbl+lbl>   <dbl+lbl>   <dbl+lbl>  
     1 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     2 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     3 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     4 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     5 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     6 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     7 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     8 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
     9 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
    10 -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER] -2 [FILTER]
       q6mw_1         q6mw_2         q6mw_3        q6mw_4         q6mw_97  
       <dbl+lbl>      <dbl+lbl>      <dbl+lbl>     <dbl+lbl>      <dbl+lbl>
     1  3 [normal]    0              0              0             0        
     2  0             0              3 [normal]     0             0        
     3  0             1 [not at all] 0              0             0        
     4  0             3 [normal]     0              0             0        
     5  0             0              5 [very much]  0             0        
     6  0             5 [very much]  0              0             0        
     7 99 [no answer] 0              0             99 [no answer] 0        
     8  2 [a bit]     0              0              0             0        
     9 99 [no answer] 0              0              0             0        
    10  0             5 [very much]  0              0             0        
       q6mw_99   q6_assign_nn_1 q6_assign_nn_2 q6_assign_nn_3 q6_assign_nn_4
       <dbl+lbl> <dbl+lbl>      <dbl+lbl>      <dbl+lbl>      <dbl+lbl>     
     1 0          3 [normal]     0             0              0             
     2 0          0              0             5 [very much]  0             
     3 0          0              1 [YES]       0              0             
     4 0          0             99 [no answer] 0              0             
     5 0          0              0             2 [a bit]      0             
     6 0          0             -2 [FILTER]    0              0             
     7 0         99 [no answer]  0             0              4 [much]      
     8 0          2 [a bit]      0             0              0             
     9 0         99 [no answer]  0             0              0             
    10 0          0              2 [no]        0              0             
       q6_assign_nn_97 q6_assign_nn_99     x   abc   kq6 kq1       kq3      
       <dbl+lbl>       <dbl+lbl>       <dbl> <dbl> <dbl> <dbl+lbl> <dbl+lbl>
     1 0               0                   0    NA    NA  2 [3]    2 [3]    
     2 0               0                   0    NA    NA  2 [3]    3 [4-5]  
     3 0               0                   0     7    NA  1 [1-2]  2 [3]    
     4 0               0                   0    NA    NA  2 [3]    3 [4-5]  
     5 0               0                   0     7    NA  3 [4-5]  1 [1-2]  
     6 0               0                   0    NA    NA  3 [4-5]  3 [4-5]  
     7 0               0                   0    NA    NA NA        2 [3]    
     8 0               0                   1    NA    NA  1 [1-2]  3 [4-5]  
     9 0               0                   0    NA     8 NA        1 [1-2]  
    10 0               0                   0    NA    NA  3 [4-5]  2 [3]    
       kq1xq2_renamedkminus20 kq1xq2_renamedk10 kq1xq2_renamedk20 kq1xq2_renamedk990
       <dbl+lbl>              <dbl+lbl>         <dbl+lbl>         <dbl+lbl>         
     1 NA                     NA                 2 [3]            NA                
     2 NA                      2 [3]            NA                NA                
     3 NA                      1 [1-2]          NA                NA                
     4 NA                     NA                NA                 2 [3]            
     5  3 [4-5]               NA                NA                NA                
     6  3 [4-5]               NA                NA                NA                
     7 NA                     NA                NA                NA                
     8 NA                     NA                 1 [1-2]          NA                
     9 NA                     NA                NA                NA                
    10 NA                     NA                 3 [4-5]          NA                
       n             a1        a2        r_expr_var sum_of_k_vars kkq1       qsum
       <dbl+lbl>     <dbl+lbl> <dbl+lbl> <dbl+lbl>          <dbl> <dbl+lbl> <dbl>
     1 1 [also with] 3         4          24                    7  2 [b]       19
     2 1 [also with] 3         4          24                   14  2 [b]       31
     3 1 [also with] 3         4           8                   11  1 [a]       23
     4 1 [also with] 3         4          24                   10  2 [b]      122
     5 1 [also with] 3         4          20                    9  2 [b]       27
     6 1 [also with] 3         4          40                   10  2 [b]       24
     7 1 [also with] 3         4         792                    2 NA           NA
     8 1 [also with] 3         4          16                    6  2 [b]       19
     9 1 [also with] 3         4         792                   10 NA           NA
    10 1 [also with] 3         4          30                    9  2 [b]       22
       q1_2           q2_2           free2_var
       <dbl+lbl>      <dbl+lbl>          <dbl>
     1  3 [normal]     2 [no]                3
     2  3 [normal]    NA                     3
     3 NA             NA                     3
     4  3 [normal]    99 [no answer]         3
     5  5 [very much] -2 [FILTER]            3
     6  5 [very much] -2 [FILTER]            3
     7 NA              2 [no]                3
     8  2 [a bit]      2 [no]                3
     9 NA             99 [no answer]         3
    10  5 [very much]  2 [no]                3

# value labels are reproduced

    # A tibble: 243 x 3
     var                       nv vallab               
     <chr>                  <dbl> <chr>                
     q2new                     -2 FILTER               
     q2new                      1 YES                  
     q2new                      2 no                   
     q2new                     99 no answer            
     q3                        -2 FILTER               
     q3                         1 not at all           
     q3                         2 a bit                
     q3                         3 normal               
     q3                         4 much                 
     q3                         5 very much            
     q3                        99 no answer            
     q1                         1 not at all           
     q1                         2 a bit                
     q1                         3 normal               
     q1                         4 much                 
     q1                         5 very much            
     q5                         1 not at all           
     q5                         2 a bit                
     q5                         3 normal               
     q5                         4 much                 
     q5                         5 very much            
     q5                        99 no answer            
     q6                         1 bla bla bla happiness
     q6                         2 bla bla bla joy      
     q6                         3 bla bla bla love     
     q6                         4 bla bla happiness    
     q6                         5 bla bla joy          
     q6                         6 bla bla love         
     q6                         7 bla happiness        
     q6                         8 bla joy              
     q6                         9 bla love             
     kq5                        1 aaa                  
     kq5                        2 bbb                  
     kq5                        3 ccc                  
     q2                        -2 FILTER               
     q2                         1 YES                  
     q2                         2 no                   
     q2                        99 no answer            
     q4                        -2 FILTER               
     q4                         1 not at all           
     q4                         2 a bit                
     q4                         3 normal               
     q4                         4 much                 
     q4                         5 very much            
     q4                        99 no answer            
     q6n                       -2 FILTER               
     q6n                        1 love                 
     q6n                        2 joy                  
     q6n                        3 happiness            
     q6n                       97 Others               
     q6n                       99 No answer            
     q7n                       -2 FILTER               
     q7n                        1 sadness              
     q7n                        2 fear                 
     q7n                        3 anger                
     q7n                        4 pain                 
     q7n                       97 Others               
     q7n                       99 No answer            
     q6_1                       0 unselected           
     q6_1                       1 selected             
     q6_2                       0 unselected           
     q6_2                       1 selected             
     q6_3                       0 unselected           
     q6_3                       1 selected             
     q6_4                       0 unselected           
     q6_4                       1 selected             
     q6_97                      0 unselected           
     q6_97                      1 selected             
     q6_99                      0 unselected           
     q6_99                      1 selected             
     q6test_1                   0 unselected           
     q6test_1                   1 selected             
     q6test_2                   0 unselected           
     q6test_2                   1 selected             
     q6test_3                   0 unselected           
     q6test_3                   1 selected             
     q6test_4                   0 unselected           
     q6test_4                   1 selected             
     q6test_97                  0 unselected           
     q6test_97                  1 selected             
     q6test_99                  0 unselected           
     q6test_99                  1 selected             
     q6n1                      -2 FILTER               
     q6n1                       1 love                 
     q6n1                       2 joy                  
     q6n1                       3 happiness            
     q6n1                       4 noch wat             
     q6n1                      97 Others               
     q6n1                      99 No answer            
     q6n2                      -2 FILTER               
     q6n2                       1 love                 
     q6n2                       2 joy                  
     q6n2                       3 happiness            
     q6n2                       4 noch wat             
     q6n2                      97 Others               
     q6n2                      99 No answer            
     q6n3                      -2 FILTER               
     q6n3                       1 love                 
     q6n3                       2 joy                  
     q6n3                       3 happiness            
     q6n3                       4 noch wat             
     q6n3                      97 Others               
     q6n3                      99 No answer            
     q6n4                      -2 FILTER               
     q6n4                       1 love                 
     q6n4                       2 joy                  
     q6n4                       3 happiness            
     q6n4                       4 noch wat             
     q6n4                      97 Others               
     q6n4                      99 No answer            
     q6n5                      -2 FILTER               
     q6n5                       1 love                 
     q6n5                       2 joy                  
     q6n5                       3 happiness            
     q6n5                       4 noch wat             
     q6n5                      97 Others               
     q6n5                      99 No answer            
     q6n6                      -2 FILTER               
     q6n6                       1 love                 
     q6n6                       2 joy                  
     q6n6                       3 happiness            
     q6n6                       4 noch wat             
     q6n6                      97 Others               
     q6n6                      99 No answer            
     q6n7                      -2 FILTER               
     q6n7                       1 love                 
     q6n7                       2 joy                  
     q6n7                       3 happiness            
     q6n7                       4 noch wat             
     q6n7                      97 Others               
     q6n7                      99 No answer            
     q6n8                      -2 FILTER               
     q6n8                       1 love                 
     q6n8                       2 joy                  
     q6n8                       3 happiness            
     q6n8                       4 noch wat             
     q6n8                      97 Others               
     q6n8                      99 No answer            
     q6n9                      -2 FILTER               
     q6n9                       1 love                 
     q6n9                       2 joy                  
     q6n9                       3 happiness            
     q6n9                       4 noch wat             
     q6n9                      97 Others               
     q6n9                      99 No answer            
     q6n10                     -2 FILTER               
     q6n10                      1 love                 
     q6n10                      2 joy                  
     q6n10                      3 happiness            
     q6n10                      4 noch wat             
     q6n10                     97 Others               
     q6n10                     99 No answer            
     q6mw_1                     1 not at all           
     q6mw_1                     2 a bit                
     q6mw_1                     3 normal               
     q6mw_1                     4 much                 
     q6mw_1                     5 very much            
     q6mw_1                    99 no answer            
     q6mw_2                     1 not at all           
     q6mw_2                     2 a bit                
     q6mw_2                     3 normal               
     q6mw_2                     4 much                 
     q6mw_2                     5 very much            
     q6mw_2                    99 no answer            
     q6mw_3                     1 not at all           
     q6mw_3                     2 a bit                
     q6mw_3                     3 normal               
     q6mw_3                     4 much                 
     q6mw_3                     5 very much            
     q6mw_3                    99 no answer            
     q6mw_4                     1 not at all           
     q6mw_4                     2 a bit                
     q6mw_4                     3 normal               
     q6mw_4                     4 much                 
     q6mw_4                     5 very much            
     q6mw_4                    99 no answer            
     q6mw_97                    1 not at all           
     q6mw_97                    2 a bit                
     q6mw_97                    3 normal               
     q6mw_97                    4 much                 
     q6mw_97                    5 very much            
     q6mw_97                   99 no answer            
     q6mw_99                    1 not at all           
     q6mw_99                    2 a bit                
     q6mw_99                    3 normal               
     q6mw_99                    4 much                 
     q6mw_99                    5 very much            
     q6mw_99                   99 no answer            
     q6_assign_nn_1             1 not at all           
     q6_assign_nn_1             2 a bit                
     q6_assign_nn_1             3 normal               
     q6_assign_nn_1             4 much                 
     q6_assign_nn_1             5 very much            
     q6_assign_nn_1            99 no answer            
     q6_assign_nn_2            -2 FILTER               
     q6_assign_nn_2             1 YES                  
     q6_assign_nn_2             2 no                   
     q6_assign_nn_2            99 no answer            
     q6_assign_nn_3            -2 FILTER               
     q6_assign_nn_3             1 not at all           
     q6_assign_nn_3             2 a bit                
     q6_assign_nn_3             3 normal               
     q6_assign_nn_3             4 much                 
     q6_assign_nn_3             5 very much            
     q6_assign_nn_3            99 no answer            
     q6_assign_nn_4            -2 FILTER               
     q6_assign_nn_4             1 not at all           
     q6_assign_nn_4             2 a bit                
     q6_assign_nn_4             3 normal               
     q6_assign_nn_4             4 much                 
     q6_assign_nn_4             5 very much            
     q6_assign_nn_4            99 no answer            
     kq1                        1 1-2                  
     kq1                        2 3                    
     kq1                        3 4-5                  
     kq3                        1 1-2                  
     kq3                        2 3                    
     kq3                        3 4-5                  
     kq1xq2_renamedkminus20     1 1-2                  
     kq1xq2_renamedkminus20     2 3                    
     kq1xq2_renamedkminus20     3 4-5                  
     kq1xq2_renamedk10          1 1-2                  
     kq1xq2_renamedk10          2 3                    
     kq1xq2_renamedk10          3 4-5                  
     kq1xq2_renamedk20          1 1-2                  
     kq1xq2_renamedk20          2 3                    
     kq1xq2_renamedk20          3 4-5                  
     kq1xq2_renamedk990         1 1-2                  
     kq1xq2_renamedk990         2 3                    
     kq1xq2_renamedk990         3 4-5                  
     n                          1 also with            
     n                          2 value labels         
     n                          3 now                  
     n                          4 added label          
     kkq1                       1 a                    
     kkq1                       2 b                    
     q1_2                       2 a bit                
     q1_2                       3 normal               
     q1_2                       4 much                 
     q1_2                       5 very much            
     q2_2                      -2 FILTER               
     q2_2                       2 no                   
     q2_2                      99 no answer            

# variable labels are reproduced

    # A tibble: 68 x 2
     var                    varlab                                    
     <chr>                  <chr>                                     
     q2new                  "recommend product"                       
     q3                     "Almost same variable label for q3 and q5"
     q1                     "new_varlab"                              
     q5                     "Almost same variable label for q5 and q3"
     id                     ""                                        
     q6                     "Tell me something positive."             
     q7                     "Tell me something negative."             
     q8                     "Now the variable is in numeric format."  
     kq5                    "test"                                    
     q2                     "recommend product"                       
     q4                     "How much do you like your friends?"      
     q97                    ""                                        
     q99                    ""                                        
     q6n                    ""                                        
     q7n                    ""                                        
     q6_1                   "love"                                    
     q6_2                   "joy"                                     
     q6_3                   "happiness"                               
     q6_4                   "noch wat"                                
     q6_97                  "Others"                                  
     q6_99                  "No answer"                               
     q6test_1               "love"                                    
     q6test_2               "joy"                                     
     q6test_3               "happiness"                               
     q6test_4               "noch wat"                                
     q6test_97              "Others"                                  
     q6test_99              "No answer"                               
     q6n1                   ""                                        
     q6n2                   ""                                        
     q6n3                   ""                                        
     q6n4                   ""                                        
     q6n5                   ""                                        
     q6n6                   ""                                        
     q6n7                   ""                                        
     q6n8                   ""                                        
     q6n9                   ""                                        
     q6n10                  ""                                        
     q6mw_1                 "love"                                    
     q6mw_2                 "joy"                                     
     q6mw_3                 "happiness"                               
     q6mw_4                 "noch wat"                                
     q6mw_97                "Others"                                  
     q6mw_99                "No answer"                               
     q6_assign_nn_1         "love"                                    
     q6_assign_nn_2         "joy"                                     
     q6_assign_nn_3         "happiness"                               
     q6_assign_nn_4         "noch wat"                                
     q6_assign_nn_97        "Others"                                  
     q6_assign_nn_99        "No answer"                               
     x                      ""                                        
     abc                    ""                                        
     kq6                    ""                                        
     kq1                    "summarized variable"                     
     kq3                    "summarized variable"                     
     kq1xq2_renamedkminus20 "FILTER: summarized variable"             
     kq1xq2_renamedk10      "YES: summarized variable"                
     kq1xq2_renamedk20      "no: summarized variable"                 
     kq1xq2_renamedk990     "no answer: summarized variable"          
     n                      "overwrite new label"                     
     a1                     "same variable label for a1 & a2"         
     a2                     "same variable label for a1 & a2"         
     r_expr_var             "varlab"                                  
     sum_of_k_vars          ""                                        
     kkq1                   "vl"                                      
     qsum                   ""                                        
     q1_2                   "new_varlab"                              
     q2_2                   "recommend product"                       
     free2_var              ""                                        

# error string elements were added to cmd_tbl

    # A tibble: 89 x 7
       sheet     action           row      new_var raw          command_blocks error
       <chr>     <chr>            <chr>    <chr>   <list>       <safe>         <chr>
     1 Config    #RECNA           <NA>     <NA>    <named list> <cmd_rcn_>     ""   
     2 Label     #NEWVALL         8        q2      <tibble>     <cmd_nwvl>     ""   
     3 Label     #SUMVAR          23, 24,~ kq5     <tibble>     <cmd_smvr>     ""   
     4 Variables #STR2NUM         8        q8      <tibble>     <cmd_st__>     ""   
     5 Variables #AUTOREC         7        q6      <tibble>     <cmd_atrc>     ""   
     6 Variables #DROP            9        <NA>    <tibble>     <cmd_drop>     ""   
     7 Variables #RENAME_varsheet 3, 5     q2_ren~ <tibble>     <cmd_rnm_>     ""   
     8 Variables #NEWLAB          2        q1      <tibble>     <cmd_nwlb>     ""   
     9 Variables #NEWLAB          3        q2_ren~ <tibble>     <cmd_nwlb>     ""   
    10 Variables #NEWLAB          6        q5      <tibble>     <cmd_nwlb>     ""   
    # i 79 more rows

