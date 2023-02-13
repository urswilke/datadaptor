# googlesheet mapping works

    # A tibble: 63 x 3
       var      nv vallab       
       <chr> <dbl> <chr>        
     1 id        1 1            
     2 id        2 2            
     3 id        3 3            
     4 id        4 4            
     5 id        5 5            
     6 id        6 6            
     7 id        7 7            
     8 id        8 8            
     9 id        9 9            
    10 id       10 10           
    11 id       11 11           
    12 id       12 12           
    13 id       13 13           
    14 id       14 14           
    15 id       15 15           
    16 id       16 16           
    17 id       17 17           
    18 id       18 18           
    19 id       19 19           
    20 id       20 20           
    21 id       21 21           
    22 id       22 22           
    23 id       23 23           
    24 id       24 24           
    25 id       25 25           
    26 id       26 26           
    27 id       27 27           
    28 id       28 28           
    29 id       29 29           
    30 id       30 30           
    31 id       31 31           
    32 id       32 32           
    33 mpg      -2 FILTER       
    34 cyl      -2 FILTER       
    35 cyl       4 4 cylinders  
    36 cyl       6 6 cylinders  
    37 cyl       8 8 cylinders  
    38 disp     -2 FILTER       
    39 hp       -2 FILTER       
    40 drat     -2 FILTER       
    41 wt       -2 FILTER       
    42 ff       -2 FILTER       
    43 vs       -2 FILTER       
    44 vs        0 V-shaped     
    45 vs        1 straight     
    46 am       -2 FILTER       
    47 am        0 automatic    
    48 am        1 manual       
    49 gear     -2 FILTER       
    50 gear      3 3 gears      
    51 gear      4 4 gears      
    52 gear      5 5 gears      
    53 carb     -2 FILTER       
    54 carb      1 1 carburetor 
    55 carb      2 2 carburetors
    56 carb      3 3 carburetors
    57 carb      4 4 carburetors
    58 carb      5 5 carburetors
    59 carb      6 6 carburetors
    60 carb      7 7 carburetors
    61 carb      8 8 carburetors
    62 kvs       1 gsf          
    63 kvs       2 gfd          

---

    # A tibble: 12 x 2
       var   varlab                 
       <chr> <chr>                  
     1 mpg   Miles/(US) gallon      
     2 cyl   Number of cylinders    
     3 disp  Displacement (cu.in.)  
     4 hp    Gross horsepower       
     5 drat  Rear axle ratio        
     6 wt    tqagvra<ga             
     7 ff    1/4 mile time          
     8 vs    Engine                 
     9 am    Transmission           
    10 gear  Number of forward gears
    11 carb  Number of carburetors  
    12 kvs   huhu                   

---

    # A tibble: 32 x 15
       id        model             mpg       cyl             disp      hp       
       <dbl+lbl> <chr>             <dbl+lbl> <dbl+lbl>       <dbl+lbl> <dbl+lbl>
     1  1 [1]    Mazda RX4         21        6 [6 cylinders] 160       110      
     2  2 [2]    Mazda RX4 Wag     21        6 [6 cylinders] 160       110      
     3  3 [3]    Datsun 710        22.8      4 [4 cylinders] 108        93      
     4  4 [4]    Hornet 4 Drive    21.4      6 [6 cylinders] 258       110      
     5  5 [5]    Hornet Sportabout 18.7      8 [8 cylinders] 360       175      
     6  6 [6]    Valiant           18.1      6 [6 cylinders] 225       105      
     7  7 [7]    Duster 360        14.3      8 [8 cylinders] 360       245      
     8  8 [8]    Merc 240D         24.4      4 [4 cylinders] 147.       62      
     9  9 [9]    Merc 230          22.8      4 [4 cylinders] 141.       95      
    10 10 [10]   Merc 280          19.2      6 [6 cylinders] 168.      123      
       drat      wt        ff        vs           am            gear       
       <dbl+lbl> <dbl+lbl> <dbl+lbl> <dbl+lbl>    <dbl+lbl>     <dbl+lbl>  
     1 3.9       2.62      16.5      0 [V-shaped] 1 [manual]    4 [4 gears]
     2 3.9       2.88      17.0      0 [V-shaped] 1 [manual]    4 [4 gears]
     3 3.85      2.32      18.6      1 [straight] 1 [manual]    4 [4 gears]
     4 3.08      3.22      19.4      1 [straight] 0 [automatic] 3 [3 gears]
     5 3.15      3.44      17.0      0 [V-shaped] 0 [automatic] 3 [3 gears]
     6 2.76      3.46      20.2      1 [straight] 0 [automatic] 3 [3 gears]
     7 3.21      3.57      15.8      0 [V-shaped] 0 [automatic] 3 [3 gears]
     8 3.69      3.19      20        1 [straight] 0 [automatic] 4 [4 gears]
     9 3.92      3.15      22.9      1 [straight] 0 [automatic] 4 [4 gears]
    10 3.92      3.44      18.3      1 [straight] 0 [automatic] 4 [4 gears]
       carb              kvs           a
       <dbl+lbl>         <dbl+lbl> <dbl>
     1 4 [4 carburetors] 1 [gsf]       1
     2 4 [4 carburetors] 1 [gsf]       1
     3 1 [1 carburetor]  2 [gfd]       1
     4 1 [1 carburetor]  2 [gfd]       1
     5 2 [2 carburetors] 1 [gsf]       1
     6 1 [1 carburetor]  2 [gfd]       1
     7 4 [4 carburetors] 1 [gsf]       1
     8 2 [2 carburetors] 2 [gfd]       1
     9 2 [2 carburetors] 2 [gfd]       1
    10 4 [4 carburetors] 2 [gfd]       1
    # ... with 22 more rows

