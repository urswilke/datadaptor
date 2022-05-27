# update_var_table() print is reproduced

    # A tibble: 11 x 6
       var     type      varlab                             new_label op    new_name
       <chr>   <chr>     <chr>                              <chr>     <chr> <chr>   
     1 new_var double    variable label of new_var          <NA>      <NA>  <NA>    
     2 q1      double    How much do you like the product?  Like Pro~ <NA>  <NA>    
     3 q2      double    Do you want to recommend the prod~ recommen~ <NA>  q2_rena~
     4 q3      double    How likely will you go dancing th~ <NA>      <NA>  <NA>    
     5 q4      double    How much do you like your friends? <NA>      <NA>  q4_rena~
     6 q5      double    How much do you like your best fr~ Like bes~ <NA>  <NA>    
     7 id      double    <NA>                               <NA>      <NA>  <NA>    
     8 q6      character Tell me something positive.        <NA>      a     <NA>    
     9 q7      character Tell me something negative.        <NA>      <NA>  <NA>    
    10 q8      character A numeric variable in string form~ Now the ~ n     <NA>    
    11 q9      double    <NA>                               <NA>      d     <NA>    

# update_label_table() print is reproduced

    # A tibble: 28 x 8
       var      nv vallab cv    new_label sum_var_label sum_var_value sum_var_vallab
       <chr> <dbl> <chr>  <chr> <chr>     <chr>         <chr>         <chr>         
     1 new_~     1 value~ <NA>  <NA>      <NA>          <NA>          <NA>          
     2 q1        1 not a~ <NA>  <NA>      <NA>          <NA>          <NA>          
     3 q1        2 a bit  <NA>  <NA>      <NA>          <NA>          <NA>          
     4 q1        3 normal <NA>  <NA>      <NA>          <NA>          <NA>          
     5 q1        4 much   <NA>  <NA>      <NA>          <NA>          <NA>          
     6 q1        5 very ~ <NA>  <NA>      <NA>          <NA>          <NA>          
     7 q1       99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          
     8 q2        1 yes    <NA>  YES       <NA>          <NA>          <NA>          
     9 q2        2 no     <NA>  <NA>      <NA>          <NA>          <NA>          
    10 q2       99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          
    11 q3        1 not a~ <NA>  <NA>      <NA>          <NA>          <NA>          
    12 q3        2 a bit  <NA>  <NA>      <NA>          <NA>          <NA>          
    13 q3        3 normal <NA>  <NA>      <NA>          <NA>          <NA>          
    14 q3        4 much   <NA>  <NA>      <NA>          <NA>          <NA>          
    15 q3        5 very ~ <NA>  <NA>      <NA>          <NA>          <NA>          
    16 q3       99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          
    17 q4        1 not a~ <NA>  <NA>      <NA>          <NA>          <NA>          
    18 q4        2 a bit  <NA>  <NA>      <NA>          <NA>          <NA>          
    19 q4        3 normal <NA>  <NA>      <NA>          <NA>          <NA>          
    20 q4        4 much   <NA>  <NA>      <NA>          <NA>          <NA>          
    21 q4        5 very ~ <NA>  <NA>      <NA>          <NA>          <NA>          
    22 q4       99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          
    23 q5        1 not a~ <NA>  <NA>      test          1             aaa           
    24 q5        2 a bit  <NA>  <NA>      <NA>          1             <NA>          
    25 q5        3 normal <NA>  <NA>      <NA>          2             bbb           
    26 q5        4 much   <NA>  <NA>      <NA>          3             ccc           
    27 q5        5 very ~ <NA>  <NA>      <NA>          3             <NA>          
    28 q5       99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          

