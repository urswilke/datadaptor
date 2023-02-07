# s3 modified data print is reproduced

    # A tibble: 151 x 70
       DC_ID id        screenout datum      q1                    
       <dbl> <dbl+lbl> <dbl+lbl> <date>     <dbl+lbl>             
     1 10013 10013     2 [nein]  2021-01-23 2 [2 - 4 Beschäftigte]
     2 10024 10024     2 [nein]  2020-11-22 2 [2 - 4 Beschäftigte]
     3 10304 10304     2 [nein]  2021-01-24 3 [5 - 9 Beschäftigte]
     4 10366 10366     2 [nein]  2020-11-18 3 [5 - 9 Beschäftigte]
     5 10471 10471     2 [nein]  2021-02-14 3 [5 - 9 Beschäftigte]
     6 10506 10506     2 [nein]  2020-11-15 3 [5 - 9 Beschäftigte]
     7 10600 10600     2 [nein]  2020-11-20 2 [2 - 4 Beschäftigte]
     8 10808 10808     2 [nein]  2020-11-20 3 [5 - 9 Beschäftigte]
     9 10948 10948     2 [nein]  2021-02-14 2 [2 - 4 Beschäftigte]
    10 11182 11182     2 [nein]  2020-11-15 3 [5 - 9 Beschäftigte]
       q2_00               q2_01             q2_02             q2_03            
       <dbl+lbl>           <dbl+lbl>         <dbl+lbl>         <dbl+lbl>        
     1 0 [Nicht gefiltert] 0 [Nicht genannt] 1 [Genannt]       0 [Nicht genannt]
     2 0 [Nicht gefiltert] 0 [Nicht genannt] 1 [Genannt]       0 [Nicht genannt]
     3 0 [Nicht gefiltert] 1 [Genannt]       0 [Nicht genannt] 0 [Nicht genannt]
     4 0 [Nicht gefiltert] 1 [Genannt]       0 [Nicht genannt] 0 [Nicht genannt]
     5 0 [Nicht gefiltert] 1 [Genannt]       0 [Nicht genannt] 0 [Nicht genannt]
     6 0 [Nicht gefiltert] 1 [Genannt]       1 [Genannt]       0 [Nicht genannt]
     7 0 [Nicht gefiltert] 1 [Genannt]       0 [Nicht genannt] 0 [Nicht genannt]
     8 0 [Nicht gefiltert] 1 [Genannt]       0 [Nicht genannt] 0 [Nicht genannt]
     9 0 [Nicht gefiltert] 1 [Genannt]       0 [Nicht genannt] 0 [Nicht genannt]
    10 0 [Nicht gefiltert] 1 [Genannt]       1 [Genannt]       0 [Nicht genannt]
       q2_04             q2_05             q2_06             q2_07            
       <dbl+lbl>         <dbl+lbl>         <dbl+lbl>         <dbl+lbl>        
     1 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt]
     2 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt]
     3 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt]
     4 0 [Nicht genannt] 0 [Nicht genannt] 1 [Genannt]       0 [Nicht genannt]
     5 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt]
     6 1 [Genannt]       0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt]
     7 0 [Nicht genannt] 0 [Nicht genannt] 1 [Genannt]       0 [Nicht genannt]
     8 0 [Nicht genannt] 0 [Nicht genannt] 1 [Genannt]       0 [Nicht genannt]
     9 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt]
    10 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt] 0 [Nicht genannt]
       q2_99             q3a       q3b       q3c       q3d       q3e       q3f      
       <dbl+lbl>         <dbl+lbl> <dbl+lbl> <dbl+lbl> <dbl+lbl> <dbl+lbl> <dbl+lbl>
     1 0 [Nicht genannt]   0       100       0          0        0          0       
     2 0 [Nicht genannt]   0       100       0          0        0          0       
     3 0 [Nicht genannt] 100         0       0          0        0          0       
     4 0 [Nicht genannt]  50         0       0          0        0         50       
     5 0 [Nicht genannt] 100         0       0          0        0          0       
     6 0 [Nicht genannt]  10        25       0         65        0          0       
     7 0 [Nicht genannt]  80         0       0          0        0         20       
     8 0 [Nicht genannt]  90         0       0          0        0         10       
     9 0 [Nicht genannt] 100         0       0          0        0          0       
    10 0 [Nicht genannt]  50        50       0          0        0          0       
       q3g       q4        q6a                q6b                q6c              
       <dbl+lbl> <dbl+lbl> <dbl+lbl>          <dbl+lbl>          <dbl+lbl>        
     1 0          2        -2 [FILTER]        -2 [FILTER]        -2 [FILTER]      
     2 0          2         3 [teils / teils]  3 [teils / teils]  5 [sehr wichtig]
     3 0          2         4 [wichtig]        3 [teils / teils]  5 [sehr wichtig]
     4 0          5         5 [sehr wichtig]   3 [teils / teils]  5 [sehr wichtig]
     5 0          3         5 [sehr wichtig]   3 [teils / teils]  5 [sehr wichtig]
     6 0          7         5 [sehr wichtig]   3 [teils / teils]  5 [sehr wichtig]
     7 0          3         5 [sehr wichtig]   3 [teils / teils]  5 [sehr wichtig]
     8 0          5         5 [sehr wichtig]   5 [sehr wichtig]   5 [sehr wichtig]
     9 0          2        -2 [FILTER]        -2 [FILTER]        -2 [FILTER]      
    10 0         10         5 [sehr wichtig]   4 [wichtig]        5 [sehr wichtig]
       q6d                q6e                   q6f                q6g              
       <dbl+lbl>          <dbl+lbl>             <dbl+lbl>          <dbl+lbl>        
     1 -2 [FILTER]        -2 [FILTER]           -2 [FILTER]        -2 [FILTER]      
     2  5 [sehr wichtig]   5 [sehr wichtig]      5 [sehr wichtig]  99 [keine Angabe]
     3  4 [wichtig]        3 [teils / teils]     3 [teils / teils]  5 [sehr wichtig]
     4  3 [teils / teils]  3 [teils / teils]     3 [teils / teils]  5 [sehr wichtig]
     5  2 [unwichtig]      5 [sehr wichtig]      4 [wichtig]        5 [sehr wichtig]
     6  3 [teils / teils]  1 [völlig unwichtig]  2 [unwichtig]      5 [sehr wichtig]
     7  3 [teils / teils]  4 [wichtig]           3 [teils / teils]  5 [sehr wichtig]
     8  5 [sehr wichtig]   5 [sehr wichtig]      5 [sehr wichtig]   5 [sehr wichtig]
     9 -2 [FILTER]        -2 [FILTER]           -2 [FILTER]        -2 [FILTER]      
    10  3 [teils / teils]  3 [teils / teils]     3 [teils / teils]  4 [wichtig]     
       q6h                sel1      q7a1              q7a2              q7b1     
       <dbl+lbl>          <dbl+lbl> <dbl+lbl>         <dbl+lbl>         <dbl+lbl>
     1 -2 [FILTER]        7 [NA]     4 [4]            -2 [FILTER]       8 [8]    
     2  5 [sehr wichtig]  6 [NA]     8 [8]             5 [5]            8 [8]    
     3  4 [wichtig]       7 [NA]    99 [keine Angabe] -2 [FILTER]       8 [8]    
     4  3 [teils / teils] 6 [NA]     8 [8]             8 [8]            7 [7]    
     5  5 [sehr wichtig]  2 [NA]     8 [8]             8 [8]            7 [7]    
     6  4 [wichtig]       2 [NA]     9 [9]            99 [keine Angabe] 8 [8]    
     7  5 [sehr wichtig]  6 [NA]     8 [8]             5 [5]            8 [8]    
     8  5 [sehr wichtig]  6 [NA]    99 [keine Angabe] 99 [keine Angabe] 8 [8]    
     9 -2 [FILTER]        7 [NA]     8 [8]            -2 [FILTER]       7 [7]    
    10  5 [sehr wichtig]  4 [NA]     3 [3]             8 [8]            3 [3]    
       q7b2              q7c1                               
       <dbl+lbl>         <dbl+lbl>                          
     1 -2 [FILTER]        7 [7]                             
     2  3 [3]            99 [keine Angabe]                  
     3 -2 [FILTER]       99 [keine Angabe]                  
     4  7 [7]             8 [8]                             
     5  7 [7]            10 [10 = außerordentlich zufrieden]
     6 99 [keine Angabe]  9 [9]                             
     7  8 [8]            99 [keine Angabe]                  
     8  6 [6]             8 [8]                             
     9 -2 [FILTER]        8 [8]                             
    10  7 [7]             9 [9]                             
       q7c2                                q7d1                               
       <dbl+lbl>                           <dbl+lbl>                          
     1 -2 [FILTER]                          7 [7]                             
     2  1 [1 = überhaupt nicht zufrieden]  99 [keine Angabe]                  
     3 -2 [FILTER]                          9 [9]                             
     4  8 [8]                               9 [9]                             
     5 10 [10 = außerordentlich zufrieden]  9 [9]                             
     6 99 [keine Angabe]                    8 [8]                             
     7 99 [keine Angabe]                   10 [10 = außerordentlich zufrieden]
     8  8 [8]                               8 [8]                             
     9 -2 [FILTER]                          7 [7]                             
    10 99 [keine Angabe]                    9 [9]                             
       q7d2                                q7e1                               
       <dbl+lbl>                           <dbl+lbl>                          
     1 -2 [FILTER]                          4 [4]                             
     2 10 [10 = außerordentlich zufrieden] 99 [keine Angabe]                  
     3 -2 [FILTER]                         99 [keine Angabe]                  
     4  6 [6]                               8 [8]                             
     5  9 [9]                              10 [10 = außerordentlich zufrieden]
     6 99 [keine Angabe]                    5 [5]                             
     7 10 [10 = außerordentlich zufrieden] 99 [keine Angabe]                  
     8  3 [3]                              10 [10 = außerordentlich zufrieden]
     9 -2 [FILTER]                         99 [keine Angabe]                  
    10  9 [9]                              10 [10 = außerordentlich zufrieden]
       q7e2                                q7h1             
       <dbl+lbl>                           <dbl+lbl>        
     1 -2 [FILTER]                          2 [2]           
     2  1 [1 = überhaupt nicht zufrieden]  99 [keine Angabe]
     3 -2 [FILTER]                         99 [keine Angabe]
     4  8 [8]                               7 [7]           
     5 10 [10 = außerordentlich zufrieden]  9 [9]           
     6 99 [keine Angabe]                    6 [6]           
     7 99 [keine Angabe]                   99 [keine Angabe]
     8 10 [10 = außerordentlich zufrieden]  8 [8]           
     9 -2 [FILTER]                         99 [keine Angabe]
    10 10 [10 = außerordentlich zufrieden]  9 [9]           
       q7h2                               q7f1                               
       <dbl+lbl>                          <dbl+lbl>                          
     1 -2 [FILTER]                         8 [8]                             
     2  1 [1 = überhaupt nicht zufrieden] 10 [10 = außerordentlich zufrieden]
     3 -2 [FILTER]                        99 [keine Angabe]                  
     4  7 [7]                              8 [8]                             
     5  9 [9]                              7 [7]                             
     6 99 [keine Angabe]                   8 [8]                             
     7 99 [keine Angabe]                  10 [10 = außerordentlich zufrieden]
     8  5 [5]                              8 [8]                             
     9 -2 [FILTER]                         9 [9]                             
    10  9 [9]                             10 [10 = außerordentlich zufrieden]
       q7f2                                q7g1             
       <dbl+lbl>                           <dbl+lbl>        
     1 -2 [FILTER]                          8 [8]           
     2  5 [5]                              99 [keine Angabe]
     3 -2 [FILTER]                         99 [keine Angabe]
     4  8 [8]                               8 [8]           
     5  7 [7]                               7 [7]           
     6 99 [keine Angabe]                    9 [9]           
     7 10 [10 = außerordentlich zufrieden]  8 [8]           
     8  6 [6]                               8 [8]           
     9 -2 [FILTER]                          7 [7]           
    10 10 [10 = außerordentlich zufrieden]  8 [8]           
       q7g2                               q81       q82        
       <dbl+lbl>                          <dbl+lbl> <dbl+lbl>  
     1 -2 [FILTER]                        8 [8]     -2 [FILTER]
     2  8 [8]                             6 [6]      4 [4]     
     3 -2 [FILTER]                        9 [9]     -2 [FILTER]
     4  8 [8]                             9 [9]      9 [9]     
     5  7 [7]                             8 [8]      8 [8]     
     6 99 [keine Angabe]                  9 [9]      8 [8]     
     7  7 [7]                             7 [7]      5 [5]     
     8  1 [1 = überhaupt nicht zufrieden] 7 [7]      5 [5]     
     9 -2 [FILTER]                        8 [8]     -2 [FILTER]
    10  8 [8]                             9 [9]      9 [9]     
       q91                      q92                      q10              
       <dbl+lbl>                <dbl+lbl>                <dbl+lbl>        
     1  8 [8]                   -2 [FILTER]              51               
     2  7 [7]                    7 [7]                   51               
     3  9 [9]                   -2 [FILTER]              39               
     4 10 [10 - auf jeden Fall] 10 [10 - auf jeden Fall] 50               
     5 10 [10 - auf jeden Fall] 10 [10 - auf jeden Fall] -1 [keine Angabe]
     6 10 [10 - auf jeden Fall]  8 [8]                   52               
     7 10 [10 - auf jeden Fall]  8 [8]                   53               
     8  8 [8]                    8 [8]                   51               
     9 10 [10 - auf jeden Fall] -2 [FILTER]              61               
    10  9 [9]                    9 [9]                   49               
       regio           sel0      kq4        kq10              kq4xkq10k10
       <dbl+lbl>       <dbl+lbl> <dbl+lbl>  <dbl+lbl>         <dbl+lbl>  
     1 2 [Europa]      1 [NA]    1 [1-2mal]  3 [50 und älter] NA         
     2 2 [Europa]      1 [NA]    1 [1-2mal]  3 [50 und älter] NA         
     3 3 [Nordamerika] 1 [NA]    1 [1-2mal]  1 [18 bis 39]     1 [1-2mal]
     4 2 [Europa]      1 [NA]    2 [3-5mal]  3 [50 und älter] NA         
     5 2 [Europa]      1 [NA]    2 [3-5mal] NA                NA         
     6 3 [Nordamerika] 1 [NA]    3 [>5mal]   3 [50 und älter] NA         
     7 3 [Nordamerika] 1 [NA]    2 [3-5mal]  3 [50 und älter] NA         
     8 4 [Pazifik]     1 [NA]    2 [3-5mal]  3 [50 und älter] NA         
     9 2 [Europa]      1 [NA]    1 [1-2mal]  3 [50 und älter] NA         
    10 2 [Europa]      1 [NA]    3 [>5mal]   2 [40 bis 49]    NA         
       kq4xkq10k20 kq4xkq10k30 kq4xregiok10 kq4xregiok20 kq4xregiok30 kq4xregiok40
       <dbl+lbl>   <dbl+lbl>   <dbl+lbl>    <dbl+lbl>    <dbl+lbl>    <dbl+lbl>   
     1 NA           1 [1-2mal] NA            1 [1-2mal]  NA           NA          
     2 NA           1 [1-2mal] NA            1 [1-2mal]  NA           NA          
     3 NA          NA          NA           NA            1 [1-2mal]  NA          
     4 NA           2 [3-5mal] NA            2 [3-5mal]  NA           NA          
     5 NA          NA          NA            2 [3-5mal]  NA           NA          
     6 NA           3 [>5mal]  NA           NA            3 [>5mal]   NA          
     7 NA           2 [3-5mal] NA           NA            2 [3-5mal]  NA          
     8 NA           2 [3-5mal] NA           NA           NA            2 [3-5mal] 
     9 NA           1 [1-2mal] NA            1 [1-2mal]  NA           NA          
    10  3 [>5mal]  NA          NA            3 [>5mal]   NA           NA          
       kq4xregiokminus20   gew q5n1                                          
       <dbl+lbl>         <dbl> <dbl+lbl>                                     
     1 NA                  0.5 99 [Keine Angabe]                             
     2 NA                  0.5  5 [einfache Weiterverarbeitung der Daten]    
     3 NA                  0.5 99 [Keine Angabe]                             
     4 NA                  0.5  4 [Darstellung der Daten]                    
     5 NA                  0.5  1 [Freundlichkeit des Tabellenbanderstellers]
     6 NA                  0.5  5 [einfache Weiterverarbeitung der Daten]    
     7 NA                  0.5  4 [Darstellung der Daten]                    
     8 NA                  0.5  5 [einfache Weiterverarbeitung der Daten]    
     9 NA                  0.5  2 [Kompetenz]                                
    10 NA                  0.5  5 [einfache Weiterverarbeitung der Daten]    
       q5n2                                           q5n3           q5n4     
       <dbl+lbl>                                      <dbl+lbl>      <dbl+lbl>
     1 -2                                             -2             -2       
     2 -2                                             -2             -2       
     3 -2                                             -2             -2       
     4  2 [Kompetenz]                                 -2             -2       
     5  3 [Schnelligkeit der Umsetzung]               -2             -2       
     6  1 [Freundlichkeit des Tabellenbanderstellers]  2 [Kompetenz] -2       
     7  2 [Kompetenz]                                 -2             -2       
     8  2 [Kompetenz]                                 -2             -2       
     9  4 [Darstellung der Daten]                     -2             -2       
    10 -2                                             -2             -2       
       q5n5     
       <dbl+lbl>
     1 -2       
     2 -2       
     3 -2       
     4 -2       
     5 -2       
     6 -2       
     7 -2       
     8 -2       
     9 -2       
    10 -2       
    # ... with 141 more rows

# value labels are reproduced

    # A tibble: 440 x 3
        var                  nv vallab                                   
        <chr>             <dbl> <chr>                                    
      1 screenout            -2 FILTER                                   
      2 screenout             1 ja                                       
      3 screenout             2 nein                                     
      4 q1                   -2 FILTER                                   
      5 q1                    1 1 Beschäftigter                          
      6 q1                    2 2 - 4 Beschäftigte                       
      7 q1                    3 5 - 9 Beschäftigte                       
      8 q1                    4 10 - 19 Beschäftigte                     
      9 q1                    5 20 Beschäftigte und mehr                 
     10 q1                   99 keine Angabe                             
     11 q2_00                -2 FILTER                                   
     12 q2_00                 0 Nicht gefiltert                          
     13 q2_00                 1 Gefiltert                                
     14 q2_01                -2 FILTER                                   
     15 q2_01                 0 Nicht genannt                            
     16 q2_01                 1 Genannt                                  
     17 q2_02                -2 FILTER                                   
     18 q2_02                 0 Nicht genannt                            
     19 q2_02                 1 Genannt                                  
     20 q2_03                -2 FILTER                                   
     21 q2_03                 0 Nicht genannt                            
     22 q2_03                 1 Genannt                                  
     23 q2_04                -2 FILTER                                   
     24 q2_04                 0 Nicht genannt                            
     25 q2_04                 1 Genannt                                  
     26 q2_05                -2 FILTER                                   
     27 q2_05                 0 Nicht genannt                            
     28 q2_05                 1 Genannt                                  
     29 q2_06                -2 FILTER                                   
     30 q2_06                 0 Nicht genannt                            
     31 q2_06                 1 Genannt                                  
     32 q2_07                -2 FILTER                                   
     33 q2_07                 0 Nicht genannt                            
     34 q2_07                 1 Genannt                                  
     35 q2_99                -2 FILTER                                   
     36 q2_99                 0 Nicht genannt                            
     37 q2_99                 1 Genannt                                  
     38 q3a                  -2 FILTER                                   
     39 q3b                  -2 FILTER                                   
     40 q3c                  -2 FILTER                                   
     41 q3d                  -2 FILTER                                   
     42 q3e                  -2 FILTER                                   
     43 q3f                  -2 FILTER                                   
     44 q3g                  -2 FILTER                                   
     45 q4                   -3 weiß nicht                               
     46 q4                   -2 FILTER                                   
     47 q4                   -1 keine Angabe                             
     48 q6a                  -2 FILTER                                   
     49 q6a                   1 völlig unwichtig                         
     50 q6a                   2 unwichtig                                
     51 q6a                   3 teils / teils                            
     52 q6a                   4 wichtig                                  
     53 q6a                   5 sehr wichtig                             
     54 q6a                  98 weiß nicht                               
     55 q6a                  99 keine Angabe                             
     56 q6b                  -2 FILTER                                   
     57 q6b                   1 völlig unwichtig                         
     58 q6b                   2 unwichtig                                
     59 q6b                   3 teils / teils                            
     60 q6b                   4 wichtig                                  
     61 q6b                   5 sehr wichtig                             
     62 q6b                  98 weiß nicht                               
     63 q6b                  99 keine Angabe                             
     64 q6c                  -2 FILTER                                   
     65 q6c                   1 völlig unwichtig                         
     66 q6c                   2 unwichtig                                
     67 q6c                   3 teils / teils                            
     68 q6c                   4 wichtig                                  
     69 q6c                   5 sehr wichtig                             
     70 q6c                  98 weiß nicht                               
     71 q6c                  99 keine Angabe                             
     72 q6d                  -2 FILTER                                   
     73 q6d                   1 völlig unwichtig                         
     74 q6d                   2 unwichtig                                
     75 q6d                   3 teils / teils                            
     76 q6d                   4 wichtig                                  
     77 q6d                   5 sehr wichtig                             
     78 q6d                  98 weiß nicht                               
     79 q6d                  99 keine Angabe                             
     80 q6e                  -2 FILTER                                   
     81 q6e                   1 völlig unwichtig                         
     82 q6e                   2 unwichtig                                
     83 q6e                   3 teils / teils                            
     84 q6e                   4 wichtig                                  
     85 q6e                   5 sehr wichtig                             
     86 q6e                  98 weiß nicht                               
     87 q6e                  99 keine Angabe                             
     88 q6f                  -2 FILTER                                   
     89 q6f                   1 völlig unwichtig                         
     90 q6f                   2 unwichtig                                
     91 q6f                   3 teils / teils                            
     92 q6f                   4 wichtig                                  
     93 q6f                   5 sehr wichtig                             
     94 q6f                  98 weiß nicht                               
     95 q6f                  99 keine Angabe                             
     96 q6g                  -2 FILTER                                   
     97 q6g                   1 völlig unwichtig                         
     98 q6g                   2 unwichtig                                
     99 q6g                   3 teils / teils                            
    100 q6g                   4 wichtig                                  
    101 q6g                   5 sehr wichtig                             
    102 q6g                  98 weiß nicht                               
    103 q6g                  99 keine Angabe                             
    104 q6h                  -2 FILTER                                   
    105 q6h                   1 völlig unwichtig                         
    106 q6h                   2 unwichtig                                
    107 q6h                   3 teils / teils                            
    108 q6h                   4 wichtig                                  
    109 q6h                   5 sehr wichtig                             
    110 q6h                  98 weiß nicht                               
    111 q6h                  99 keine Angabe                             
    112 sel1                  1 <NA>                                     
    113 sel1                  2 <NA>                                     
    114 sel1                  3 <NA>                                     
    115 sel1                  4 <NA>                                     
    116 sel1                  5 <NA>                                     
    117 sel1                  6 <NA>                                     
    118 sel1                  7 <NA>                                     
    119 q7a1                 -2 FILTER                                   
    120 q7a1                  1 1 = überhaupt nicht zufrieden            
    121 q7a1                  2 2                                        
    122 q7a1                  3 3                                        
    123 q7a1                  4 4                                        
    124 q7a1                  5 5                                        
    125 q7a1                  6 6                                        
    126 q7a1                  7 7                                        
    127 q7a1                  8 8                                        
    128 q7a1                  9 9                                        
    129 q7a1                 10 10 = außerordentlich zufrieden           
    130 q7a1                 99 keine Angabe                             
    131 q7a2                 -2 FILTER                                   
    132 q7a2                  1 1 = überhaupt nicht zufrieden            
    133 q7a2                  2 2                                        
    134 q7a2                  3 3                                        
    135 q7a2                  4 4                                        
    136 q7a2                  5 5                                        
    137 q7a2                  6 6                                        
    138 q7a2                  7 7                                        
    139 q7a2                  8 8                                        
    140 q7a2                  9 9                                        
    141 q7a2                 10 10 = außerordentlich zufrieden           
    142 q7a2                 99 keine Angabe                             
    143 q7b1                 -2 FILTER                                   
    144 q7b1                  1 1 = überhaupt nicht zufrieden            
    145 q7b1                  2 2                                        
    146 q7b1                  3 3                                        
    147 q7b1                  4 4                                        
    148 q7b1                  5 5                                        
    149 q7b1                  6 6                                        
    150 q7b1                  7 7                                        
    151 q7b1                  8 8                                        
    152 q7b1                  9 9                                        
    153 q7b1                 10 10 = außerordentlich zufrieden           
    154 q7b1                 99 keine Angabe                             
    155 q7b2                 -2 FILTER                                   
    156 q7b2                  1 1 = überhaupt nicht zufrieden            
    157 q7b2                  2 2                                        
    158 q7b2                  3 3                                        
    159 q7b2                  4 4                                        
    160 q7b2                  5 5                                        
    161 q7b2                  6 6                                        
    162 q7b2                  7 7                                        
    163 q7b2                  8 8                                        
    164 q7b2                  9 9                                        
    165 q7b2                 10 10 = außerordentlich zufrieden           
    166 q7b2                 99 keine Angabe                             
    167 q7c1                 -2 FILTER                                   
    168 q7c1                  1 1 = überhaupt nicht zufrieden            
    169 q7c1                  2 2                                        
    170 q7c1                  3 3                                        
    171 q7c1                  4 4                                        
    172 q7c1                  5 5                                        
    173 q7c1                  6 6                                        
    174 q7c1                  7 7                                        
    175 q7c1                  8 8                                        
    176 q7c1                  9 9                                        
    177 q7c1                 10 10 = außerordentlich zufrieden           
    178 q7c1                 99 keine Angabe                             
    179 q7c2                 -2 FILTER                                   
    180 q7c2                  1 1 = überhaupt nicht zufrieden            
    181 q7c2                  2 2                                        
    182 q7c2                  3 3                                        
    183 q7c2                  4 4                                        
    184 q7c2                  5 5                                        
    185 q7c2                  6 6                                        
    186 q7c2                  7 7                                        
    187 q7c2                  8 8                                        
    188 q7c2                  9 9                                        
    189 q7c2                 10 10 = außerordentlich zufrieden           
    190 q7c2                 99 keine Angabe                             
    191 q7d1                 -2 FILTER                                   
    192 q7d1                  1 1 = überhaupt nicht zufrieden            
    193 q7d1                  2 2                                        
    194 q7d1                  3 3                                        
    195 q7d1                  4 4                                        
    196 q7d1                  5 5                                        
    197 q7d1                  6 6                                        
    198 q7d1                  7 7                                        
    199 q7d1                  8 8                                        
    200 q7d1                  9 9                                        
    201 q7d1                 10 10 = außerordentlich zufrieden           
    202 q7d1                 99 keine Angabe                             
    203 q7d2                 -2 FILTER                                   
    204 q7d2                  1 1 = überhaupt nicht zufrieden            
    205 q7d2                  2 2                                        
    206 q7d2                  3 3                                        
    207 q7d2                  4 4                                        
    208 q7d2                  5 5                                        
    209 q7d2                  6 6                                        
    210 q7d2                  7 7                                        
    211 q7d2                  8 8                                        
    212 q7d2                  9 9                                        
    213 q7d2                 10 10 = außerordentlich zufrieden           
    214 q7d2                 99 keine Angabe                             
    215 q7e1                 -2 FILTER                                   
    216 q7e1                  1 1 = überhaupt nicht zufrieden            
    217 q7e1                  2 2                                        
    218 q7e1                  3 3                                        
    219 q7e1                  4 4                                        
    220 q7e1                  5 5                                        
    221 q7e1                  6 6                                        
    222 q7e1                  7 7                                        
    223 q7e1                  8 8                                        
    224 q7e1                  9 9                                        
    225 q7e1                 10 10 = außerordentlich zufrieden           
    226 q7e1                 99 keine Angabe                             
    227 q7e2                 -2 FILTER                                   
    228 q7e2                  1 1 = überhaupt nicht zufrieden            
    229 q7e2                  2 2                                        
    230 q7e2                  3 3                                        
    231 q7e2                  4 4                                        
    232 q7e2                  5 5                                        
    233 q7e2                  6 6                                        
    234 q7e2                  7 7                                        
    235 q7e2                  8 8                                        
    236 q7e2                  9 9                                        
    237 q7e2                 10 10 = außerordentlich zufrieden           
    238 q7e2                 99 keine Angabe                             
    239 q7h1                 -2 FILTER                                   
    240 q7h1                  1 1 = überhaupt nicht zufrieden            
    241 q7h1                  2 2                                        
    242 q7h1                  3 3                                        
    243 q7h1                  4 4                                        
    244 q7h1                  5 5                                        
    245 q7h1                  6 6                                        
    246 q7h1                  7 7                                        
    247 q7h1                  8 8                                        
    248 q7h1                  9 9                                        
    249 q7h1                 10 10 = außerordentlich zufrieden           
    250 q7h1                 99 keine Angabe                             
    251 q7h2                 -2 FILTER                                   
    252 q7h2                  1 1 = überhaupt nicht zufrieden            
    253 q7h2                  2 2                                        
    254 q7h2                  3 3                                        
    255 q7h2                  4 4                                        
    256 q7h2                  5 5                                        
    257 q7h2                  6 6                                        
    258 q7h2                  7 7                                        
    259 q7h2                  8 8                                        
    260 q7h2                  9 9                                        
    261 q7h2                 10 10 = außerordentlich zufrieden           
    262 q7h2                 99 keine Angabe                             
    263 q7f1                 -2 FILTER                                   
    264 q7f1                  1 1 = überhaupt nicht zufrieden            
    265 q7f1                  2 2                                        
    266 q7f1                  3 3                                        
    267 q7f1                  4 4                                        
    268 q7f1                  5 5                                        
    269 q7f1                  6 6                                        
    270 q7f1                  7 7                                        
    271 q7f1                  8 8                                        
    272 q7f1                  9 9                                        
    273 q7f1                 10 10 = außerordentlich zufrieden           
    274 q7f1                 99 keine Angabe                             
    275 q7f2                 -2 FILTER                                   
    276 q7f2                  1 1 = überhaupt nicht zufrieden            
    277 q7f2                  2 2                                        
    278 q7f2                  3 3                                        
    279 q7f2                  4 4                                        
    280 q7f2                  5 5                                        
    281 q7f2                  6 6                                        
    282 q7f2                  7 7                                        
    283 q7f2                  8 8                                        
    284 q7f2                  9 9                                        
    285 q7f2                 10 10 = außerordentlich zufrieden           
    286 q7f2                 99 keine Angabe                             
    287 q7g1                 -2 FILTER                                   
    288 q7g1                  1 1 = überhaupt nicht zufrieden            
    289 q7g1                  2 2                                        
    290 q7g1                  3 3                                        
    291 q7g1                  4 4                                        
    292 q7g1                  5 5                                        
    293 q7g1                  6 6                                        
    294 q7g1                  7 7                                        
    295 q7g1                  8 8                                        
    296 q7g1                  9 9                                        
    297 q7g1                 10 10 = außerordentlich zufrieden           
    298 q7g1                 99 keine Angabe                             
    299 q7g2                 -2 FILTER                                   
    300 q7g2                  1 1 = überhaupt nicht zufrieden            
    301 q7g2                  2 2                                        
    302 q7g2                  3 3                                        
    303 q7g2                  4 4                                        
    304 q7g2                  5 5                                        
    305 q7g2                  6 6                                        
    306 q7g2                  7 7                                        
    307 q7g2                  8 8                                        
    308 q7g2                  9 9                                        
    309 q7g2                 10 10 = außerordentlich zufrieden           
    310 q7g2                 99 keine Angabe                             
    311 q81                  -2 FILTER                                   
    312 q81                   1 1 = überhaupt nicht zufrieden            
    313 q81                   2 2                                        
    314 q81                   3 3                                        
    315 q81                   4 4                                        
    316 q81                   5 5                                        
    317 q81                   6 6                                        
    318 q81                   7 7                                        
    319 q81                   8 8                                        
    320 q81                   9 9                                        
    321 q81                  10 10 = außerordentlich zufrieden           
    322 q81                  99 keine Angabe                             
    323 q82                  -2 FILTER                                   
    324 q82                   1 1 - völlig unzufrieden                   
    325 q82                   2 2                                        
    326 q82                   3 3                                        
    327 q82                   4 4                                        
    328 q82                   5 5                                        
    329 q82                   6 6                                        
    330 q82                   7 7                                        
    331 q82                   8 8                                        
    332 q82                   9 9                                        
    333 q82                  10 10 - absolut zufrieden                   
    334 q82                  99 keine Angabe                             
    335 q91                  -2 FILTER                                   
    336 q91                   0 0 - auf keinen Fall                      
    337 q91                   1 1                                        
    338 q91                   2 2                                        
    339 q91                   3 3                                        
    340 q91                   4 4                                        
    341 q91                   5 5                                        
    342 q91                   6 6                                        
    343 q91                   7 7                                        
    344 q91                   8 8                                        
    345 q91                   9 9                                        
    346 q91                  10 10 - auf jeden Fall                      
    347 q91                  99 keine Angabe                             
    348 q92                  -2 FILTER                                   
    349 q92                   0 0 - auf keinen Fall                      
    350 q92                   1 1                                        
    351 q92                   2 2                                        
    352 q92                   3 3                                        
    353 q92                   4 4                                        
    354 q92                   5 5                                        
    355 q92                   6 6                                        
    356 q92                   7 7                                        
    357 q92                   8 8                                        
    358 q92                   9 9                                        
    359 q92                  10 10 - auf jeden Fall                      
    360 q92                  99 keine Angabe                             
    361 q10                  -3 weiß nicht                               
    362 q10                  -2 FILTER                                   
    363 q10                  -1 keine Angabe                             
    364 regio                -2 FILTER                                   
    365 regio                 1 Asien                                    
    366 regio                 2 Europa                                   
    367 regio                 3 Nordamerika                              
    368 regio                 4 Pazifik                                  
    369 sel0                  1 <NA>                                     
    370 sel0                  2 <NA>                                     
    371 sel0                  3 <NA>                                     
    372 sel0                  4 <NA>                                     
    373 sel0                  5 <NA>                                     
    374 sel0                  6 <NA>                                     
    375 sel0                  7 <NA>                                     
    376 kq4                   1 1-2mal                                   
    377 kq4                   2 3-5mal                                   
    378 kq4                   3 >5mal                                    
    379 kq10                  1 18 bis 39                                
    380 kq10                  2 40 bis 49                                
    381 kq10                  3 50 und älter                             
    382 kq4xkq10k10           1 1-2mal                                   
    383 kq4xkq10k10           2 3-5mal                                   
    384 kq4xkq10k10           3 >5mal                                    
    385 kq4xkq10k20           1 1-2mal                                   
    386 kq4xkq10k20           2 3-5mal                                   
    387 kq4xkq10k20           3 >5mal                                    
    388 kq4xkq10k30           1 1-2mal                                   
    389 kq4xkq10k30           2 3-5mal                                   
    390 kq4xkq10k30           3 >5mal                                    
    391 kq4xregiok10          1 1-2mal                                   
    392 kq4xregiok10          2 3-5mal                                   
    393 kq4xregiok10          3 >5mal                                    
    394 kq4xregiok20          1 1-2mal                                   
    395 kq4xregiok20          2 3-5mal                                   
    396 kq4xregiok20          3 >5mal                                    
    397 kq4xregiok30          1 1-2mal                                   
    398 kq4xregiok30          2 3-5mal                                   
    399 kq4xregiok30          3 >5mal                                    
    400 kq4xregiok40          1 1-2mal                                   
    401 kq4xregiok40          2 3-5mal                                   
    402 kq4xregiok40          3 >5mal                                    
    403 kq4xregiokminus20     1 1-2mal                                   
    404 kq4xregiokminus20     2 3-5mal                                   
    405 kq4xregiokminus20     3 >5mal                                    
    406 q5n1                  1 Freundlichkeit des Tabellenbanderstellers
    407 q5n1                  2 Kompetenz                                
    408 q5n1                  3 Schnelligkeit der Umsetzung              
    409 q5n1                  4 Darstellung der Daten                    
    410 q5n1                  5 einfache Weiterverarbeitung der Daten    
    411 q5n1                 97 Sonstiges                                
    412 q5n1                 99 Keine Angabe                             
    413 q5n2                  1 Freundlichkeit des Tabellenbanderstellers
    414 q5n2                  2 Kompetenz                                
    415 q5n2                  3 Schnelligkeit der Umsetzung              
    416 q5n2                  4 Darstellung der Daten                    
    417 q5n2                  5 einfache Weiterverarbeitung der Daten    
    418 q5n2                 97 Sonstiges                                
    419 q5n2                 99 Keine Angabe                             
    420 q5n3                  1 Freundlichkeit des Tabellenbanderstellers
    421 q5n3                  2 Kompetenz                                
    422 q5n3                  3 Schnelligkeit der Umsetzung              
    423 q5n3                  4 Darstellung der Daten                    
    424 q5n3                  5 einfache Weiterverarbeitung der Daten    
    425 q5n3                 97 Sonstiges                                
    426 q5n3                 99 Keine Angabe                             
    427 q5n4                  1 Freundlichkeit des Tabellenbanderstellers
    428 q5n4                  2 Kompetenz                                
    429 q5n4                  3 Schnelligkeit der Umsetzung              
    430 q5n4                  4 Darstellung der Daten                    
    431 q5n4                  5 einfache Weiterverarbeitung der Daten    
    432 q5n4                 97 Sonstiges                                
    433 q5n4                 99 Keine Angabe                             
    434 q5n5                  1 Freundlichkeit des Tabellenbanderstellers
    435 q5n5                  2 Kompetenz                                
    436 q5n5                  3 Schnelligkeit der Umsetzung              
    437 q5n5                  4 Darstellung der Daten                    
    438 q5n5                  5 einfache Weiterverarbeitung der Daten    
    439 q5n5                 97 Sonstiges                                
    440 q5n5                 99 Keine Angabe                             

# variable labels are reproduced

    # A tibble: 60 x 2
       var               varlab                                                     
       <chr>             <chr>                                                      
     1 q1                1. Wie viele Mitarbeiter beschäftigt Ihr Unternehmen?      
     2 q2_00             2. Welche Art von Studien führen Sie mit dem Tabellenbandt~
     3 q2_01             Kundenzufriedenheit                                        
     4 q2_02             Kundenzufriedenheit                                        
     5 q2_03             Marktvolumen                                               
     6 q2_04             Onlineauftritte                                            
     7 q2_05             Branchenbarometer                                          
     8 q2_06             Strukturanalyse                                            
     9 q2_07             Werbewirkungsmessung                                       
    10 q2_99             Sonstige                                                   
    11 q3a               Kundenzufriedenheit                                        
    12 q3b               Marktvolumen                                               
    13 q3c               Onlineauftritte                                            
    14 q3d               Branchenbarometer                                          
    15 q3e               Strukturanalyse                                            
    16 q3f               Werbewirkungsmessung                                       
    17 q3g               Sonstige                                                   
    18 q4                4. Wie häufig haben Sie einen Tabellenband in den letzten ~
    19 q6a               Schnelle Umsetzung                                         
    20 q6b               Kurzfristige Anpassungen                                   
    21 q6c               Korrektheit der Daten                                      
    22 q6d               Freundlichkeit der Tabellenbandersteller                   
    23 q6e               Langfristige Zusammenarbeit                                
    24 q6f               Gute telefonische Erreichbarkeit                           
    25 q6g               Wochenenderreichbarkeit                                    
    26 q6h               Einhaltung von Zusagen                                     
    27 sel1              Abgefragte Studienarten                                    
    28 q7a1              Schnelle Umsetzung                                         
    29 q7a2              Schnelle Umsetzung                                         
    30 q7b1              Kurzfristige Anpassungen                                   
    31 q7b2              Kurzfristige Anpassungen                                   
    32 q7c1              Korrektheit der Daten                                      
    33 q7c2              Korrektheit der Daten                                      
    34 q7d1              Freundlichkeit der Tabellenbandersteller                   
    35 q7d2              Freundlichkeit der Tabellenbandersteller                   
    36 q7e1              Langfristige Zusammenarbeit                                
    37 q7e2              Langfristige Zusammenarbeit                                
    38 q7h1              Gute telefonische Erreichbarkeit                           
    39 q7h2              Gute telefonische Erreichbarkeit                           
    40 q7f1              Wochenenderreichbarkeit                                    
    41 q7f2              Wochenenderreichbarkeit                                    
    42 q7g1              Einhaltung von Zusagen                                     
    43 q7g2              Einhaltung von Zusagen                                     
    44 q81               7. Wie zufrieden sind Sie mit dem Tabellenbandtool insgesa~
    45 q82               7. Wie zufrieden sind Sie mit dem Tabellenbandtool insgesa~
    46 q91               8. Würden Sie das Tabellenbandtool weiterempfehlen?        
    47 q92               8. Würden Sie das Tabellenbandtool weiterempfehlen?        
    48 q10               9. Dürfte ich Sie noch nach Ihrem Alter fragen?            
    49 regio             Region                                                     
    50 sel0              Abgefragte Studienarten                                    
    51 kq4               Tabellenbände pro Jahr                                     
    52 kq10              Alter                                                      
    53 kq4xkq10k10       18 bis 39: Tabellenbände pro Jahr                          
    54 kq4xkq10k20       40 bis 49: Tabellenbände pro Jahr                          
    55 kq4xkq10k30       50 und älter: Tabellenbände pro Jahr                       
    56 kq4xregiok10      Asien: Tabellenbände pro Jahr                              
    57 kq4xregiok20      Europa: Tabellenbände pro Jahr                             
    58 kq4xregiok30      Nordamerika: Tabellenbände pro Jahr                        
    59 kq4xregiok40      Pazifik: Tabellenbände pro Jahr                            
    60 kq4xregiokminus20 FILTER: Tabellenbände pro Jahr                             

