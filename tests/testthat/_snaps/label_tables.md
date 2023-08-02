# update_var_table() print is reproduced

    # A tibble: 11 x 6
     var     type      varlab                               new_label op    new_name
     <chr>   <chr>     <chr>                                <chr>     <chr> <chr>   
     new_var double    "variable label of new_var"          <NA>      <NA>  <NA>    
     q1      double    "How much do you like the product?"  Like Pro~ <NA>  <NA>    
     q2      double    "Do you want to recommend the produ~ recommen~ <NA>  q2_rena~
     q3      double    "How likely will you go dancing thi~ <NA>      <NA>  <NA>    
     q4      double    "How much do you like your friends?" <NA>      <NA>  q4_rena~
     q5      double    "How much do you like your best fri~ Like bes~ <NA>  <NA>    
     id      double    ""                                   <NA>      <NA>  <NA>    
     q6      character "Tell me something positive."        <NA>      a     <NA>    
     q7      character "Tell me something negative."        <NA>      <NA>  <NA>    
     q8      character "A numeric variable in string forma~ Now the ~ n     <NA>    
     q9      double    ""                                   <NA>      d     <NA>    

# update_label_table() print is reproduced

    # A tibble: 28 x 8
     var        nv vallab cv    new_label sum_var_label sum_var_value sum_var_vallab
     <chr>   <dbl> <chr>  <chr> <chr>     <chr>         <chr>         <chr>         
     new_var     1 value~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q1          1 not a~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q1          2 a bit  <NA>  <NA>      <NA>          <NA>          <NA>          
     q1          3 normal <NA>  <NA>      <NA>          <NA>          <NA>          
     q1          4 much   <NA>  <NA>      <NA>          <NA>          <NA>          
     q1          5 very ~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q1         99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q2          1 yes    <NA>  YES       <NA>          <NA>          <NA>          
     q2          2 no     <NA>  <NA>      <NA>          <NA>          <NA>          
     q2         99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q3          1 not a~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q3          2 a bit  <NA>  <NA>      <NA>          <NA>          <NA>          
     q3          3 normal <NA>  <NA>      <NA>          <NA>          <NA>          
     q3          4 much   <NA>  <NA>      <NA>          <NA>          <NA>          
     q3          5 very ~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q3         99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q4          1 not a~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q4          2 a bit  <NA>  <NA>      <NA>          <NA>          <NA>          
     q4          3 normal <NA>  <NA>      <NA>          <NA>          <NA>          
     q4          4 much   <NA>  <NA>      <NA>          <NA>          <NA>          
     q4          5 very ~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q4         99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          
     q5          1 not a~ <NA>  <NA>      test          1             aaa           
     q5          2 a bit  <NA>  <NA>      <NA>          1             <NA>          
     q5          3 normal <NA>  <NA>      <NA>          2             bbb           
     q5          4 much   <NA>  <NA>      <NA>          3             ccc           
     q5          5 very ~ <NA>  <NA>      <NA>          3             <NA>          
     q5         99 no an~ <NA>  <NA>      <NA>          <NA>          <NA>          

# gen_var_table_raw() print is reproduced

    # A tibble: 66 x 3
     var                    type      varlab                                    
     <chr>                  <chr>     <chr>                                     
     q2new                  double    "recommend product"                       
     q3                     double    "Almost same variable label for q3 and q5"
     q1                     double    "new_varlab"                              
     q5                     double    "Almost same variable label for q5 and q3"
     id                     double    ""                                        
     q6                     double    "Tell me something positive."             
     q7                     character "Tell me something negative."             
     q8                     double    "Now the variable is in numeric format."  
     kq5                    double    "test"                                    
     q2                     double    "recommend product"                       
     q4                     double    "How much do you like your friends?"      
     q97                    double    ""                                        
     q99                    double    ""                                        
     q6n                    double    ""                                        
     q7n                    double    ""                                        
     q6_1                   double    "love"                                    
     q6_2                   double    "joy"                                     
     q6_3                   double    "happiness"                               
     q6_4                   double    "noch wat"                                
     q6_97                  double    "Others"                                  
     q6_99                  double    "No answer"                               
     q6test_1               double    "love"                                    
     q6test_2               double    "joy"                                     
     q6test_3               double    "happiness"                               
     q6test_4               double    "noch wat"                                
     q6test_97              double    "Others"                                  
     q6test_99              double    "No answer"                               
     q6n1                   double    ""                                        
     q6n2                   double    ""                                        
     q6n3                   double    ""                                        
     q6n4                   double    ""                                        
     q6n5                   double    ""                                        
     q6n6                   double    ""                                        
     q6n7                   double    ""                                        
     q6n8                   double    ""                                        
     q6n9                   double    ""                                        
     q6n10                  double    ""                                        
     q6mw_1                 double    "love"                                    
     q6mw_2                 double    "joy"                                     
     q6mw_3                 double    "happiness"                               
     q6mw_4                 double    "noch wat"                                
     q6mw_97                double    "Others"                                  
     q6mw_99                double    "No answer"                               
     q6_assign_nn_1         double    "love"                                    
     q6_assign_nn_2         double    "joy"                                     
     q6_assign_nn_3         double    "happiness"                               
     q6_assign_nn_4         double    "noch wat"                                
     q6_assign_nn_97        double    "Others"                                  
     q6_assign_nn_99        double    "No answer"                               
     x                      double    ""                                        
     abc                    double    ""                                        
     kq6                    double    ""                                        
     kq1                    double    "summarized variable"                     
     kq3                    double    "summarized variable"                     
     kq1xq2_renamedkminus20 double    "FILTER: summarized variable"             
     kq1xq2_renamedk10      double    "YES: summarized variable"                
     kq1xq2_renamedk20      double    "no: summarized variable"                 
     kq1xq2_renamedk990     double    "no answer: summarized variable"          
     n                      double    "overwrite new label"                     
     a1                     double    "same variable label for a1 & a2"         
     a2                     double    "same variable label for a1 & a2"         
     r_expr_var             double    "varlab"                                  
     sum_of_k_vars          double    ""                                        
     kkq1                   double    "vl"                                      
     qsum                   double    ""                                        
     free2_var              double    ""                                        

# gen_label_table_raw() print is reproduced

    # A tibble: 232 x 3
     var                       nv vallab               
     <chr>                  <dbl> <chr>                
     q2new                     -2 FILTER               
     q2new                      1 YES                  
     q2new                      2 no                   
     q2new                     99 no answer            
     q3                         1 not at all           
     q3                         2 a bit                
     q3                         3 normal               
     q3                         4 much                 
     q3                         5 very much            
     q3                        99 no answer            
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

