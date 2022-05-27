# mapping xlsx generation works

    Code
      l %>% purrr::set_names(sheet_names)
    Output
      $Variables
      # A tibble: 10 x 6
         var   type      varlab                               new_label new_name op   
         <chr> <chr>     <chr>                                <lgl>     <lgl>    <lgl>
       1 q1    double    How much do you like the product?    NA        NA       NA   
       2 q2    double    Do you want to recommend the produc~ NA        NA       NA   
       3 q3    double    How likely will you go dancing this~ NA        NA       NA   
       4 q4    double    How much do you like your friends?   NA        NA       NA   
       5 q5    double    How much do you like your best frie~ NA        NA       NA   
       6 id    double    <NA>                                 NA        NA       NA   
       7 q6    character Tell me something positive.          NA        NA       NA   
       8 q7    character Tell me something negative.          NA        NA       NA   
       9 q8    character A numeric variable in string format. NA        NA       NA   
      10 q9    double    <NA>                                 NA        NA       NA   
      
      $Label
      # A tibble: 27 x 8
         var      nv vallab cv    new_label sum_var_label sum_var_value sum_var_vallab
         <chr> <dbl> <chr>  <lgl> <lgl>     <lgl>         <lgl>         <lgl>         
       1 q1        1 not a~ NA    NA        NA            NA            NA            
       2 q1        2 a bit  NA    NA        NA            NA            NA            
       3 q1        3 normal NA    NA        NA            NA            NA            
       4 q1        4 much   NA    NA        NA            NA            NA            
       5 q1        5 very ~ NA    NA        NA            NA            NA            
       6 q1       99 no an~ NA    NA        NA            NA            NA            
       7 q2        1 yes    NA    NA        NA            NA            NA            
       8 q2        2 no     NA    NA        NA            NA            NA            
       9 q2       99 no an~ NA    NA        NA            NA            NA            
      10 q3        1 not a~ NA    NA        NA            NA            NA            
      # ... with 17 more rows
      
      $Verbatims
      # A tibble: 0 x 1
      # ... with 1 variable: ...1 <lgl>
      
      $Free1
      # A tibble: 0 x 1
      # ... with 1 variable: ...1 <lgl>
      

