# Toy data of a fictional survey about fruits

This dataset contains the made-up answers of a fictional survey about
fruits. The same data is also included in the package in SPSS format.
See in the examples section how to load the SPSS version to R.

## Usage

``` r
fruit_survey
```

## Format

A data frame with 100 observations on 12 variables:

- id:

  respondent id

- q1:

  answers to Q1

- q2_1:

  answers to Q2 - 1st item

- q2_2:

  answers to Q2 - 2nd item

- q2_3:

  answers to Q2 - 3rd item

- q2_97:

  answers to Q2 - 4th item

- q3_1:

  answers to Q3 - 1st item

- q3_2:

  answers to Q3 - 2nd item

- q3_3:

  answers to Q3 - 3rd item

- q3_97:

  answers to Q3 - 4th item

- q4:

  answers to Q4

- q5:

  answers to Q5

## Examples

``` r
datadaptor::fruit_survey
#> # A tibble: 100 × 12
#>    id    q1       q2_1     q2_2     q2_3     q2_97    q3_1     q3_2     q3_3    
#>    <int> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb>
#>  1  1     1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  0 [Not…  2 [2]    4 [4]    5 [5 =…
#>  2  2     1 [Yes]  0 [Not…  1 [Sel…  1 [Sel…  0 [Not… NA        2 [2]    5 [5 =…
#>  3  3     1 [Yes]  0 [Not…  0 [Not…  1 [Sel…  1 [Sel… NA       NA        1 [1 =…
#>  4  4     1 [Yes]  1 [Sel…  0 [Not…  0 [Not…  0 [Not…  1 [1 =… NA       NA      
#>  5  5     2 [No]  NA       NA       NA       NA       NA       NA       NA      
#>  6  6     1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  3 [3]    2 [2]    5 [5 =…
#>  7  7     1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  0 [Not…  5 [5 =…  4 [4]    5 [5 =…
#>  8  8     1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  1 [1 =…  5 [5 =…  2 [2]  
#>  9  9    99 [No … NA       NA       NA       NA       NA       NA       NA      
#> 10 10     1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  2 [2]    1 [1 =…  5 [5 =…
#> # ℹ 90 more rows
#> # ℹ 3 more variables: q3_97 <dbl+lbl>, q4 <dbl+lbl>, q5 <dbl+lbl>
path <- system.file("extdata", "fruit_survey.sav", package = "datadaptor")
df <- haven::read_sav(path)
df
#> # A tibble: 100 × 12
#>       id q1       q2_1     q2_2     q2_3     q2_97    q3_1     q3_2     q3_3    
#>    <dbl> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb> <dbl+lb>
#>  1     1  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  0 [Not…  2 [2]    4 [4]    5 [5 =…
#>  2     2  1 [Yes]  0 [Not…  1 [Sel…  1 [Sel…  0 [Not… NA        2 [2]    5 [5 =…
#>  3     3  1 [Yes]  0 [Not…  0 [Not…  1 [Sel…  1 [Sel… NA       NA        1 [1 =…
#>  4     4  1 [Yes]  1 [Sel…  0 [Not…  0 [Not…  0 [Not…  1 [1 =… NA       NA      
#>  5     5  2 [No]  NA       NA       NA       NA       NA       NA       NA      
#>  6     6  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  3 [3]    2 [2]    5 [5 =…
#>  7     7  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  0 [Not…  5 [5 =…  4 [4]    5 [5 =…
#>  8     8  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  1 [1 =…  5 [5 =…  2 [2]  
#>  9     9 99 [No … NA       NA       NA       NA       NA       NA       NA      
#> 10    10  1 [Yes]  1 [Sel…  1 [Sel…  1 [Sel…  1 [Sel…  2 [2]    1 [1 =…  5 [5 =…
#> # ℹ 90 more rows
#> # ℹ 3 more variables: q3_97 <dbl+lbl>, q4 <dbl+lbl>, q5 <dbl>
labelled::generate_dictionary(fruit_survey)
#>  pos variable label                         col_type missing
#>  1   id       ID variable                   int+lbl  0      
#>  2   q1       Do you like fruits?           dbl+lbl  0      
#>                                                             
#>                                                             
#>  3   q2_1     Which fruits do you like? - ~ dbl+lbl  25     
#>                                                             
#>  4   q2_2     Which fruits do you like? - ~ dbl+lbl  25     
#>                                                             
#>  5   q2_3     Which fruits do you like? - ~ dbl+lbl  25     
#>                                                             
#>  6   q2_97    Which fruits do you like? - ~ dbl+lbl  25     
#>                                                             
#>  7   q3_1     Please rate on a scale from ~ dbl+lbl  43     
#>                                                             
#>                                                             
#>                                                             
#>                                                             
#>  8   q3_2     Please rate on a scale from ~ dbl+lbl  46     
#>                                                             
#>                                                             
#>                                                             
#>                                                             
#>  9   q3_3     Please rate on a scale from ~ dbl+lbl  46     
#>                                                             
#>                                                             
#>                                                             
#>                                                             
#>  10  q3_97    Please rate on a scale from ~ dbl+lbl  43     
#>                                                             
#>                                                             
#>                                                             
#>                                                             
#>  11  q4       What's your favorite fruit?   dbl+lbl  30     
#>                                                             
#>                                                             
#>                                                             
#>                                                             
#>  12  q5       How many of your favorite fr~ dbl+lbl  33     
#>  values              
#>                      
#>  [1] Yes             
#>  [2] No              
#>  [99] No answer      
#>  [0] Not selected    
#>  [1] Selected        
#>  [0] Not selected    
#>  [1] Selected        
#>  [0] Not selected    
#>  [1] Selected        
#>  [0] Not selected    
#>  [1] Selected        
#>  [1] 1 = It's not bad
#>  [2] 2               
#>  [3] 3               
#>  [4] 4               
#>  [5] 5 = I love it   
#>  [1] 1 = It's not bad
#>  [2] 2               
#>  [3] 3               
#>  [4] 4               
#>  [5] 5 = I love it   
#>  [1] 1 = It's not bad
#>  [2] 2               
#>  [3] 3               
#>  [4] 4               
#>  [5] 5 = I love it   
#>  [1] 1 = It's not bad
#>  [2] 2               
#>  [3] 3               
#>  [4] 4               
#>  [5] 5 = I love it   
#>  [1] Apple           
#>  [2] Banana          
#>  [3] Orange          
#>  [97] Others         
#>  [99] No answer      
#>                      
```
