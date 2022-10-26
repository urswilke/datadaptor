# gen_data_table() works

    # A tibble: 159 x 8
        var   double integer character              Freq vallab     type      varlab
        <chr>  <dbl>   <int> <chr>                 <int> <chr>      <chr>     <chr> 
      1 q1         1      NA <NA>                     13 not at all double    How m~
      2 q1         2      NA <NA>                     16 a bit      double    How m~
      3 q1         3      NA <NA>                     18 normal     double    How m~
      4 q1         4      NA <NA>                     16 much       double    How m~
      5 q1         5      NA <NA>                     14 very much  double    How m~
      6 q1        99      NA <NA>                     18 no answer  double    How m~
      7 q2         1      NA <NA>                     28 yes        double    Do yo~
      8 q2         2      NA <NA>                     37 no         double    Do yo~
      9 q2        99      NA <NA>                     31 no answer  double    Do yo~
     10 q3         1      NA <NA>                     17 not at all double    How l~
     11 q3         2      NA <NA>                     22 a bit      double    How l~
     12 q3         3      NA <NA>                     15 normal     double    How l~
     13 q3         4      NA <NA>                     19 much       double    How l~
     14 q3         5      NA <NA>                     18 very much  double    How l~
     15 q3        99      NA <NA>                      7 no answer  double    How l~
     16 q4         1      NA <NA>                     15 not at all double    How m~
     17 q4         2      NA <NA>                     18 a bit      double    How m~
     18 q4         3      NA <NA>                     19 normal     double    How m~
     19 q4         4      NA <NA>                     18 much       double    How m~
     20 q4         5      NA <NA>                     14 very much  double    How m~
     21 q4        99      NA <NA>                     13 no answer  double    How m~
     22 q5         1      NA <NA>                     15 not at all double    How m~
     23 q5         2      NA <NA>                     22 a bit      double    How m~
     24 q5         3      NA <NA>                     17 normal     double    How m~
     25 q5         4      NA <NA>                     20 much       double    How m~
     26 q5         5      NA <NA>                     13 very much  double    How m~
     27 q5        99      NA <NA>                     10 no answer  double    How m~
     28 id        NA       1 <NA>                      1 <NA>       integer   <NA>  
     29 id        NA       2 <NA>                      1 <NA>       integer   <NA>  
     30 id        NA       3 <NA>                      1 <NA>       integer   <NA>  
     31 id        NA       4 <NA>                      1 <NA>       integer   <NA>  
     32 id        NA       5 <NA>                      1 <NA>       integer   <NA>  
     33 id        NA       6 <NA>                      1 <NA>       integer   <NA>  
     34 id        NA       7 <NA>                      1 <NA>       integer   <NA>  
     35 id        NA       8 <NA>                      1 <NA>       integer   <NA>  
     36 id        NA       9 <NA>                      1 <NA>       integer   <NA>  
     37 id        NA      10 <NA>                      1 <NA>       integer   <NA>  
     38 id        NA      11 <NA>                      1 <NA>       integer   <NA>  
     39 id        NA      12 <NA>                      1 <NA>       integer   <NA>  
     40 id        NA      13 <NA>                      1 <NA>       integer   <NA>  
     41 id        NA      14 <NA>                      1 <NA>       integer   <NA>  
     42 id        NA      15 <NA>                      1 <NA>       integer   <NA>  
     43 id        NA      16 <NA>                      1 <NA>       integer   <NA>  
     44 id        NA      17 <NA>                      1 <NA>       integer   <NA>  
     45 id        NA      18 <NA>                      1 <NA>       integer   <NA>  
     46 id        NA      19 <NA>                      1 <NA>       integer   <NA>  
     47 id        NA      20 <NA>                      1 <NA>       integer   <NA>  
     48 id        NA      21 <NA>                      1 <NA>       integer   <NA>  
     49 id        NA      22 <NA>                      1 <NA>       integer   <NA>  
     50 id        NA      23 <NA>                      1 <NA>       integer   <NA>  
     51 id        NA      24 <NA>                      1 <NA>       integer   <NA>  
     52 id        NA      25 <NA>                      1 <NA>       integer   <NA>  
     53 id        NA      26 <NA>                      1 <NA>       integer   <NA>  
     54 id        NA      27 <NA>                      1 <NA>       integer   <NA>  
     55 id        NA      28 <NA>                      1 <NA>       integer   <NA>  
     56 id        NA      29 <NA>                      1 <NA>       integer   <NA>  
     57 id        NA      30 <NA>                      1 <NA>       integer   <NA>  
     58 id        NA      31 <NA>                      1 <NA>       integer   <NA>  
     59 id        NA      32 <NA>                      1 <NA>       integer   <NA>  
     60 id        NA      33 <NA>                      1 <NA>       integer   <NA>  
     61 id        NA      34 <NA>                      1 <NA>       integer   <NA>  
     62 id        NA      35 <NA>                      1 <NA>       integer   <NA>  
     63 id        NA      36 <NA>                      1 <NA>       integer   <NA>  
     64 id        NA      37 <NA>                      1 <NA>       integer   <NA>  
     65 id        NA      38 <NA>                      1 <NA>       integer   <NA>  
     66 id        NA      39 <NA>                      1 <NA>       integer   <NA>  
     67 id        NA      40 <NA>                      1 <NA>       integer   <NA>  
     68 id        NA      41 <NA>                      1 <NA>       integer   <NA>  
     69 id        NA      42 <NA>                      1 <NA>       integer   <NA>  
     70 id        NA      43 <NA>                      1 <NA>       integer   <NA>  
     71 id        NA      44 <NA>                      1 <NA>       integer   <NA>  
     72 id        NA      45 <NA>                      1 <NA>       integer   <NA>  
     73 id        NA      46 <NA>                      1 <NA>       integer   <NA>  
     74 id        NA      47 <NA>                      1 <NA>       integer   <NA>  
     75 id        NA      48 <NA>                      1 <NA>       integer   <NA>  
     76 id        NA      49 <NA>                      1 <NA>       integer   <NA>  
     77 id        NA      50 <NA>                      1 <NA>       integer   <NA>  
     78 id        NA      51 <NA>                      1 <NA>       integer   <NA>  
     79 id        NA      52 <NA>                      1 <NA>       integer   <NA>  
     80 id        NA      53 <NA>                      1 <NA>       integer   <NA>  
     81 id        NA      54 <NA>                      1 <NA>       integer   <NA>  
     82 id        NA      55 <NA>                      1 <NA>       integer   <NA>  
     83 id        NA      56 <NA>                      1 <NA>       integer   <NA>  
     84 id        NA      57 <NA>                      1 <NA>       integer   <NA>  
     85 id        NA      58 <NA>                      1 <NA>       integer   <NA>  
     86 id        NA      59 <NA>                      1 <NA>       integer   <NA>  
     87 id        NA      60 <NA>                      1 <NA>       integer   <NA>  
     88 id        NA      61 <NA>                      1 <NA>       integer   <NA>  
     89 id        NA      62 <NA>                      1 <NA>       integer   <NA>  
     90 id        NA      63 <NA>                      1 <NA>       integer   <NA>  
     91 id        NA      64 <NA>                      1 <NA>       integer   <NA>  
     92 id        NA      65 <NA>                      1 <NA>       integer   <NA>  
     93 id        NA      66 <NA>                      1 <NA>       integer   <NA>  
     94 id        NA      67 <NA>                      1 <NA>       integer   <NA>  
     95 id        NA      68 <NA>                      1 <NA>       integer   <NA>  
     96 id        NA      69 <NA>                      1 <NA>       integer   <NA>  
     97 id        NA      70 <NA>                      1 <NA>       integer   <NA>  
     98 id        NA      71 <NA>                      1 <NA>       integer   <NA>  
     99 id        NA      72 <NA>                      1 <NA>       integer   <NA>  
    100 id        NA      73 <NA>                      1 <NA>       integer   <NA>  
    101 id        NA      74 <NA>                      1 <NA>       integer   <NA>  
    102 id        NA      75 <NA>                      1 <NA>       integer   <NA>  
    103 id        NA      76 <NA>                      1 <NA>       integer   <NA>  
    104 id        NA      77 <NA>                      1 <NA>       integer   <NA>  
    105 id        NA      78 <NA>                      1 <NA>       integer   <NA>  
    106 id        NA      79 <NA>                      1 <NA>       integer   <NA>  
    107 id        NA      80 <NA>                      1 <NA>       integer   <NA>  
    108 id        NA      81 <NA>                      1 <NA>       integer   <NA>  
    109 id        NA      82 <NA>                      1 <NA>       integer   <NA>  
    110 id        NA      83 <NA>                      1 <NA>       integer   <NA>  
    111 id        NA      84 <NA>                      1 <NA>       integer   <NA>  
    112 id        NA      85 <NA>                      1 <NA>       integer   <NA>  
    113 id        NA      86 <NA>                      1 <NA>       integer   <NA>  
    114 id        NA      87 <NA>                      1 <NA>       integer   <NA>  
    115 id        NA      88 <NA>                      1 <NA>       integer   <NA>  
    116 id        NA      89 <NA>                      1 <NA>       integer   <NA>  
    117 id        NA      90 <NA>                      1 <NA>       integer   <NA>  
    118 id        NA      91 <NA>                      1 <NA>       integer   <NA>  
    119 id        NA      92 <NA>                      1 <NA>       integer   <NA>  
    120 id        NA      93 <NA>                      1 <NA>       integer   <NA>  
    121 id        NA      94 <NA>                      1 <NA>       integer   <NA>  
    122 id        NA      95 <NA>                      1 <NA>       integer   <NA>  
    123 id        NA      96 <NA>                      1 <NA>       integer   <NA>  
    124 id        NA      97 <NA>                      1 <NA>       integer   <NA>  
    125 id        NA      98 <NA>                      1 <NA>       integer   <NA>  
    126 id        NA      99 <NA>                      1 <NA>       integer   <NA>  
    127 id        NA     100 <NA>                      1 <NA>       integer   <NA>  
    128 q6        NA      NA bla bla bla happiness    10 <NA>       character Tell ~
    129 q6        NA      NA bla bla bla joy           8 <NA>       character Tell ~
    130 q6        NA      NA bla bla bla love         11 <NA>       character Tell ~
    131 q6        NA      NA bla bla happiness        10 <NA>       character Tell ~
    132 q6        NA      NA bla bla joy              19 <NA>       character Tell ~
    133 q6        NA      NA bla bla love              9 <NA>       character Tell ~
    134 q6        NA      NA bla happiness             8 <NA>       character Tell ~
    135 q6        NA      NA bla joy                  14 <NA>       character Tell ~
    136 q6        NA      NA bla love                 11 <NA>       character Tell ~
    137 q7        NA      NA bla anger                 9 <NA>       character Tell ~
    138 q7        NA      NA bla bla anger             9 <NA>       character Tell ~
    139 q7        NA      NA bla bla bla anger        11 <NA>       character Tell ~
    140 q7        NA      NA bla bla bla fear          6 <NA>       character Tell ~
    141 q7        NA      NA bla bla bla pain          7 <NA>       character Tell ~
    142 q7        NA      NA bla bla bla sadness       6 <NA>       character Tell ~
    143 q7        NA      NA bla bla fear              7 <NA>       character Tell ~
    144 q7        NA      NA bla bla pain              7 <NA>       character Tell ~
    145 q7        NA      NA bla bla sadness          11 <NA>       character Tell ~
    146 q7        NA      NA bla fear                 14 <NA>       character Tell ~
    147 q7        NA      NA bla pain                 11 <NA>       character Tell ~
    148 q7        NA      NA bla sadness               2 <NA>       character Tell ~
    149 q8        NA      NA 1                        10 <NA>       character A num~
    150 q8        NA      NA 10                       13 <NA>       character A num~
    151 q8        NA      NA 2                         6 <NA>       character A num~
    152 q8        NA      NA 3                        12 <NA>       character A num~
    153 q8        NA      NA 4                        12 <NA>       character A num~
    154 q8        NA      NA 5                         6 <NA>       character A num~
    155 q8        NA      NA 6                         7 <NA>       character A num~
    156 q8        NA      NA 7                        10 <NA>       character A num~
    157 q8        NA      NA 8                        13 <NA>       character A num~
    158 q8        NA      NA 9                        11 <NA>       character A num~
    159 q9        NA      NA <NA>                     NA <NA>       double    <NA>  

