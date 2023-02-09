# gen_data_table() works

    # A tibble: 164 x 7
        var   double character              Freq vallab     type      varlab        
        <chr>  <dbl> <chr>                 <int> <chr>      <chr>     <chr>         
      1 q1         1 <NA>                     13 not at all double    How much do y~
      2 q1         2 <NA>                     16 a bit      double    How much do y~
      3 q1         3 <NA>                     18 normal     double    How much do y~
      4 q1         4 <NA>                     16 much       double    How much do y~
      5 q1         5 <NA>                     14 very much  double    How much do y~
      6 q1        99 <NA>                     18 no answer  double    How much do y~
      7 q1        NA <NA>                      5 <NA>       double    How much do y~
      8 q2         1 <NA>                     28 yes        double    Do you want t~
      9 q2         2 <NA>                     37 no         double    Do you want t~
     10 q2        99 <NA>                     31 no answer  double    Do you want t~
     11 q2        NA <NA>                      4 <NA>       double    Do you want t~
     12 q3         1 <NA>                     17 not at all double    How likely wi~
     13 q3         2 <NA>                     22 a bit      double    How likely wi~
     14 q3         3 <NA>                     15 normal     double    How likely wi~
     15 q3         4 <NA>                     19 much       double    How likely wi~
     16 q3         5 <NA>                     18 very much  double    How likely wi~
     17 q3        99 <NA>                      7 no answer  double    How likely wi~
     18 q3        NA <NA>                      2 <NA>       double    How likely wi~
     19 q4         1 <NA>                     15 not at all double    How much do y~
     20 q4         2 <NA>                     18 a bit      double    How much do y~
     21 q4         3 <NA>                     19 normal     double    How much do y~
     22 q4         4 <NA>                     18 much       double    How much do y~
     23 q4         5 <NA>                     14 very much  double    How much do y~
     24 q4        99 <NA>                     13 no answer  double    How much do y~
     25 q4        NA <NA>                      3 <NA>       double    How much do y~
     26 q5         1 <NA>                     15 not at all double    How much do y~
     27 q5         2 <NA>                     22 a bit      double    How much do y~
     28 q5         3 <NA>                     17 normal     double    How much do y~
     29 q5         4 <NA>                     20 much       double    How much do y~
     30 q5         5 <NA>                     13 very much  double    How much do y~
     31 q5        99 <NA>                     10 no answer  double    How much do y~
     32 q5        NA <NA>                      3 <NA>       double    How much do y~
     33 id         1 <NA>                      1 <NA>       double    <NA>          
     34 id         2 <NA>                      1 <NA>       double    <NA>          
     35 id         3 <NA>                      1 <NA>       double    <NA>          
     36 id         4 <NA>                      1 <NA>       double    <NA>          
     37 id         5 <NA>                      1 <NA>       double    <NA>          
     38 id         6 <NA>                      1 <NA>       double    <NA>          
     39 id         7 <NA>                      1 <NA>       double    <NA>          
     40 id         8 <NA>                      1 <NA>       double    <NA>          
     41 id         9 <NA>                      1 <NA>       double    <NA>          
     42 id        10 <NA>                      1 <NA>       double    <NA>          
     43 id        11 <NA>                      1 <NA>       double    <NA>          
     44 id        12 <NA>                      1 <NA>       double    <NA>          
     45 id        13 <NA>                      1 <NA>       double    <NA>          
     46 id        14 <NA>                      1 <NA>       double    <NA>          
     47 id        15 <NA>                      1 <NA>       double    <NA>          
     48 id        16 <NA>                      1 <NA>       double    <NA>          
     49 id        17 <NA>                      1 <NA>       double    <NA>          
     50 id        18 <NA>                      1 <NA>       double    <NA>          
     51 id        19 <NA>                      1 <NA>       double    <NA>          
     52 id        20 <NA>                      1 <NA>       double    <NA>          
     53 id        21 <NA>                      1 <NA>       double    <NA>          
     54 id        22 <NA>                      1 <NA>       double    <NA>          
     55 id        23 <NA>                      1 <NA>       double    <NA>          
     56 id        24 <NA>                      1 <NA>       double    <NA>          
     57 id        25 <NA>                      1 <NA>       double    <NA>          
     58 id        26 <NA>                      1 <NA>       double    <NA>          
     59 id        27 <NA>                      1 <NA>       double    <NA>          
     60 id        28 <NA>                      1 <NA>       double    <NA>          
     61 id        29 <NA>                      1 <NA>       double    <NA>          
     62 id        30 <NA>                      1 <NA>       double    <NA>          
     63 id        31 <NA>                      1 <NA>       double    <NA>          
     64 id        32 <NA>                      1 <NA>       double    <NA>          
     65 id        33 <NA>                      1 <NA>       double    <NA>          
     66 id        34 <NA>                      1 <NA>       double    <NA>          
     67 id        35 <NA>                      1 <NA>       double    <NA>          
     68 id        36 <NA>                      1 <NA>       double    <NA>          
     69 id        37 <NA>                      1 <NA>       double    <NA>          
     70 id        38 <NA>                      1 <NA>       double    <NA>          
     71 id        39 <NA>                      1 <NA>       double    <NA>          
     72 id        40 <NA>                      1 <NA>       double    <NA>          
     73 id        41 <NA>                      1 <NA>       double    <NA>          
     74 id        42 <NA>                      1 <NA>       double    <NA>          
     75 id        43 <NA>                      1 <NA>       double    <NA>          
     76 id        44 <NA>                      1 <NA>       double    <NA>          
     77 id        45 <NA>                      1 <NA>       double    <NA>          
     78 id        46 <NA>                      1 <NA>       double    <NA>          
     79 id        47 <NA>                      1 <NA>       double    <NA>          
     80 id        48 <NA>                      1 <NA>       double    <NA>          
     81 id        49 <NA>                      1 <NA>       double    <NA>          
     82 id        50 <NA>                      1 <NA>       double    <NA>          
     83 id        51 <NA>                      1 <NA>       double    <NA>          
     84 id        52 <NA>                      1 <NA>       double    <NA>          
     85 id        53 <NA>                      1 <NA>       double    <NA>          
     86 id        54 <NA>                      1 <NA>       double    <NA>          
     87 id        55 <NA>                      1 <NA>       double    <NA>          
     88 id        56 <NA>                      1 <NA>       double    <NA>          
     89 id        57 <NA>                      1 <NA>       double    <NA>          
     90 id        58 <NA>                      1 <NA>       double    <NA>          
     91 id        59 <NA>                      1 <NA>       double    <NA>          
     92 id        60 <NA>                      1 <NA>       double    <NA>          
     93 id        61 <NA>                      1 <NA>       double    <NA>          
     94 id        62 <NA>                      1 <NA>       double    <NA>          
     95 id        63 <NA>                      1 <NA>       double    <NA>          
     96 id        64 <NA>                      1 <NA>       double    <NA>          
     97 id        65 <NA>                      1 <NA>       double    <NA>          
     98 id        66 <NA>                      1 <NA>       double    <NA>          
     99 id        67 <NA>                      1 <NA>       double    <NA>          
    100 id        68 <NA>                      1 <NA>       double    <NA>          
    101 id        69 <NA>                      1 <NA>       double    <NA>          
    102 id        70 <NA>                      1 <NA>       double    <NA>          
    103 id        71 <NA>                      1 <NA>       double    <NA>          
    104 id        72 <NA>                      1 <NA>       double    <NA>          
    105 id        73 <NA>                      1 <NA>       double    <NA>          
    106 id        74 <NA>                      1 <NA>       double    <NA>          
    107 id        75 <NA>                      1 <NA>       double    <NA>          
    108 id        76 <NA>                      1 <NA>       double    <NA>          
    109 id        77 <NA>                      1 <NA>       double    <NA>          
    110 id        78 <NA>                      1 <NA>       double    <NA>          
    111 id        79 <NA>                      1 <NA>       double    <NA>          
    112 id        80 <NA>                      1 <NA>       double    <NA>          
    113 id        81 <NA>                      1 <NA>       double    <NA>          
    114 id        82 <NA>                      1 <NA>       double    <NA>          
    115 id        83 <NA>                      1 <NA>       double    <NA>          
    116 id        84 <NA>                      1 <NA>       double    <NA>          
    117 id        85 <NA>                      1 <NA>       double    <NA>          
    118 id        86 <NA>                      1 <NA>       double    <NA>          
    119 id        87 <NA>                      1 <NA>       double    <NA>          
    120 id        88 <NA>                      1 <NA>       double    <NA>          
    121 id        89 <NA>                      1 <NA>       double    <NA>          
    122 id        90 <NA>                      1 <NA>       double    <NA>          
    123 id        91 <NA>                      1 <NA>       double    <NA>          
    124 id        92 <NA>                      1 <NA>       double    <NA>          
    125 id        93 <NA>                      1 <NA>       double    <NA>          
    126 id        94 <NA>                      1 <NA>       double    <NA>          
    127 id        95 <NA>                      1 <NA>       double    <NA>          
    128 id        96 <NA>                      1 <NA>       double    <NA>          
    129 id        97 <NA>                      1 <NA>       double    <NA>          
    130 id        98 <NA>                      1 <NA>       double    <NA>          
    131 id        99 <NA>                      1 <NA>       double    <NA>          
    132 id       100 <NA>                      1 <NA>       double    <NA>          
    133 q6        NA bla bla bla happiness    10 <NA>       character Tell me somet~
    134 q6        NA bla bla bla joy           8 <NA>       character Tell me somet~
    135 q6        NA bla bla bla love         11 <NA>       character Tell me somet~
    136 q6        NA bla bla happiness        10 <NA>       character Tell me somet~
    137 q6        NA bla bla joy              19 <NA>       character Tell me somet~
    138 q6        NA bla bla love              9 <NA>       character Tell me somet~
    139 q6        NA bla happiness             8 <NA>       character Tell me somet~
    140 q6        NA bla joy                  14 <NA>       character Tell me somet~
    141 q6        NA bla love                 11 <NA>       character Tell me somet~
    142 q7        NA bla anger                 9 <NA>       character Tell me somet~
    143 q7        NA bla bla anger             9 <NA>       character Tell me somet~
    144 q7        NA bla bla bla anger        11 <NA>       character Tell me somet~
    145 q7        NA bla bla bla fear          6 <NA>       character Tell me somet~
    146 q7        NA bla bla bla pain          7 <NA>       character Tell me somet~
    147 q7        NA bla bla bla sadness       6 <NA>       character Tell me somet~
    148 q7        NA bla bla fear              7 <NA>       character Tell me somet~
    149 q7        NA bla bla pain              7 <NA>       character Tell me somet~
    150 q7        NA bla bla sadness          11 <NA>       character Tell me somet~
    151 q7        NA bla fear                 14 <NA>       character Tell me somet~
    152 q7        NA bla pain                 11 <NA>       character Tell me somet~
    153 q7        NA bla sadness               2 <NA>       character Tell me somet~
    154 q8        NA 1                        10 <NA>       character A numeric var~
    155 q8        NA 10                       13 <NA>       character A numeric var~
    156 q8        NA 2                         6 <NA>       character A numeric var~
    157 q8        NA 3                        12 <NA>       character A numeric var~
    158 q8        NA 4                        12 <NA>       character A numeric var~
    159 q8        NA 5                         6 <NA>       character A numeric var~
    160 q8        NA 6                         7 <NA>       character A numeric var~
    161 q8        NA 7                        10 <NA>       character A numeric var~
    162 q8        NA 8                        13 <NA>       character A numeric var~
    163 q8        NA 9                        11 <NA>       character A numeric var~
    164 q9        NA <NA>                    100 <NA>       double    <NA>          

# diff_data() works

    # A tibble: 64 x 12
       var   doubl~1 chara~2 valla~3 type_~4 varla~5 doubl~6 chara~7 valla~8 type_~9
       <fct>   <dbl> <chr>   <chr>   <chr>   <chr>     <dbl> <chr>   <chr>   <chr>  
     1 q1          1 <NA>    not at~ double  How mu~       1 <NA>    not at~ double 
     2 q1          2 <NA>    a bit   double  How mu~       2 <NA>    a bit   double 
     3 q1          3 <NA>    normal  double  How mu~       3 <NA>    normal  double 
     4 q1          4 <NA>    much    double  How mu~       4 <NA>    much    double 
     5 q1          5 <NA>    very m~ double  How mu~       5 <NA>    very m~ double 
     6 q1         99 <NA>    no ans~ double  How mu~      NA <NA>    <NA>    double 
     7 q1         NA <NA>    <NA>    double  How mu~      NA <NA>    <NA>    double 
     8 q2          1 <NA>    yes     double  Do you~       1 <NA>    yes     double 
     9 q2          2 <NA>    no      double  Do you~       2 <NA>    no      double 
    10 q2         99 <NA>    no ans~ double  Do you~      99 <NA>    no ans~ double 
    11 q2         NA <NA>    <NA>    double  Do you~      NA <NA>    <NA>    double 
    12 q3          1 <NA>    not at~ double  How li~       1 <NA>    not at~ double 
    13 q3          2 <NA>    a bit   double  How li~       2 <NA>    a bit   double 
    14 q3          3 <NA>    normal  double  How li~       3 <NA>    normal  double 
    15 q3          4 <NA>    much    double  How li~       4 <NA>    much    double 
    16 q3          5 <NA>    very m~ double  How li~       5 <NA>    very m~ double 
    17 q3         99 <NA>    no ans~ double  How li~      99 <NA>    no ans~ double 
    18 q3         NA <NA>    <NA>    double  How li~      -2 <NA>    FILTER  double 
    19 q4          1 <NA>    not at~ double  How mu~       1 <NA>    not at~ double 
    20 q4          2 <NA>    a bit   double  How mu~       2 <NA>    a bit   double 
    21 q4          3 <NA>    normal  double  How mu~       3 <NA>    normal  double 
    22 q4          4 <NA>    much    double  How mu~       4 <NA>    much    double 
    23 q4          5 <NA>    very m~ double  How mu~       5 <NA>    very m~ double 
    24 q4         99 <NA>    no ans~ double  How mu~      99 <NA>    no ans~ double 
    25 q4         NA <NA>    <NA>    double  How mu~      -2 <NA>    FILTER  double 
    26 q5          1 <NA>    not at~ double  How mu~       1 <NA>    not at~ double 
    27 q5          2 <NA>    a bit   double  How mu~       2 <NA>    a bit   double 
    28 q5          3 <NA>    normal  double  How mu~       3 <NA>    normal  double 
    29 q5          4 <NA>    much    double  How mu~       4 <NA>    much    double 
    30 q5          5 <NA>    very m~ double  How mu~       5 <NA>    very m~ double 
    31 q5         99 <NA>    no ans~ double  How mu~      99 <NA>    no ans~ double 
    32 q5         NA <NA>    <NA>    double  How mu~      NA <NA>    <NA>    double 
    33 q6         NA bla bl~ <NA>    charac~ Tell m~       1 <NA>    bla bl~ double 
    34 q6         NA bla bl~ <NA>    charac~ Tell m~       2 <NA>    bla bl~ double 
    35 q6         NA bla bl~ <NA>    charac~ Tell m~       3 <NA>    bla bl~ double 
    36 q6         NA bla bl~ <NA>    charac~ Tell m~       4 <NA>    bla bl~ double 
    37 q6         NA bla bl~ <NA>    charac~ Tell m~       5 <NA>    bla bl~ double 
    38 q6         NA bla bl~ <NA>    charac~ Tell m~       6 <NA>    bla bl~ double 
    39 q6         NA bla ha~ <NA>    charac~ Tell m~       7 <NA>    bla ha~ double 
    40 q6         NA bla joy <NA>    charac~ Tell m~       8 <NA>    bla joy double 
    41 q6         NA bla lo~ <NA>    charac~ Tell m~       9 <NA>    bla lo~ double 
    42 q7         NA bla an~ <NA>    charac~ Tell m~      NA bla an~ <NA>    charac~
    43 q7         NA bla bl~ <NA>    charac~ Tell m~      NA bla bl~ <NA>    charac~
    44 q7         NA bla bl~ <NA>    charac~ Tell m~      NA bla bl~ <NA>    charac~
    45 q7         NA bla bl~ <NA>    charac~ Tell m~      NA bla bl~ <NA>    charac~
    46 q7         NA bla bl~ <NA>    charac~ Tell m~      NA bla bl~ <NA>    charac~
    47 q7         NA bla bl~ <NA>    charac~ Tell m~      NA bla bl~ <NA>    charac~
    48 q7         NA bla bl~ <NA>    charac~ Tell m~      NA bla bl~ <NA>    charac~
    49 q7         NA bla bl~ <NA>    charac~ Tell m~      NA bla bl~ <NA>    charac~
    50 q7         NA bla bl~ <NA>    charac~ Tell m~      NA bla bl~ <NA>    charac~
    51 q7         NA bla fe~ <NA>    charac~ Tell m~      NA bla fe~ <NA>    charac~
    52 q7         NA bla pa~ <NA>    charac~ Tell m~      NA bla pa~ <NA>    charac~
    53 q7         NA bla sa~ <NA>    charac~ Tell m~      NA bla sa~ <NA>    charac~
    54 q8         NA 1       <NA>    charac~ A nume~       1 <NA>    <NA>    double 
    55 q8         NA 10      <NA>    charac~ A nume~      10 <NA>    <NA>    double 
    56 q8         NA 2       <NA>    charac~ A nume~       2 <NA>    <NA>    double 
    57 q8         NA 3       <NA>    charac~ A nume~       3 <NA>    <NA>    double 
    58 q8         NA 4       <NA>    charac~ A nume~       4 <NA>    <NA>    double 
    59 q8         NA 5       <NA>    charac~ A nume~       5 <NA>    <NA>    double 
    60 q8         NA 6       <NA>    charac~ A nume~       6 <NA>    <NA>    double 
    61 q8         NA 7       <NA>    charac~ A nume~       7 <NA>    <NA>    double 
    62 q8         NA 8       <NA>    charac~ A nume~       8 <NA>    <NA>    double 
    63 q8         NA 9       <NA>    charac~ A nume~       9 <NA>    <NA>    double 
    64 q9         NA <NA>    <NA>    double  <NA>         NA <NA>    <NA>    <NA>   
    # ... with 2 more variables: varlab_new <chr>, n <int>, and abbreviated
    #   variable names 1: double_old, 2: character_old, 3: vallab_old, 4: type_old,
    #   5: varlab_old, 6: double_new, 7: character_new, 8: vallab_new, 9: type_new

