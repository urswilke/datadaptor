# s3 modified data print is reproduced

    # A tibble: 10 x 65
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
     2 4 [bla bla happiness] bla bla bla sadness  9         7         1 [yes]      
     3 8 [bla joy]           bla bla bla sadness  3         7         1 [yes]      
     4 5 [bla bla joy]       bla bla anger        3         3 [ccc]  99 [no answer]
     5 7 [bla happiness]     bla fear             9         2 [bbb]  NA            
     6 5 [bla bla joy]       bla pain             7         1 [aaa]  NA            
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
       n             a1        a2        r_expr_var sum_of_k_vars kkq1     
       <dbl+lbl>     <dbl+lbl> <dbl+lbl> <dbl+lbl>          <dbl> <dbl+lbl>
     1 1 [also with] 3         4          24                    7  2 [b]   
     2 1 [also with] 3         4          24                   14  2 [b]   
     3 1 [also with] 3         4           8                   11  1 [a]   
     4 1 [also with] 3         4          24                   10  2 [b]   
     5 1 [also with] 3         4          20                    9  2 [b]   
     6 1 [also with] 3         4          40                   10  2 [b]   
     7 1 [also with] 3         4         792                    2 NA       
     8 1 [also with] 3         4          16                    6  2 [b]   
     9 1 [also with] 3         4         792                   10 NA       
    10 1 [also with] 3         4          30                    9  2 [b]   
       free2_var
           <dbl>
     1         3
     2         3
     3         3
     4         3
     5         3
     6         3
     7         3
     8         3
     9         3
    10         3

# value labels are reproduced

    # A tibble: 235 x 3
        var                       nv vallab               
        <chr>                  <dbl> <chr>                
      1 q2new                     -2 FILTER               
      2 q2new                      1 YES                  
      3 q2new                      2 no                   
      4 q2new                     99 no answer            
      5 q3                        -2 FILTER               
      6 q3                         1 not at all           
      7 q3                         2 a bit                
      8 q3                         3 normal               
      9 q3                         4 much                 
     10 q3                         5 very much            
     11 q3                        99 no answer            
     12 q1                         1 not at all           
     13 q1                         2 a bit                
     14 q1                         3 normal               
     15 q1                         4 much                 
     16 q1                         5 very much            
     17 q5                         1 not at all           
     18 q5                         2 a bit                
     19 q5                         3 normal               
     20 q5                         4 much                 
     21 q5                         5 very much            
     22 q5                        99 no answer            
     23 q6                         1 bla bla bla happiness
     24 q6                         2 bla bla bla joy      
     25 q6                         3 bla bla bla love     
     26 q6                         4 bla bla happiness    
     27 q6                         5 bla bla joy          
     28 q6                         6 bla bla love         
     29 q6                         7 bla happiness        
     30 q6                         8 bla joy              
     31 q6                         9 bla love             
     32 kq5                        1 aaa                  
     33 kq5                        2 bbb                  
     34 kq5                        3 ccc                  
     35 q2                         1 yes                  
     36 q2                         2 no                   
     37 q2                        99 no answer            
     38 q4                        -2 FILTER               
     39 q4                         1 not at all           
     40 q4                         2 a bit                
     41 q4                         3 normal               
     42 q4                         4 much                 
     43 q4                         5 very much            
     44 q4                        99 no answer            
     45 q6n                       -2 FILTER               
     46 q6n                        1 love                 
     47 q6n                        2 joy                  
     48 q6n                        3 happiness            
     49 q6n                       97 Others               
     50 q6n                       99 No answer            
     51 q7n                       -2 FILTER               
     52 q7n                        1 sadness              
     53 q7n                        2 fear                 
     54 q7n                        3 anger                
     55 q7n                        4 pain                 
     56 q7n                       97 Others               
     57 q7n                       99 No answer            
     58 q6_1                       0 unselected           
     59 q6_1                       1 selected             
     60 q6_2                       0 unselected           
     61 q6_2                       1 selected             
     62 q6_3                       0 unselected           
     63 q6_3                       1 selected             
     64 q6_4                       0 unselected           
     65 q6_4                       1 selected             
     66 q6_97                      0 unselected           
     67 q6_97                      1 selected             
     68 q6_99                      0 unselected           
     69 q6_99                      1 selected             
     70 q6test_1                   0 unselected           
     71 q6test_1                   1 selected             
     72 q6test_2                   0 unselected           
     73 q6test_2                   1 selected             
     74 q6test_3                   0 unselected           
     75 q6test_3                   1 selected             
     76 q6test_4                   0 unselected           
     77 q6test_4                   1 selected             
     78 q6test_97                  0 unselected           
     79 q6test_97                  1 selected             
     80 q6test_99                  0 unselected           
     81 q6test_99                  1 selected             
     82 q6n1                      -2 FILTER               
     83 q6n1                       1 love                 
     84 q6n1                       2 joy                  
     85 q6n1                       3 happiness            
     86 q6n1                       4 noch wat             
     87 q6n1                      97 Others               
     88 q6n1                      99 No answer            
     89 q6n2                      -2 FILTER               
     90 q6n2                       1 love                 
     91 q6n2                       2 joy                  
     92 q6n2                       3 happiness            
     93 q6n2                       4 noch wat             
     94 q6n2                      97 Others               
     95 q6n2                      99 No answer            
     96 q6n3                      -2 FILTER               
     97 q6n3                       1 love                 
     98 q6n3                       2 joy                  
     99 q6n3                       3 happiness            
    100 q6n3                       4 noch wat             
    101 q6n3                      97 Others               
    102 q6n3                      99 No answer            
    103 q6n4                      -2 FILTER               
    104 q6n4                       1 love                 
    105 q6n4                       2 joy                  
    106 q6n4                       3 happiness            
    107 q6n4                       4 noch wat             
    108 q6n4                      97 Others               
    109 q6n4                      99 No answer            
    110 q6n5                      -2 FILTER               
    111 q6n5                       1 love                 
    112 q6n5                       2 joy                  
    113 q6n5                       3 happiness            
    114 q6n5                       4 noch wat             
    115 q6n5                      97 Others               
    116 q6n5                      99 No answer            
    117 q6n6                      -2 FILTER               
    118 q6n6                       1 love                 
    119 q6n6                       2 joy                  
    120 q6n6                       3 happiness            
    121 q6n6                       4 noch wat             
    122 q6n6                      97 Others               
    123 q6n6                      99 No answer            
    124 q6n7                      -2 FILTER               
    125 q6n7                       1 love                 
    126 q6n7                       2 joy                  
    127 q6n7                       3 happiness            
    128 q6n7                       4 noch wat             
    129 q6n7                      97 Others               
    130 q6n7                      99 No answer            
    131 q6n8                      -2 FILTER               
    132 q6n8                       1 love                 
    133 q6n8                       2 joy                  
    134 q6n8                       3 happiness            
    135 q6n8                       4 noch wat             
    136 q6n8                      97 Others               
    137 q6n8                      99 No answer            
    138 q6n9                      -2 FILTER               
    139 q6n9                       1 love                 
    140 q6n9                       2 joy                  
    141 q6n9                       3 happiness            
    142 q6n9                       4 noch wat             
    143 q6n9                      97 Others               
    144 q6n9                      99 No answer            
    145 q6n10                     -2 FILTER               
    146 q6n10                      1 love                 
    147 q6n10                      2 joy                  
    148 q6n10                      3 happiness            
    149 q6n10                      4 noch wat             
    150 q6n10                     97 Others               
    151 q6n10                     99 No answer            
    152 q6mw_1                     1 not at all           
    153 q6mw_1                     2 a bit                
    154 q6mw_1                     3 normal               
    155 q6mw_1                     4 much                 
    156 q6mw_1                     5 very much            
    157 q6mw_1                    99 no answer            
    158 q6mw_2                     1 not at all           
    159 q6mw_2                     2 a bit                
    160 q6mw_2                     3 normal               
    161 q6mw_2                     4 much                 
    162 q6mw_2                     5 very much            
    163 q6mw_2                    99 no answer            
    164 q6mw_3                     1 not at all           
    165 q6mw_3                     2 a bit                
    166 q6mw_3                     3 normal               
    167 q6mw_3                     4 much                 
    168 q6mw_3                     5 very much            
    169 q6mw_3                    99 no answer            
    170 q6mw_4                     1 not at all           
    171 q6mw_4                     2 a bit                
    172 q6mw_4                     3 normal               
    173 q6mw_4                     4 much                 
    174 q6mw_4                     5 very much            
    175 q6mw_4                    99 no answer            
    176 q6mw_97                    1 not at all           
    177 q6mw_97                    2 a bit                
    178 q6mw_97                    3 normal               
    179 q6mw_97                    4 much                 
    180 q6mw_97                    5 very much            
    181 q6mw_97                   99 no answer            
    182 q6mw_99                    1 not at all           
    183 q6mw_99                    2 a bit                
    184 q6mw_99                    3 normal               
    185 q6mw_99                    4 much                 
    186 q6mw_99                    5 very much            
    187 q6mw_99                   99 no answer            
    188 q6_assign_nn_1             1 not at all           
    189 q6_assign_nn_1             2 a bit                
    190 q6_assign_nn_1             3 normal               
    191 q6_assign_nn_1             4 much                 
    192 q6_assign_nn_1             5 very much            
    193 q6_assign_nn_1            99 no answer            
    194 q6_assign_nn_2            -2 FILTER               
    195 q6_assign_nn_2             1 YES                  
    196 q6_assign_nn_2             2 no                   
    197 q6_assign_nn_2            99 no answer            
    198 q6_assign_nn_3            -2 FILTER               
    199 q6_assign_nn_3             1 not at all           
    200 q6_assign_nn_3             2 a bit                
    201 q6_assign_nn_3             3 normal               
    202 q6_assign_nn_3             4 much                 
    203 q6_assign_nn_3             5 very much            
    204 q6_assign_nn_3            99 no answer            
    205 q6_assign_nn_4            -2 FILTER               
    206 q6_assign_nn_4             1 not at all           
    207 q6_assign_nn_4             2 a bit                
    208 q6_assign_nn_4             3 normal               
    209 q6_assign_nn_4             4 much                 
    210 q6_assign_nn_4             5 very much            
    211 q6_assign_nn_4            99 no answer            
    212 kq1                        1 1-2                  
    213 kq1                        2 3                    
    214 kq1                        3 4-5                  
    215 kq3                        1 1-2                  
    216 kq3                        2 3                    
    217 kq3                        3 4-5                  
    218 kq1xq2_renamedkminus20     1 1-2                  
    219 kq1xq2_renamedkminus20     2 3                    
    220 kq1xq2_renamedkminus20     3 4-5                  
    221 kq1xq2_renamedk10          1 1-2                  
    222 kq1xq2_renamedk10          2 3                    
    223 kq1xq2_renamedk10          3 4-5                  
    224 kq1xq2_renamedk20          1 1-2                  
    225 kq1xq2_renamedk20          2 3                    
    226 kq1xq2_renamedk20          3 4-5                  
    227 kq1xq2_renamedk990         1 1-2                  
    228 kq1xq2_renamedk990         2 3                    
    229 kq1xq2_renamedk990         3 4-5                  
    230 n                          1 also with            
    231 n                          2 value labels         
    232 n                          3 now                  
    233 n                          4 added label          
    234 kkq1                       1 a                    
    235 kkq1                       2 b                    

# variable labels are reproduced

    # A tibble: 45 x 2
       var                    varlab                                  
       <chr>                  <chr>                                   
     1 q2new                  recommend product                       
     2 q3                     Almost same variable label for q3 and q5
     3 q1                     new_varlab                              
     4 q5                     Almost same variable label for q5 and q3
     5 q6                     Tell me something positive.             
     6 q7                     Tell me something negative.             
     7 q8                     Now the variable is in numeric format.  
     8 kq5                    test                                    
     9 q2                     Do you want to recommend the product?   
    10 q4                     How much do you like your friends?      
    11 q6_1                   love                                    
    12 q6_2                   joy                                     
    13 q6_3                   happiness                               
    14 q6_4                   noch wat                                
    15 q6_97                  Others                                  
    16 q6_99                  No answer                               
    17 q6test_1               love                                    
    18 q6test_2               joy                                     
    19 q6test_3               happiness                               
    20 q6test_4               noch wat                                
    21 q6test_97              Others                                  
    22 q6test_99              No answer                               
    23 q6mw_1                 love                                    
    24 q6mw_2                 joy                                     
    25 q6mw_3                 happiness                               
    26 q6mw_4                 noch wat                                
    27 q6mw_97                Others                                  
    28 q6mw_99                No answer                               
    29 q6_assign_nn_1         love                                    
    30 q6_assign_nn_2         joy                                     
    31 q6_assign_nn_3         happiness                               
    32 q6_assign_nn_4         noch wat                                
    33 q6_assign_nn_97        Others                                  
    34 q6_assign_nn_99        No answer                               
    35 kq1                    summarized variable                     
    36 kq3                    summarized variable                     
    37 kq1xq2_renamedkminus20 FILTER: summarized variable             
    38 kq1xq2_renamedk10      YES: summarized variable                
    39 kq1xq2_renamedk20      no: summarized variable                 
    40 kq1xq2_renamedk990     no answer: summarized variable          
    41 n                      overwrite new label                     
    42 a1                     same variable label for a1 & a2         
    43 a2                     same variable label for a1 & a2         
    44 r_expr_var             varlab                                  
    45 kkq1                   vl                                      

# error string elements were added to cmd_tbl

    # A tibble: 87 x 7
       sheet     action           row      new_var raw          command_blocks error
       <chr>     <chr>            <chr>    <chr>   <list>       <validatd>     <chr>
     1 Config    #RECNA           <NA>     <NA>    <named list> <validatd>     ""   
     2 Label     #NEWVALL         8        q2      <tibble>     <validatd>     ""   
     3 Label     #SUMVAR          23, 24,~ kq5     <tibble>     <validatd>     ""   
     4 Variables #STR2NUM         8        q8      <tibble>     <validatd>     ""   
     5 Variables #AUTOREC         7        q6      <tibble>     <validatd>     ""   
     6 Variables #DROP            9        <NA>    <tibble>     <validatd>     ""   
     7 Variables #RENAME_varsheet 3, 5     q2_ren~ <tibble>     <validatd>     ""   
     8 Variables #NEWLAB          2        q1      <tibble>     <validatd>     ""   
     9 Variables #NEWLAB          3        q2_ren~ <tibble>     <validatd>     ""   
    10 Variables #NEWLAB          6        q5      <tibble>     <validatd>     ""   
    # i 77 more rows

