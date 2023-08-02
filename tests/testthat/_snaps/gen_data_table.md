# gen_data_table() works

    # A tibble: 164 x 7
     var   double character              Freq vallab     type      varlab           
     <chr>  <dbl> <chr>                 <int> <chr>      <chr>     <chr>            
     q1         1 <NA>                     13 not at all double    "How much do you~
     q1         2 <NA>                     16 a bit      double    "How much do you~
     q1         3 <NA>                     18 normal     double    "How much do you~
     q1         4 <NA>                     16 much       double    "How much do you~
     q1         5 <NA>                     14 very much  double    "How much do you~
     q1        99 <NA>                     18 no answer  double    "How much do you~
     q1        NA <NA>                      5 <NA>       double    "How much do you~
     q2         1 <NA>                     28 yes        double    "Do you want to ~
     q2         2 <NA>                     37 no         double    "Do you want to ~
     q2        99 <NA>                     31 no answer  double    "Do you want to ~
     q2        NA <NA>                      4 <NA>       double    "Do you want to ~
     q3         1 <NA>                     17 not at all double    "How likely will~
     q3         2 <NA>                     22 a bit      double    "How likely will~
     q3         3 <NA>                     15 normal     double    "How likely will~
     q3         4 <NA>                     19 much       double    "How likely will~
     q3         5 <NA>                     18 very much  double    "How likely will~
     q3        99 <NA>                      7 no answer  double    "How likely will~
     q3        NA <NA>                      2 <NA>       double    "How likely will~
     q4         1 <NA>                     15 not at all double    "How much do you~
     q4         2 <NA>                     18 a bit      double    "How much do you~
     q4         3 <NA>                     19 normal     double    "How much do you~
     q4         4 <NA>                     18 much       double    "How much do you~
     q4         5 <NA>                     14 very much  double    "How much do you~
     q4        99 <NA>                     13 no answer  double    "How much do you~
     q4        NA <NA>                      3 <NA>       double    "How much do you~
     q5         1 <NA>                     15 not at all double    "How much do you~
     q5         2 <NA>                     22 a bit      double    "How much do you~
     q5         3 <NA>                     17 normal     double    "How much do you~
     q5         4 <NA>                     20 much       double    "How much do you~
     q5         5 <NA>                     13 very much  double    "How much do you~
     q5        99 <NA>                     10 no answer  double    "How much do you~
     q5        NA <NA>                      3 <NA>       double    "How much do you~
     id         1 <NA>                      1 <NA>       double    ""               
     id         2 <NA>                      1 <NA>       double    ""               
     id         3 <NA>                      1 <NA>       double    ""               
     id         4 <NA>                      1 <NA>       double    ""               
     id         5 <NA>                      1 <NA>       double    ""               
     id         6 <NA>                      1 <NA>       double    ""               
     id         7 <NA>                      1 <NA>       double    ""               
     id         8 <NA>                      1 <NA>       double    ""               
     id         9 <NA>                      1 <NA>       double    ""               
     id        10 <NA>                      1 <NA>       double    ""               
     id        11 <NA>                      1 <NA>       double    ""               
     id        12 <NA>                      1 <NA>       double    ""               
     id        13 <NA>                      1 <NA>       double    ""               
     id        14 <NA>                      1 <NA>       double    ""               
     id        15 <NA>                      1 <NA>       double    ""               
     id        16 <NA>                      1 <NA>       double    ""               
     id        17 <NA>                      1 <NA>       double    ""               
     id        18 <NA>                      1 <NA>       double    ""               
     id        19 <NA>                      1 <NA>       double    ""               
     id        20 <NA>                      1 <NA>       double    ""               
     id        21 <NA>                      1 <NA>       double    ""               
     id        22 <NA>                      1 <NA>       double    ""               
     id        23 <NA>                      1 <NA>       double    ""               
     id        24 <NA>                      1 <NA>       double    ""               
     id        25 <NA>                      1 <NA>       double    ""               
     id        26 <NA>                      1 <NA>       double    ""               
     id        27 <NA>                      1 <NA>       double    ""               
     id        28 <NA>                      1 <NA>       double    ""               
     id        29 <NA>                      1 <NA>       double    ""               
     id        30 <NA>                      1 <NA>       double    ""               
     id        31 <NA>                      1 <NA>       double    ""               
     id        32 <NA>                      1 <NA>       double    ""               
     id        33 <NA>                      1 <NA>       double    ""               
     id        34 <NA>                      1 <NA>       double    ""               
     id        35 <NA>                      1 <NA>       double    ""               
     id        36 <NA>                      1 <NA>       double    ""               
     id        37 <NA>                      1 <NA>       double    ""               
     id        38 <NA>                      1 <NA>       double    ""               
     id        39 <NA>                      1 <NA>       double    ""               
     id        40 <NA>                      1 <NA>       double    ""               
     id        41 <NA>                      1 <NA>       double    ""               
     id        42 <NA>                      1 <NA>       double    ""               
     id        43 <NA>                      1 <NA>       double    ""               
     id        44 <NA>                      1 <NA>       double    ""               
     id        45 <NA>                      1 <NA>       double    ""               
     id        46 <NA>                      1 <NA>       double    ""               
     id        47 <NA>                      1 <NA>       double    ""               
     id        48 <NA>                      1 <NA>       double    ""               
     id        49 <NA>                      1 <NA>       double    ""               
     id        50 <NA>                      1 <NA>       double    ""               
     id        51 <NA>                      1 <NA>       double    ""               
     id        52 <NA>                      1 <NA>       double    ""               
     id        53 <NA>                      1 <NA>       double    ""               
     id        54 <NA>                      1 <NA>       double    ""               
     id        55 <NA>                      1 <NA>       double    ""               
     id        56 <NA>                      1 <NA>       double    ""               
     id        57 <NA>                      1 <NA>       double    ""               
     id        58 <NA>                      1 <NA>       double    ""               
     id        59 <NA>                      1 <NA>       double    ""               
     id        60 <NA>                      1 <NA>       double    ""               
     id        61 <NA>                      1 <NA>       double    ""               
     id        62 <NA>                      1 <NA>       double    ""               
     id        63 <NA>                      1 <NA>       double    ""               
     id        64 <NA>                      1 <NA>       double    ""               
     id        65 <NA>                      1 <NA>       double    ""               
     id        66 <NA>                      1 <NA>       double    ""               
     id        67 <NA>                      1 <NA>       double    ""               
     id        68 <NA>                      1 <NA>       double    ""               
     id        69 <NA>                      1 <NA>       double    ""               
     id        70 <NA>                      1 <NA>       double    ""               
     id        71 <NA>                      1 <NA>       double    ""               
     id        72 <NA>                      1 <NA>       double    ""               
     id        73 <NA>                      1 <NA>       double    ""               
     id        74 <NA>                      1 <NA>       double    ""               
     id        75 <NA>                      1 <NA>       double    ""               
     id        76 <NA>                      1 <NA>       double    ""               
     id        77 <NA>                      1 <NA>       double    ""               
     id        78 <NA>                      1 <NA>       double    ""               
     id        79 <NA>                      1 <NA>       double    ""               
     id        80 <NA>                      1 <NA>       double    ""               
     id        81 <NA>                      1 <NA>       double    ""               
     id        82 <NA>                      1 <NA>       double    ""               
     id        83 <NA>                      1 <NA>       double    ""               
     id        84 <NA>                      1 <NA>       double    ""               
     id        85 <NA>                      1 <NA>       double    ""               
     id        86 <NA>                      1 <NA>       double    ""               
     id        87 <NA>                      1 <NA>       double    ""               
     id        88 <NA>                      1 <NA>       double    ""               
     id        89 <NA>                      1 <NA>       double    ""               
     id        90 <NA>                      1 <NA>       double    ""               
     id        91 <NA>                      1 <NA>       double    ""               
     id        92 <NA>                      1 <NA>       double    ""               
     id        93 <NA>                      1 <NA>       double    ""               
     id        94 <NA>                      1 <NA>       double    ""               
     id        95 <NA>                      1 <NA>       double    ""               
     id        96 <NA>                      1 <NA>       double    ""               
     id        97 <NA>                      1 <NA>       double    ""               
     id        98 <NA>                      1 <NA>       double    ""               
     id        99 <NA>                      1 <NA>       double    ""               
     id       100 <NA>                      1 <NA>       double    ""               
     q6        NA bla bla bla happiness    10 <NA>       character "Tell me somethi~
     q6        NA bla bla bla joy           8 <NA>       character "Tell me somethi~
     q6        NA bla bla bla love         11 <NA>       character "Tell me somethi~
     q6        NA bla bla happiness        10 <NA>       character "Tell me somethi~
     q6        NA bla bla joy              19 <NA>       character "Tell me somethi~
     q6        NA bla bla love              9 <NA>       character "Tell me somethi~
     q6        NA bla happiness             8 <NA>       character "Tell me somethi~
     q6        NA bla joy                  14 <NA>       character "Tell me somethi~
     q6        NA bla love                 11 <NA>       character "Tell me somethi~
     q7        NA bla anger                 9 <NA>       character "Tell me somethi~
     q7        NA bla bla anger             9 <NA>       character "Tell me somethi~
     q7        NA bla bla bla anger        11 <NA>       character "Tell me somethi~
     q7        NA bla bla bla fear          6 <NA>       character "Tell me somethi~
     q7        NA bla bla bla pain          7 <NA>       character "Tell me somethi~
     q7        NA bla bla bla sadness       6 <NA>       character "Tell me somethi~
     q7        NA bla bla fear              7 <NA>       character "Tell me somethi~
     q7        NA bla bla pain              7 <NA>       character "Tell me somethi~
     q7        NA bla bla sadness          11 <NA>       character "Tell me somethi~
     q7        NA bla fear                 14 <NA>       character "Tell me somethi~
     q7        NA bla pain                 11 <NA>       character "Tell me somethi~
     q7        NA bla sadness               2 <NA>       character "Tell me somethi~
     q8        NA 1                        10 <NA>       character "A numeric varia~
     q8        NA 10                       13 <NA>       character "A numeric varia~
     q8        NA 2                         6 <NA>       character "A numeric varia~
     q8        NA 3                        12 <NA>       character "A numeric varia~
     q8        NA 4                        12 <NA>       character "A numeric varia~
     q8        NA 5                         6 <NA>       character "A numeric varia~
     q8        NA 6                         7 <NA>       character "A numeric varia~
     q8        NA 7                        10 <NA>       character "A numeric varia~
     q8        NA 8                        13 <NA>       character "A numeric varia~
     q8        NA 9                        11 <NA>       character "A numeric varia~
     q9        NA <NA>                    100 <NA>       double    ""               

# diff_data() works

    # A tibble: 22 x 12
     var   double_old character_old vallab_old type_old varlab_old double_new
     <fct>      <dbl> <chr>         <chr>      <chr>    <chr>           <dbl>
     q1             1 <NA>          "not a"    doubl    "How m"            NA
     q1             2 <NA>          "a bit"    doubl    "How m"             2
     q1             3 <NA>          "norma"    doubl    "How m"             3
     q1             4 <NA>          "much"     doubl    "How m"             4
     q1             5 <NA>          "very "    doubl    "How m"             5
     q1            99 <NA>          "no an"    doubl    "How m"            NA
     q4             1 <NA>          "not a"    doubl    "How m"             1
     q4             2 <NA>          "a bit"    doubl    "How m"             2
     q4             3 <NA>          "norma"    doubl    "How m"             3
     q4             4 <NA>          "much"     doubl    "How m"             4
     q4             5 <NA>          "very "    doubl    "How m"             5
     q4            99 <NA>          "no an"    doubl    "How m"            99
     q4            NA <NA>           <NA>      doubl    "How m"            -2
     q6            NA bla b          <NA>      chara    "Tell "             2
     q6            NA bla b          <NA>      chara    "Tell "             3
     q6            NA bla b          <NA>      chara    "Tell "             4
     q6            NA bla b          <NA>      chara    "Tell "             5
     q6            NA bla b          <NA>      chara    "Tell "             6
     q6            NA bla h          <NA>      chara    "Tell "             7
     q6            NA bla j          <NA>      chara    "Tell "             8
     q6            NA bla l          <NA>      chara    "Tell "             9
     q6            NA <NA>           <NA>      <NA>      <NA>               1
     character_new vallab_new type_new varlab_new     n
     <chr>         <chr>      <chr>    <chr>      <int>
     <NA>           <NA>      doubl    "new_v"        1
     <NA>          "a bit"    doubl    "new_v"        1
     <NA>          "norma"    doubl    "new_v"        3
     <NA>          "much"     doubl    "new_v"        0
     <NA>          "very "    doubl    "new_v"        3
     <NA>           <NA>      doubl    "new_v"        2
     <NA>          "not a"    doubl    "How m"        1
     <NA>          "a bit"    doubl    "How m"        2
     <NA>          "norma"    doubl    "How m"        2
     <NA>          "much"     doubl    "How m"        4
     <NA>          "very "    doubl    "How m"        0
     <NA>          "no an"    doubl    "How m"        0
     <NA>          "FILTE"    doubl    "How m"        1
     <NA>          "bla b"    doubl    "Tell "        1
     <NA>          "bla b"    doubl    "Tell "        1
     <NA>          "bla b"    doubl    "Tell "        1
     <NA>          "bla b"    doubl    "Tell "        2
     <NA>          "bla b"    doubl    "Tell "        2
     <NA>          "bla h"    doubl    "Tell "        1
     <NA>          "bla j"    doubl    "Tell "        1
     <NA>          "bla l"    doubl    "Tell "        1
     <NA>          "bla b"    doubl    "Tell "        0

