# update_var_table() print is reproduced

    # A tibble: 11 x 6
       var     type      varlab                                new_l~1 op    new_n~2
       <chr>   <chr>     <chr>                                 <chr>   <chr> <chr>  
     1 new_var double    variable label of new_var             <NA>    <NA>  <NA>   
     2 q1      double    How much do you like the product?     Like P~ <NA>  <NA>   
     3 q2      double    Do you want to recommend the product? recomm~ <NA>  q2_ren~
     4 q3      double    How likely will you go dancing this ~ <NA>    <NA>  <NA>   
     5 q4      double    How much do you like your friends?    <NA>    <NA>  q4_ren~
     6 q5      double    How much do you like your best frien~ Like b~ <NA>  <NA>   
     7 id      double    <NA>                                  <NA>    <NA>  <NA>   
     8 q6      character Tell me something positive.           <NA>    a     <NA>   
     9 q7      character Tell me something negative.           <NA>    <NA>  <NA>   
    10 q8      character A numeric variable in string format.  Now th~ n     <NA>   
    11 q9      double    <NA>                                  <NA>    d     <NA>   
    # ... with abbreviated variable names 1: new_label, 2: new_name

# update_label_table() print is reproduced

    # A tibble: 28 x 8
       var        nv vallab                    cv    new_l~1 sum_v~2 sum_v~3 sum_v~4
       <chr>   <dbl> <chr>                     <chr> <chr>   <chr>   <chr>   <chr>  
     1 new_var     1 value label of value 1 o~ <NA>  <NA>    <NA>    <NA>    <NA>   
     2 q1          1 not at all                <NA>  <NA>    <NA>    <NA>    <NA>   
     3 q1          2 a bit                     <NA>  <NA>    <NA>    <NA>    <NA>   
     4 q1          3 normal                    <NA>  <NA>    <NA>    <NA>    <NA>   
     5 q1          4 much                      <NA>  <NA>    <NA>    <NA>    <NA>   
     6 q1          5 very much                 <NA>  <NA>    <NA>    <NA>    <NA>   
     7 q1         99 no answer                 <NA>  <NA>    <NA>    <NA>    <NA>   
     8 q2          1 yes                       <NA>  YES     <NA>    <NA>    <NA>   
     9 q2          2 no                        <NA>  <NA>    <NA>    <NA>    <NA>   
    10 q2         99 no answer                 <NA>  <NA>    <NA>    <NA>    <NA>   
    11 q3          1 not at all                <NA>  <NA>    <NA>    <NA>    <NA>   
    12 q3          2 a bit                     <NA>  <NA>    <NA>    <NA>    <NA>   
    13 q3          3 normal                    <NA>  <NA>    <NA>    <NA>    <NA>   
    14 q3          4 much                      <NA>  <NA>    <NA>    <NA>    <NA>   
    15 q3          5 very much                 <NA>  <NA>    <NA>    <NA>    <NA>   
    16 q3         99 no answer                 <NA>  <NA>    <NA>    <NA>    <NA>   
    17 q4          1 not at all                <NA>  <NA>    <NA>    <NA>    <NA>   
    18 q4          2 a bit                     <NA>  <NA>    <NA>    <NA>    <NA>   
    19 q4          3 normal                    <NA>  <NA>    <NA>    <NA>    <NA>   
    20 q4          4 much                      <NA>  <NA>    <NA>    <NA>    <NA>   
    21 q4          5 very much                 <NA>  <NA>    <NA>    <NA>    <NA>   
    22 q4         99 no answer                 <NA>  <NA>    <NA>    <NA>    <NA>   
    23 q5          1 not at all                <NA>  <NA>    test    1       aaa    
    24 q5          2 a bit                     <NA>  <NA>    <NA>    1       <NA>   
    25 q5          3 normal                    <NA>  <NA>    <NA>    2       bbb    
    26 q5          4 much                      <NA>  <NA>    <NA>    3       ccc    
    27 q5          5 very much                 <NA>  <NA>    <NA>    3       <NA>   
    28 q5         99 no answer                 <NA>  <NA>    <NA>    <NA>    <NA>   
    # ... with abbreviated variable names 1: new_label, 2: sum_var_label,
    #   3: sum_var_value, 4: sum_var_vallab

