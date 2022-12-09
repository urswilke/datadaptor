# mapping txt export works

    Code
      cat(readLines(path), sep = "\n")
    Output
      $Label
      # A tibble: 27 x 8
         var   nv    vallab     cv    new_label sum_var_label sum_var_value sum_var_~1
         <chr> <chr> <chr>      <chr> <chr>     <chr>         <chr>         <chr>     
       1 q1    1     not at all <NA>  <NA>      <NA>          <NA>          <NA>      
       2 q1    2     a bit      <NA>  <NA>      <NA>          <NA>          <NA>      
       3 q1    3     normal     <NA>  <NA>      <NA>          <NA>          <NA>      
       4 q1    4     much       <NA>  <NA>      <NA>          <NA>          <NA>      
       5 q1    5     very much  <NA>  <NA>      <NA>          <NA>          <NA>      
       6 q1    99    no answer  <NA>  <NA>      <NA>          <NA>          <NA>      
       7 q2    1     yes        <NA>  YES       <NA>          <NA>          <NA>      
       8 q2    2     no         <NA>  <NA>      <NA>          <NA>          <NA>      
       9 q2    99    no answer  <NA>  <NA>      <NA>          <NA>          <NA>      
      10 q3    1     not at all <NA>  <NA>      <NA>          <NA>          <NA>      
      11 q3    2     a bit      <NA>  <NA>      <NA>          <NA>          <NA>      
      12 q3    3     normal     <NA>  <NA>      <NA>          <NA>          <NA>      
      13 q3    4     much       <NA>  <NA>      <NA>          <NA>          <NA>      
      14 q3    5     very much  <NA>  <NA>      <NA>          <NA>          <NA>      
      15 q3    99    no answer  <NA>  <NA>      <NA>          <NA>          <NA>      
      16 q4    1     not at all <NA>  <NA>      <NA>          <NA>          <NA>      
      17 q4    2     a bit      <NA>  <NA>      <NA>          <NA>          <NA>      
      18 q4    3     normal     <NA>  <NA>      <NA>          <NA>          <NA>      
      19 q4    4     much       <NA>  <NA>      <NA>          <NA>          <NA>      
      20 q4    5     very much  <NA>  <NA>      <NA>          <NA>          <NA>      
      21 q4    99    no answer  <NA>  <NA>      <NA>          <NA>          <NA>      
      22 q5    1     not at all <NA>  <NA>      test          1             aaa       
      23 q5    2     a bit      <NA>  <NA>      <NA>          1             <NA>      
      24 q5    3     normal     <NA>  <NA>      <NA>          2             bbb       
      25 q5    4     much       <NA>  <NA>      <NA>          3             ccc       
      26 q5    5     very much  <NA>  <NA>      <NA>          3             <NA>      
      27 q5    99    no answer  <NA>  <NA>      <NA>          <NA>          <NA>      
      # ... with abbreviated variable name 1: sum_var_vallab
      
      $Variables
        var                                       varlab      type
      1  q1            How much do you like the product?    double
      2  q2        Do you want to recommend the product?    double
      3  q3 How likely will you go dancing this weekend?    double
      4  q4           How much do you like your friends?    double
      5  q5       How much do you like your best friend?    double
      6  q6                  Tell me something positive. character
      7  q8         A numeric variable in string format. character
      8  q9                                         <NA>    double
                                     new_label   op   new_name
      1                           Like Product <NA>       <NA>
      2                      recommend product <NA> q2_renamed
      3                                   <NA> <NA>       <NA>
      4                                   <NA> <NA> q4_renamed
      5                       Like best friend <NA>       <NA>
      6                                   <NA>    a       <NA>
      7 Now the variable is in numeric format.    n       <NA>
      8                                   <NA>    d       <NA>
      
      $Free0
      # A tibble: 4 x 6
        X1    X2    X3         X4    X5      row
        <chr> <chr> <chr>      <chr> <chr> <int>
      1 #COMP q2    q2_renamed <NA>  <NA>      1
      2 #COMP q4    q4_renamed <NA>  <NA>      2
      3 #COMP q97   10         <NA>  <NA>      3
      4 #COMP q99   11         <NA>  <NA>      4
      
      $Verbatims
      $Verbatims[[1]]
      $Verbatims[[1]]$name
      [1] "Q6"
      
      $Verbatims[[1]]$meta
        q_id VariableOriginal EFA1MCG2MDG3 VariableZiel ex_further_cond ex_assign
      1   Q6               q6            1          q6n         q5 != 1      <NA>
      
      $Verbatims[[1]]$assignments
          orig_var  ID Zuord 1
      1         q6   7       1
      2         q6  17       1
      3         q6  23       1
      4         q6  51       1
      5         q6  58       1
      6         q6  65       1
      7         q6  67       1
      8         q6  73       1
      9         q6  74       1
      10        q6  91       1
      11        q6 100       1
      12        q6   3       2
      13        q6  13       2
      14        q6  22       2
      15        q6  26       2
      16        q6  35       2
      17        q6  38       2
      18        q6  45       2
      19        q6  47       2
      20        q6  55       2
      21        q6  72       2
      22        q6  78       2
      23        q6  88       2
      24        q6  89       2
      25        q6  97       2
      26        q6   5       3
      27        q6  12       3
      28        q6  14       3
      29        q6  39       3
      30        q6  49       3
      31        q6  62       3
      32        q6  79       3
      33        q6  98       3
      34        q6   8       1
      35        q6   9       1
      36        q6  24       1
      37        q6  30       1
      38        q6  32       1
      39        q6  36       1
      40        q6  53       1
      41        q6  61       1
      42        q6  70       1
      43        q6   4       2
      44        q6   6       2
      45        q6  19       2
      46        q6  25       2
      47        q6  28       2
      48        q6  34       2
      49        q6  44       2
      50        q6  52       2
      51        q6  54       2
      52        q6  56       2
      53        q6  57       2
      54        q6  66       2
      55        q6  71       2
      56        q6  77       2
      57        q6  83       2
      58        q6  85       2
      59        q6  90       2
      60        q6  94       2
      61        q6  96       2
      62        q6   2       3
      63        q6  15       3
      64        q6  21       3
      65        q6  27       3
      66        q6  37       3
      67        q6  40       3
      68        q6  63       3
      69        q6  69       3
      70        q6  76       3
      71        q6  99       3
      72        q6   1       1
      73        q6  10       1
      74        q6  16       1
      75        q6  33       1
      76        q6  41       1
      77        q6  42       1
      78        q6  68       1
      79        q6  75       1
      80        q6  82       1
      81        q6  86       1
      82        q6  93       1
      83        q6  11       2
      84        q6  20       2
      85        q6  29       2
      86        q6  46       2
      87        q6  50       2
      88        q6  81       2
      89        q6  84       2
      90        q6  87       2
      91        q6  18       3
      92        q6  31       3
      93        q6  43       3
      94        q6  48       3
      95        q6  59       3
      96        q6  60       3
      97        q6  64      NA
      98        q6  80      NA
      99        q6  92      NA
      100       q6  95      NA
      
      $Verbatims[[1]]$labs
      $Verbatims[[1]]$labs$Q6
        Code       lab
      1    1      love
      2    2       joy
      3    3 happiness
      4   97    Others
      5   99 No answer
      
      
      
      $Verbatims[[2]]
      $Verbatims[[2]]$name
      [1] "Q7"
      
      $Verbatims[[2]]$meta
        q_id VariableOriginal EFA1MCG2MDG3 VariableZiel ex_further_cond ex_assign
      1   Q7               q7            1          q7n            <NA>      <NA>
      
      $Verbatims[[2]]$assignments
          orig_var  ID Zuord 1
      1         q7  77       1
      2         q7  87       1
      3         q7   6       4
      4         q7  15       4
      5         q7  23       4
      6         q7  27       4
      7         q7  44       4
      8         q7  45       4
      9         q7  49       4
      10        q7  56       4
      11        q7  66       4
      12        q7  69       4
      13        q7  98       4
      14        q7   5       2
      15        q7  11       2
      16        q7  19       2
      17        q7  29       2
      18        q7  41       2
      19        q7  46       2
      20        q7  51       2
      21        q7  57       2
      22        q7  61       2
      23        q7  63       2
      24        q7  73       2
      25        q7  75       2
      26        q7  84       2
      27        q7  92       2
      28        q7   7       1
      29        q7   9       1
      30        q7  13       1
      31        q7  16       1
      32        q7  32       1
      33        q7  48       1
      34        q7  59       1
      35        q7  79       1
      36        q7  82       1
      37        q7  91       1
      38        q7  99       1
      39        q7  17       4
      40        q7  25       4
      41        q7  31       4
      42        q7  54       4
      43        q7  71       4
      44        q7  81       4
      45        q7  94       4
      46        q7  18       2
      47        q7  21       2
      48        q7  33       2
      49        q7  67       2
      50        q7  68       2
      51        q7  90       2
      52        q7  96       2
      53        q7   2       1
      54        q7   3       1
      55        q7  34       1
      56        q7  42       1
      57        q7  47       1
      58        q7  62       1
      59        q7  24       4
      60        q7  35       4
      61        q7  52       4
      62        q7  58       4
      63        q7  70       4
      64        q7  76       4
      65        q7  80       4
      66        q7  14       2
      67        q7  20       2
      68        q7  26       2
      69        q7  50       2
      70        q7  78       2
      71        q7  88       2
      72        q7   1       3
      73        q7  28       3
      74        q7  30       3
      75        q7  36       3
      76        q7  40       3
      77        q7  60       3
      78        q7  72       3
      79        q7  83       3
      80        q7  85       3
      81        q7  95       3
      82        q7  97       3
      83        q7   4       3
      84        q7   8       3
      85        q7  10       3
      86        q7  12       3
      87        q7  22       3
      88        q7  38       3
      89        q7  55       3
      90        q7  65       3
      91        q7  74       3
      92        q7  37       3
      93        q7  39       3
      94        q7  43       3
      95        q7  53       3
      96        q7  64       3
      97        q7  86       3
      98        q7  89       3
      99        q7  93       3
      100       q7 100       3
      
      $Verbatims[[2]]$labs
      $Verbatims[[2]]$labs$Q7
        Code       lab
      1    1   sadness
      2    2      fear
      3    3     anger
      4    4      pain
      5   97    Others
      6   99 No answer
      
      
      
      $Verbatims[[3]]
      $Verbatims[[3]]$name
      [1] "q6mdg"
      
      $Verbatims[[3]]$meta
         q_id VariableOriginal EFA1MCG2MDG3 VariableZiel ex_further_cond ex_assign
      1 q6mdg               q6            3      q6_{nn}            <NA>      <NA>
      
      $Verbatims[[3]]$assignments
          orig_var  ID Zuord 1 Zuord 2 Zuord 3 Zuord 4 Zuord 5 Zuord 6 Zuord 7
      1         q6   7       1       4      NA      NA      NA      NA      NA
      2         q6  17       1      NA      NA      NA      NA      NA      NA
      3         q6  23       1      NA      NA      NA      NA      NA      NA
      4         q6  51       1      NA      NA      NA      NA      NA      NA
      5         q6  58       1       4      NA      NA      NA      NA      NA
      6         q6  65       1      NA      NA      NA      NA      NA      NA
      7         q6  67       1      NA      NA      NA      NA      NA      NA
      8         q6  73       1       4      NA      NA      NA      NA      NA
      9         q6  74       1      NA      NA      NA      NA      NA      NA
      10        q6  91       1      NA      NA      NA      NA      NA      NA
      11        q6 100       1      NA      NA      NA      NA      NA      NA
      12        q6   3       2      NA      NA      NA      NA      NA      NA
      13        q6  13       2      NA      NA      NA      NA      NA      NA
      14        q6  22       2      NA      NA      NA      NA      NA      NA
      15        q6  26       2      NA      NA      NA      NA      NA      NA
      16        q6  35       2      NA      NA      NA      NA      NA      NA
      17        q6  38       2      NA      NA      NA      NA      NA      NA
      18        q6  45       2      NA      NA      NA      NA      NA      NA
      19        q6  47       2      NA      NA      NA      NA      NA      NA
      20        q6  55       2      NA      NA      NA      NA      NA      NA
      21        q6  72       2      NA      NA      NA      NA      NA      NA
      22        q6  78       2      NA      NA      NA      NA      NA      NA
      23        q6  88       2      NA      NA      NA      NA      NA      NA
      24        q6  89       2      NA      NA      NA      NA      NA      NA
      25        q6  97       2      NA      NA      NA      NA      NA      NA
      26        q6   5       3      NA      NA      NA      NA      NA      NA
      27        q6  12       3      NA      NA      NA      NA      NA      NA
      28        q6  14       3      NA      NA      NA      NA      NA      NA
      29        q6  39       3      NA      NA      NA      NA      NA      NA
      30        q6  49       3      NA      NA      NA      NA      NA      NA
      31        q6  62       3      NA      NA      NA      NA      NA      NA
      32        q6  79       3      NA      NA      NA      NA      NA      NA
      33        q6  98       3      NA      NA      NA      NA      NA      NA
      34        q6   8       1      NA      NA      NA      NA      NA      NA
      35        q6   9       1      NA      NA      NA      NA      NA      NA
      36        q6  24       1      NA      NA      NA      NA      NA      NA
      37        q6  30       1      NA      NA      NA      NA      NA      NA
      38        q6  32       1      NA      NA      NA      NA      NA      NA
      39        q6  36       1      NA      NA      NA      NA      NA      NA
      40        q6  53       1      NA      NA      NA      NA      NA      NA
      41        q6  61       1      NA      NA      NA      NA      NA      NA
      42        q6  70       1      NA      NA      NA      NA      NA      NA
      43        q6   4       2      NA      NA      NA      NA      NA      NA
      44        q6   6       2      NA      NA      NA      NA      NA      NA
      45        q6  19       2      NA      NA      NA      NA      NA      NA
      46        q6  25       2      NA      NA      NA      NA      NA      NA
      47        q6  28       2      NA      NA      NA      NA      NA      NA
      48        q6  34       2      NA      NA      NA      NA      NA      NA
      49        q6  44       2      NA      NA      NA      NA      NA      NA
      50        q6  52       2      NA      NA      NA      NA      NA      NA
      51        q6  54       2      NA      NA      NA      NA      NA      NA
      52        q6  56       2      NA      NA      NA      NA      NA      NA
      53        q6  57       2      NA      NA      NA      NA      NA      NA
      54        q6  66       2      NA      NA      NA      NA      NA      NA
      55        q6  71       2      NA      NA      NA      NA      NA      NA
      56        q6  77       2      NA      NA      NA      NA      NA      NA
      57        q6  83       2      NA      NA      NA      NA      NA      NA
      58        q6  85       2      NA      NA      NA      NA      NA      NA
      59        q6  90       2      NA      NA      NA      NA      NA      NA
      60        q6  94       2      NA      NA      NA      NA      NA      NA
      61        q6  96       2      NA      NA      NA      NA      NA      NA
      62        q6   2       3      NA      NA      NA      NA      NA      NA
      63        q6  15       3      NA      NA      NA      NA      NA      NA
      64        q6  21       3      NA      NA      NA      NA      NA      NA
      65        q6  27       3      NA      NA      NA      NA      NA      NA
      66        q6  37       3      NA      NA      NA      NA      NA      NA
      67        q6  40       3      NA      NA      NA      NA      NA      NA
      68        q6  63       3      NA      NA      NA      NA      NA      NA
      69        q6  69       3      NA      NA      NA      NA      NA      NA
      70        q6  76       3      NA      NA      NA      NA      NA      NA
      71        q6  99       3      NA      NA      NA      NA      NA      NA
      72        q6   1       1      NA      NA      NA      NA      NA      NA
      73        q6  10       1      NA      NA      NA      NA      NA      NA
      74        q6  16       1      NA      NA      NA      NA      NA      NA
      75        q6  33       1      NA      NA      NA      NA      NA      NA
      76        q6  41       1      NA      NA      NA      NA      NA      NA
      77        q6  42       1      NA      NA      NA      NA      NA      NA
      78        q6  68       1      NA      NA      NA      NA      NA      NA
      79        q6  75       1      NA      NA      NA      NA      NA      NA
      80        q6  82       1      NA      NA      NA      NA      NA      NA
      81        q6  86       1      NA      NA      NA      NA      NA      NA
      82        q6  93       1      NA      NA      NA      NA      NA      NA
      83        q6  11       2      NA      NA      NA      NA      NA      NA
      84        q6  20       2      NA      NA      NA      NA      NA      NA
      85        q6  29       2      NA      NA      NA      NA      NA      NA
      86        q6  46       2      NA      NA      NA      NA      NA      NA
      87        q6  50       2      NA      NA      NA      NA      NA      NA
      88        q6  81       2      NA      NA      NA      NA      NA      NA
      89        q6  84       2      NA      NA      NA      NA      NA      NA
      90        q6  87       2      NA      NA      NA      NA      NA      NA
      91        q6  18       3      NA      NA      NA      NA      NA      NA
      92        q6  31       3      NA      NA      NA      NA      NA      NA
      93        q6  43       3      NA      NA      NA      NA      NA      NA
      94        q6  48       3      NA      NA      NA      NA      NA      NA
      95        q6  59       3      NA      NA      NA      NA      NA      NA
      96        q6  60       3      NA      NA      NA      NA      NA      NA
      97        q6  64       3      NA      NA      NA      NA      NA      NA
      98        q6  80       3      NA      NA      NA      NA      NA      NA
      99        q6  92       3      NA      NA      NA      NA      NA      NA
      100       q6  95       3      NA      NA      NA      NA      NA      NA
          Zuord 8 Zuord 9 Zuord 10
      1        NA      NA       NA
      2        NA      NA       NA
      3        NA      NA       NA
      4        NA      NA       NA
      5        NA      NA       NA
      6        NA      NA       NA
      7        NA      NA       NA
      8        NA      NA       NA
      9        NA      NA       NA
      10       NA      NA       NA
      11       NA      NA       NA
      12       NA      NA       NA
      13       NA      NA       NA
      14       NA      NA       NA
      15       NA      NA       NA
      16       NA      NA       NA
      17       NA      NA       NA
      18       NA      NA       NA
      19       NA      NA       NA
      20       NA      NA       NA
      21       NA      NA       NA
      22       NA      NA       NA
      23       NA      NA       NA
      24       NA      NA       NA
      25       NA      NA       NA
      26       NA      NA       NA
      27       NA      NA       NA
      28       NA      NA       NA
      29       NA      NA       NA
      30       NA      NA       NA
      31       NA      NA       NA
      32       NA      NA       NA
      33       NA      NA       NA
      34       NA      NA       NA
      35       NA      NA       NA
      36       NA      NA       NA
      37       NA      NA       NA
      38       NA      NA       NA
      39       NA      NA       NA
      40       NA      NA       NA
      41       NA      NA       NA
      42       NA      NA       NA
      43       NA      NA       NA
      44       NA      NA       NA
      45       NA      NA       NA
      46       NA      NA       NA
      47       NA      NA       NA
      48       NA      NA       NA
      49       NA      NA       NA
      50       NA      NA       NA
      51       NA      NA       NA
      52       NA      NA       NA
      53       NA      NA       NA
      54       NA      NA       NA
      55       NA      NA       NA
      56       NA      NA       NA
      57       NA      NA       NA
      58       NA      NA       NA
      59       NA      NA       NA
      60       NA      NA       NA
      61       NA      NA       NA
      62       NA      NA       NA
      63       NA      NA       NA
      64       NA      NA       NA
      65       NA      NA       NA
      66       NA      NA       NA
      67       NA      NA       NA
      68       NA      NA       NA
      69       NA      NA       NA
      70       NA      NA       NA
      71       NA      NA       NA
      72       NA      NA       NA
      73       NA      NA       NA
      74       NA      NA       NA
      75       NA      NA       NA
      76       NA      NA       NA
      77       NA      NA       NA
      78       NA      NA       NA
      79       NA      NA       NA
      80       NA      NA       NA
      81       NA      NA       NA
      82       NA      NA       NA
      83       NA      NA       NA
      84       NA      NA       NA
      85       NA      NA       NA
      86       NA      NA       NA
      87       NA      NA       NA
      88       NA      NA       NA
      89       NA      NA       NA
      90       NA      NA       NA
      91       NA      NA       NA
      92       NA      NA       NA
      93       NA      NA       NA
      94       NA      NA       NA
      95       NA      NA       NA
      96       NA      NA       NA
      97       NA      NA       NA
      98       NA      NA       NA
      99       NA      NA       NA
      100      NA      NA       NA
      
      $Verbatims[[3]]$labs
      $Verbatims[[3]]$labs$q6mdg
        Code       lab
      1    1      love
      2    2       joy
      3    3 happiness
      4    4  noch wat
      5   97    Others
      6   99 No answer
      
      
      
      $Verbatims[[4]]
      $Verbatims[[4]]$name
      [1] "q6mdg"
      
      $Verbatims[[4]]$meta
         q_id VariableOriginal EFA1MCG2MDG3 VariableZiel ex_further_cond ex_assign
      1 q6mdg          q6_test            3  q6test_{nn}            <NA>      <NA>
      
      $Verbatims[[4]]$assignments
          orig_var      ID Zuord 1 Zuord 2 Zuord 3 Zuord 4 Zuord 5 Zuord 6 Zuord 7
      101  q6_test       1       1       1      NA      NA      NA      NA      NA
      102  q6_test 9999999      NA      NA      NA      NA      NA      NA      NA
          Zuord 8 Zuord 9 Zuord 10
      101      NA      NA       NA
      102      NA      NA       NA
      
      $Verbatims[[4]]$labs
      $Verbatims[[4]]$labs$q6mdg
        Code       lab
      1    1      love
      2    2       joy
      3    3 happiness
      4    4  noch wat
      5   97    Others
      6   99 No answer
      
      
      
      $Verbatims[[5]]
      $Verbatims[[5]]$name
      [1] "q6mcg"
      
      $Verbatims[[5]]$meta
         q_id VariableOriginal EFA1MCG2MDG3 VariableZiel ex_further_cond ex_assign
      1 q6mcg               q6            2      q6n{nn}            <NA>      <NA>
      
      $Verbatims[[5]]$assignments
          orig_var  ID Zuord 1 Zuord 2 Zuord 3 Zuord 4 Zuord 5 Zuord 6 Zuord 7
      1         q6   7       1       4      NA      NA      NA      NA      NA
      2         q6  17       1      NA      NA      NA      NA      NA      NA
      3         q6  23       1      NA      NA      NA      NA      NA      NA
      4         q6  51       1      NA      NA      NA      NA      NA      NA
      5         q6  58       1       4      NA      NA      NA      NA      NA
      6         q6  65       1      NA      NA      NA      NA      NA      NA
      7         q6  67       1      NA      NA      NA      NA      NA      NA
      8         q6  73       1       4      NA      NA      NA      NA      NA
      9         q6  74       1      NA      NA      NA      NA      NA      NA
      10        q6  91       1      NA      NA      NA      NA      NA      NA
      11        q6 100       1      NA      NA      NA      NA      NA      NA
      12        q6   3       2      NA      NA      NA      NA      NA      NA
      13        q6  13       2      NA      NA      NA      NA      NA      NA
      14        q6  22       2      NA      NA      NA      NA      NA      NA
      15        q6  26       2      NA      NA      NA      NA      NA      NA
      16        q6  35       2      NA      NA      NA      NA      NA      NA
      17        q6  38       2      NA      NA      NA      NA      NA      NA
      18        q6  45       2      NA      NA      NA      NA      NA      NA
      19        q6  47       2      NA      NA      NA      NA      NA      NA
      20        q6  55       2      NA      NA      NA      NA      NA      NA
      21        q6  72       2      NA      NA      NA      NA      NA      NA
      22        q6  78       2      NA      NA      NA      NA      NA      NA
      23        q6  88       2      NA      NA      NA      NA      NA      NA
      24        q6  89       2      NA      NA      NA      NA      NA      NA
      25        q6  97       2      NA      NA      NA      NA      NA      NA
      26        q6   5       3      NA      NA      NA      NA      NA      NA
      27        q6  12       3      NA      NA      NA      NA      NA      NA
      28        q6  14       3      NA      NA      NA      NA      NA      NA
      29        q6  39       3      NA      NA      NA      NA      NA      NA
      30        q6  49       3      NA      NA      NA      NA      NA      NA
      31        q6  62       3      NA      NA      NA      NA      NA      NA
      32        q6  79       3      NA      NA      NA      NA      NA      NA
      33        q6  98       3      NA      NA      NA      NA      NA      NA
      34        q6   8       1      NA      NA      NA      NA      NA      NA
      35        q6   9       1      NA      NA      NA      NA      NA      NA
      36        q6  24       1      NA      NA      NA      NA      NA      NA
      37        q6  30       1      NA      NA      NA      NA      NA      NA
      38        q6  32       1      NA      NA      NA      NA      NA      NA
      39        q6  36       1      NA      NA      NA      NA      NA      NA
      40        q6  53       1      NA      NA      NA      NA      NA      NA
      41        q6  61       1      NA      NA      NA      NA      NA      NA
      42        q6  70       1      NA      NA      NA      NA      NA      NA
      43        q6   4       2      NA      NA      NA      NA      NA      NA
      44        q6   6       2      NA      NA      NA      NA      NA      NA
      45        q6  19       2      NA      NA      NA      NA      NA      NA
      46        q6  25       2      NA      NA      NA      NA      NA      NA
      47        q6  28       2      NA      NA      NA      NA      NA      NA
      48        q6  34       2      NA      NA      NA      NA      NA      NA
      49        q6  44       2      NA      NA      NA      NA      NA      NA
      50        q6  52       2      NA      NA      NA      NA      NA      NA
      51        q6  54       2      NA      NA      NA      NA      NA      NA
      52        q6  56       2      NA      NA      NA      NA      NA      NA
      53        q6  57       2      NA      NA      NA      NA      NA      NA
      54        q6  66       2      NA      NA      NA      NA      NA      NA
      55        q6  71       2      NA      NA      NA      NA      NA      NA
      56        q6  77       2      NA      NA      NA      NA      NA      NA
      57        q6  83       2      NA      NA      NA      NA      NA      NA
      58        q6  85       2      NA      NA      NA      NA      NA      NA
      59        q6  90       2      NA      NA      NA      NA      NA      NA
      60        q6  94       2      NA      NA      NA      NA      NA      NA
      61        q6  96       2      NA      NA      NA      NA      NA      NA
      62        q6   2       3      NA      NA      NA      NA      NA      NA
      63        q6  15       3      NA      NA      NA      NA      NA      NA
      64        q6  21       3      NA      NA      NA      NA      NA      NA
      65        q6  27       3      NA      NA      NA      NA      NA      NA
      66        q6  37       3      NA      NA      NA      NA      NA      NA
      67        q6  40       3      NA      NA      NA      NA      NA      NA
      68        q6  63       3      NA      NA      NA      NA      NA      NA
      69        q6  69       3      NA      NA      NA      NA      NA      NA
      70        q6  76       3      NA      NA      NA      NA      NA      NA
      71        q6  99       3      NA      NA      NA      NA      NA      NA
      72        q6   1       1      NA      NA      NA      NA      NA      NA
      73        q6  10       1      NA      NA      NA      NA      NA      NA
      74        q6  16       1      NA      NA      NA      NA      NA      NA
      75        q6  33       1      NA      NA      NA      NA      NA      NA
      76        q6  41       1      NA      NA      NA      NA      NA      NA
      77        q6  42       1      NA      NA      NA      NA      NA      NA
      78        q6  68       1      NA      NA      NA      NA      NA      NA
      79        q6  75       1      NA      NA      NA      NA      NA      NA
      80        q6  82       1      NA      NA      NA      NA      NA      NA
      81        q6  86       1      NA      NA      NA      NA      NA      NA
      82        q6  93       1      NA      NA      NA      NA      NA      NA
      83        q6  11       2      NA      NA      NA      NA      NA      NA
      84        q6  20       2      NA      NA      NA      NA      NA      NA
      85        q6  29       2      NA      NA      NA      NA      NA      NA
      86        q6  46       2      NA      NA      NA      NA      NA      NA
      87        q6  50       2      NA      NA      NA      NA      NA      NA
      88        q6  81       2      NA      NA      NA      NA      NA      NA
      89        q6  84       2      NA      NA      NA      NA      NA      NA
      90        q6  87       2      NA      NA      NA      NA      NA      NA
      91        q6  18       3      NA      NA      NA      NA      NA      NA
      92        q6  31       3      NA      NA      NA      NA      NA      NA
      93        q6  43       3      NA      NA      NA      NA      NA      NA
      94        q6  48       3      NA      NA      NA      NA      NA      NA
      95        q6  59       3      NA      NA      NA      NA      NA      NA
      96        q6  60       3      NA      NA      NA      NA      NA      NA
      97        q6  64       3      NA      NA      NA      NA      NA      NA
      98        q6  80       3      NA      NA      NA      NA      NA      NA
      99        q6  92       3      NA      NA      NA      NA      NA      NA
      100       q6  95       3      NA      NA      NA      NA      NA      NA
          Zuord 8 Zuord 9 Zuord 10
      1        NA      NA       NA
      2        NA      NA       NA
      3        NA      NA       NA
      4        NA      NA       NA
      5        NA      NA       NA
      6        NA      NA       NA
      7        NA      NA       NA
      8        NA      NA       NA
      9        NA      NA       NA
      10       NA      NA       NA
      11       NA      NA       NA
      12       NA      NA       NA
      13       NA      NA       NA
      14       NA      NA       NA
      15       NA      NA       NA
      16       NA      NA       NA
      17       NA      NA       NA
      18       NA      NA       NA
      19       NA      NA       NA
      20       NA      NA       NA
      21       NA      NA       NA
      22       NA      NA       NA
      23       NA      NA       NA
      24       NA      NA       NA
      25       NA      NA       NA
      26       NA      NA       NA
      27       NA      NA       NA
      28       NA      NA       NA
      29       NA      NA       NA
      30       NA      NA       NA
      31       NA      NA       NA
      32       NA      NA       NA
      33       NA      NA       NA
      34       NA      NA       NA
      35       NA      NA       NA
      36       NA      NA       NA
      37       NA      NA       NA
      38       NA      NA       NA
      39       NA      NA       NA
      40       NA      NA       NA
      41       NA      NA       NA
      42       NA      NA       NA
      43       NA      NA       NA
      44       NA      NA       NA
      45       NA      NA       NA
      46       NA      NA       NA
      47       NA      NA       NA
      48       NA      NA       NA
      49       NA      NA       NA
      50       NA      NA       NA
      51       NA      NA       NA
      52       NA      NA       NA
      53       NA      NA       NA
      54       NA      NA       NA
      55       NA      NA       NA
      56       NA      NA       NA
      57       NA      NA       NA
      58       NA      NA       NA
      59       NA      NA       NA
      60       NA      NA       NA
      61       NA      NA       NA
      62       NA      NA       NA
      63       NA      NA       NA
      64       NA      NA       NA
      65       NA      NA       NA
      66       NA      NA       NA
      67       NA      NA       NA
      68       NA      NA       NA
      69       NA      NA       NA
      70       NA      NA       NA
      71       NA      NA       NA
      72       NA      NA       NA
      73       NA      NA       NA
      74       NA      NA       NA
      75       NA      NA       NA
      76       NA      NA       NA
      77       NA      NA       NA
      78       NA      NA       NA
      79       NA      NA       NA
      80       NA      NA       NA
      81       NA      NA       NA
      82       NA      NA       NA
      83       NA      NA       NA
      84       NA      NA       NA
      85       NA      NA       NA
      86       NA      NA       NA
      87       NA      NA       NA
      88       NA      NA       NA
      89       NA      NA       NA
      90       NA      NA       NA
      91       NA      NA       NA
      92       NA      NA       NA
      93       NA      NA       NA
      94       NA      NA       NA
      95       NA      NA       NA
      96       NA      NA       NA
      97       NA      NA       NA
      98       NA      NA       NA
      99       NA      NA       NA
      100      NA      NA       NA
      
      $Verbatims[[5]]$labs
      $Verbatims[[5]]$labs$q6mcg
        Code       lab
      1    1      love
      2    2       joy
      3    3 happiness
      4    4  noch wat
      5   97    Others
      6   99 No answer
      
      
      
      $Verbatims[[6]]
      $Verbatims[[6]]$name
      [1] "q6mdg"
      
      $Verbatims[[6]]$meta
         q_id VariableOriginal EFA1MCG2MDG3 VariableZiel ex_further_cond ex_assign
      1 q6mdg               q6   mdg_custom    q6mw_{nn}            <NA>        q1
      
      $Verbatims[[6]]$assignments
          orig_var  ID Zuord 1 Zuord 2 Zuord 3 Zuord 4 Zuord 5 Zuord 6 Zuord 7
      1         q6   7       1       4      NA      NA      NA      NA      NA
      2         q6  17       1      NA      NA      NA      NA      NA      NA
      3         q6  23       1      NA      NA      NA      NA      NA      NA
      4         q6  51       1      NA      NA      NA      NA      NA      NA
      5         q6  58       1       4      NA      NA      NA      NA      NA
      6         q6  65       1      NA      NA      NA      NA      NA      NA
      7         q6  67       1      NA      NA      NA      NA      NA      NA
      8         q6  73       1       4      NA      NA      NA      NA      NA
      9         q6  74       1      NA      NA      NA      NA      NA      NA
      10        q6  91       1      NA      NA      NA      NA      NA      NA
      11        q6 100       1      NA      NA      NA      NA      NA      NA
      12        q6   3       2      NA      NA      NA      NA      NA      NA
      13        q6  13       2      NA      NA      NA      NA      NA      NA
      14        q6  22       2      NA      NA      NA      NA      NA      NA
      15        q6  26       2      NA      NA      NA      NA      NA      NA
      16        q6  35       2      NA      NA      NA      NA      NA      NA
      17        q6  38       2      NA      NA      NA      NA      NA      NA
      18        q6  45       2      NA      NA      NA      NA      NA      NA
      19        q6  47       2      NA      NA      NA      NA      NA      NA
      20        q6  55       2      NA      NA      NA      NA      NA      NA
      21        q6  72       2      NA      NA      NA      NA      NA      NA
      22        q6  78       2      NA      NA      NA      NA      NA      NA
      23        q6  88       2      NA      NA      NA      NA      NA      NA
      24        q6  89       2      NA      NA      NA      NA      NA      NA
      25        q6  97       2      NA      NA      NA      NA      NA      NA
      26        q6   5       3      NA      NA      NA      NA      NA      NA
      27        q6  12       3      NA      NA      NA      NA      NA      NA
      28        q6  14       3      NA      NA      NA      NA      NA      NA
      29        q6  39       3      NA      NA      NA      NA      NA      NA
      30        q6  49       3      NA      NA      NA      NA      NA      NA
      31        q6  62       3      NA      NA      NA      NA      NA      NA
      32        q6  79       3      NA      NA      NA      NA      NA      NA
      33        q6  98       3      NA      NA      NA      NA      NA      NA
      34        q6   8       1      NA      NA      NA      NA      NA      NA
      35        q6   9       1      NA      NA      NA      NA      NA      NA
      36        q6  24       1      NA      NA      NA      NA      NA      NA
      37        q6  30       1      NA      NA      NA      NA      NA      NA
      38        q6  32       1      NA      NA      NA      NA      NA      NA
      39        q6  36       1      NA      NA      NA      NA      NA      NA
      40        q6  53       1      NA      NA      NA      NA      NA      NA
      41        q6  61       1      NA      NA      NA      NA      NA      NA
      42        q6  70       1      NA      NA      NA      NA      NA      NA
      43        q6   4       2      NA      NA      NA      NA      NA      NA
      44        q6   6       2      NA      NA      NA      NA      NA      NA
      45        q6  19       2      NA      NA      NA      NA      NA      NA
      46        q6  25       2      NA      NA      NA      NA      NA      NA
      47        q6  28       2      NA      NA      NA      NA      NA      NA
      48        q6  34       2      NA      NA      NA      NA      NA      NA
      49        q6  44       2      NA      NA      NA      NA      NA      NA
      50        q6  52       2      NA      NA      NA      NA      NA      NA
      51        q6  54       2      NA      NA      NA      NA      NA      NA
      52        q6  56       2      NA      NA      NA      NA      NA      NA
      53        q6  57       2      NA      NA      NA      NA      NA      NA
      54        q6  66       2      NA      NA      NA      NA      NA      NA
      55        q6  71       2      NA      NA      NA      NA      NA      NA
      56        q6  77       2      NA      NA      NA      NA      NA      NA
      57        q6  83       2      NA      NA      NA      NA      NA      NA
      58        q6  85       2      NA      NA      NA      NA      NA      NA
      59        q6  90       2      NA      NA      NA      NA      NA      NA
      60        q6  94       2      NA      NA      NA      NA      NA      NA
      61        q6  96       2      NA      NA      NA      NA      NA      NA
      62        q6   2       3      NA      NA      NA      NA      NA      NA
      63        q6  15       3      NA      NA      NA      NA      NA      NA
      64        q6  21       3      NA      NA      NA      NA      NA      NA
      65        q6  27       3      NA      NA      NA      NA      NA      NA
      66        q6  37       3      NA      NA      NA      NA      NA      NA
      67        q6  40       3      NA      NA      NA      NA      NA      NA
      68        q6  63       3      NA      NA      NA      NA      NA      NA
      69        q6  69       3      NA      NA      NA      NA      NA      NA
      70        q6  76       3      NA      NA      NA      NA      NA      NA
      71        q6  99       3      NA      NA      NA      NA      NA      NA
      72        q6   1       1      NA      NA      NA      NA      NA      NA
      73        q6  10       1      NA      NA      NA      NA      NA      NA
      74        q6  16       1      NA      NA      NA      NA      NA      NA
      75        q6  33       1      NA      NA      NA      NA      NA      NA
      76        q6  41       1      NA      NA      NA      NA      NA      NA
      77        q6  42       1      NA      NA      NA      NA      NA      NA
      78        q6  68       1      NA      NA      NA      NA      NA      NA
      79        q6  75       1      NA      NA      NA      NA      NA      NA
      80        q6  82       1      NA      NA      NA      NA      NA      NA
      81        q6  86       1      NA      NA      NA      NA      NA      NA
      82        q6  93       1      NA      NA      NA      NA      NA      NA
      83        q6  11       2      NA      NA      NA      NA      NA      NA
      84        q6  20       2      NA      NA      NA      NA      NA      NA
      85        q6  29       2      NA      NA      NA      NA      NA      NA
      86        q6  46       2      NA      NA      NA      NA      NA      NA
      87        q6  50       2      NA      NA      NA      NA      NA      NA
      88        q6  81       2      NA      NA      NA      NA      NA      NA
      89        q6  84       2      NA      NA      NA      NA      NA      NA
      90        q6  87       2      NA      NA      NA      NA      NA      NA
      91        q6  18       3      NA      NA      NA      NA      NA      NA
      92        q6  31       3      NA      NA      NA      NA      NA      NA
      93        q6  43       3      NA      NA      NA      NA      NA      NA
      94        q6  48       3      NA      NA      NA      NA      NA      NA
      95        q6  59       3      NA      NA      NA      NA      NA      NA
      96        q6  60       3      NA      NA      NA      NA      NA      NA
      97        q6  64       3      NA      NA      NA      NA      NA      NA
      98        q6  80       3      NA      NA      NA      NA      NA      NA
      99        q6  92       3      NA      NA      NA      NA      NA      NA
      100       q6  95       3      NA      NA      NA      NA      NA      NA
          Zuord 8 Zuord 9 Zuord 10
      1        NA      NA       NA
      2        NA      NA       NA
      3        NA      NA       NA
      4        NA      NA       NA
      5        NA      NA       NA
      6        NA      NA       NA
      7        NA      NA       NA
      8        NA      NA       NA
      9        NA      NA       NA
      10       NA      NA       NA
      11       NA      NA       NA
      12       NA      NA       NA
      13       NA      NA       NA
      14       NA      NA       NA
      15       NA      NA       NA
      16       NA      NA       NA
      17       NA      NA       NA
      18       NA      NA       NA
      19       NA      NA       NA
      20       NA      NA       NA
      21       NA      NA       NA
      22       NA      NA       NA
      23       NA      NA       NA
      24       NA      NA       NA
      25       NA      NA       NA
      26       NA      NA       NA
      27       NA      NA       NA
      28       NA      NA       NA
      29       NA      NA       NA
      30       NA      NA       NA
      31       NA      NA       NA
      32       NA      NA       NA
      33       NA      NA       NA
      34       NA      NA       NA
      35       NA      NA       NA
      36       NA      NA       NA
      37       NA      NA       NA
      38       NA      NA       NA
      39       NA      NA       NA
      40       NA      NA       NA
      41       NA      NA       NA
      42       NA      NA       NA
      43       NA      NA       NA
      44       NA      NA       NA
      45       NA      NA       NA
      46       NA      NA       NA
      47       NA      NA       NA
      48       NA      NA       NA
      49       NA      NA       NA
      50       NA      NA       NA
      51       NA      NA       NA
      52       NA      NA       NA
      53       NA      NA       NA
      54       NA      NA       NA
      55       NA      NA       NA
      56       NA      NA       NA
      57       NA      NA       NA
      58       NA      NA       NA
      59       NA      NA       NA
      60       NA      NA       NA
      61       NA      NA       NA
      62       NA      NA       NA
      63       NA      NA       NA
      64       NA      NA       NA
      65       NA      NA       NA
      66       NA      NA       NA
      67       NA      NA       NA
      68       NA      NA       NA
      69       NA      NA       NA
      70       NA      NA       NA
      71       NA      NA       NA
      72       NA      NA       NA
      73       NA      NA       NA
      74       NA      NA       NA
      75       NA      NA       NA
      76       NA      NA       NA
      77       NA      NA       NA
      78       NA      NA       NA
      79       NA      NA       NA
      80       NA      NA       NA
      81       NA      NA       NA
      82       NA      NA       NA
      83       NA      NA       NA
      84       NA      NA       NA
      85       NA      NA       NA
      86       NA      NA       NA
      87       NA      NA       NA
      88       NA      NA       NA
      89       NA      NA       NA
      90       NA      NA       NA
      91       NA      NA       NA
      92       NA      NA       NA
      93       NA      NA       NA
      94       NA      NA       NA
      95       NA      NA       NA
      96       NA      NA       NA
      97       NA      NA       NA
      98       NA      NA       NA
      99       NA      NA       NA
      100      NA      NA       NA
      
      $Verbatims[[6]]$labs
      $Verbatims[[6]]$labs$q6mdg
        Code       lab
      1    1      love
      2    2       joy
      3    3 happiness
      4    4  noch wat
      5   97    Others
      6   99 No answer
      
      
      
      $Verbatims[[7]]
      $Verbatims[[7]]$name
      [1] "q6mdg"
      
      $Verbatims[[7]]$meta
         q_id VariableOriginal EFA1MCG2MDG3      VariableZiel ex_further_cond
      1 q6mdg               q6   mdg_custom q6_assign_nn_{nn}            <NA>
        ex_assign
      1     q{nn}
      
      $Verbatims[[7]]$assignments
          orig_var  ID Zuord 1 Zuord 2 Zuord 3 Zuord 4 Zuord 5 Zuord 6 Zuord 7
      1         q6   7       1       4      NA      NA      NA      NA      NA
      2         q6  17       1      NA      NA      NA      NA      NA      NA
      3         q6  23       1      NA      NA      NA      NA      NA      NA
      4         q6  51       1      NA      NA      NA      NA      NA      NA
      5         q6  58       1       4      NA      NA      NA      NA      NA
      6         q6  65       1      NA      NA      NA      NA      NA      NA
      7         q6  67       1      NA      NA      NA      NA      NA      NA
      8         q6  73       1       4      NA      NA      NA      NA      NA
      9         q6  74       1      NA      NA      NA      NA      NA      NA
      10        q6  91       1      NA      NA      NA      NA      NA      NA
      11        q6 100       1      NA      NA      NA      NA      NA      NA
      12        q6   3       2      NA      NA      NA      NA      NA      NA
      13        q6  13       2      NA      NA      NA      NA      NA      NA
      14        q6  22       2      NA      NA      NA      NA      NA      NA
      15        q6  26       2      NA      NA      NA      NA      NA      NA
      16        q6  35       2      NA      NA      NA      NA      NA      NA
      17        q6  38       2      NA      NA      NA      NA      NA      NA
      18        q6  45       2      NA      NA      NA      NA      NA      NA
      19        q6  47       2      NA      NA      NA      NA      NA      NA
      20        q6  55       2      NA      NA      NA      NA      NA      NA
      21        q6  72       2      NA      NA      NA      NA      NA      NA
      22        q6  78       2      NA      NA      NA      NA      NA      NA
      23        q6  88       2      NA      NA      NA      NA      NA      NA
      24        q6  89       2      NA      NA      NA      NA      NA      NA
      25        q6  97       2      NA      NA      NA      NA      NA      NA
      26        q6   5       3      NA      NA      NA      NA      NA      NA
      27        q6  12       3      NA      NA      NA      NA      NA      NA
      28        q6  14       3      NA      NA      NA      NA      NA      NA
      29        q6  39       3      NA      NA      NA      NA      NA      NA
      30        q6  49       3      NA      NA      NA      NA      NA      NA
      31        q6  62       3      NA      NA      NA      NA      NA      NA
      32        q6  79       3      NA      NA      NA      NA      NA      NA
      33        q6  98       3      NA      NA      NA      NA      NA      NA
      34        q6   8       1      NA      NA      NA      NA      NA      NA
      35        q6   9       1      NA      NA      NA      NA      NA      NA
      36        q6  24       1      NA      NA      NA      NA      NA      NA
      37        q6  30       1      NA      NA      NA      NA      NA      NA
      38        q6  32       1      NA      NA      NA      NA      NA      NA
      39        q6  36       1      NA      NA      NA      NA      NA      NA
      40        q6  53       1      NA      NA      NA      NA      NA      NA
      41        q6  61       1      NA      NA      NA      NA      NA      NA
      42        q6  70       1      NA      NA      NA      NA      NA      NA
      43        q6   4       2      NA      NA      NA      NA      NA      NA
      44        q6   6       2      NA      NA      NA      NA      NA      NA
      45        q6  19       2      NA      NA      NA      NA      NA      NA
      46        q6  25       2      NA      NA      NA      NA      NA      NA
      47        q6  28       2      NA      NA      NA      NA      NA      NA
      48        q6  34       2      NA      NA      NA      NA      NA      NA
      49        q6  44       2      NA      NA      NA      NA      NA      NA
      50        q6  52       2      NA      NA      NA      NA      NA      NA
      51        q6  54       2      NA      NA      NA      NA      NA      NA
      52        q6  56       2      NA      NA      NA      NA      NA      NA
      53        q6  57       2      NA      NA      NA      NA      NA      NA
      54        q6  66       2      NA      NA      NA      NA      NA      NA
      55        q6  71       2      NA      NA      NA      NA      NA      NA
      56        q6  77       2      NA      NA      NA      NA      NA      NA
      57        q6  83       2      NA      NA      NA      NA      NA      NA
      58        q6  85       2      NA      NA      NA      NA      NA      NA
      59        q6  90       2      NA      NA      NA      NA      NA      NA
      60        q6  94       2      NA      NA      NA      NA      NA      NA
      61        q6  96       2      NA      NA      NA      NA      NA      NA
      62        q6   2       3      NA      NA      NA      NA      NA      NA
      63        q6  15       3      NA      NA      NA      NA      NA      NA
      64        q6  21       3      NA      NA      NA      NA      NA      NA
      65        q6  27       3      NA      NA      NA      NA      NA      NA
      66        q6  37       3      NA      NA      NA      NA      NA      NA
      67        q6  40       3      NA      NA      NA      NA      NA      NA
      68        q6  63       3      NA      NA      NA      NA      NA      NA
      69        q6  69       3      NA      NA      NA      NA      NA      NA
      70        q6  76       3      NA      NA      NA      NA      NA      NA
      71        q6  99       3      NA      NA      NA      NA      NA      NA
      72        q6   1       1      NA      NA      NA      NA      NA      NA
      73        q6  10       1      NA      NA      NA      NA      NA      NA
      74        q6  16       1      NA      NA      NA      NA      NA      NA
      75        q6  33       1      NA      NA      NA      NA      NA      NA
      76        q6  41       1      NA      NA      NA      NA      NA      NA
      77        q6  42       1      NA      NA      NA      NA      NA      NA
      78        q6  68       1      NA      NA      NA      NA      NA      NA
      79        q6  75       1      NA      NA      NA      NA      NA      NA
      80        q6  82       1      NA      NA      NA      NA      NA      NA
      81        q6  86       1      NA      NA      NA      NA      NA      NA
      82        q6  93       1      NA      NA      NA      NA      NA      NA
      83        q6  11       2      NA      NA      NA      NA      NA      NA
      84        q6  20       2      NA      NA      NA      NA      NA      NA
      85        q6  29       2      NA      NA      NA      NA      NA      NA
      86        q6  46       2      NA      NA      NA      NA      NA      NA
      87        q6  50       2      NA      NA      NA      NA      NA      NA
      88        q6  81       2      NA      NA      NA      NA      NA      NA
      89        q6  84       2      NA      NA      NA      NA      NA      NA
      90        q6  87       2      NA      NA      NA      NA      NA      NA
      91        q6  18       3      NA      NA      NA      NA      NA      NA
      92        q6  31       3      NA      NA      NA      NA      NA      NA
      93        q6  43       3      NA      NA      NA      NA      NA      NA
      94        q6  48       3      NA      NA      NA      NA      NA      NA
      95        q6  59       3      NA      NA      NA      NA      NA      NA
      96        q6  60       3      NA      NA      NA      NA      NA      NA
      97        q6  64       3      NA      NA      NA      NA      NA      NA
      98        q6  80       3      NA      NA      NA      NA      NA      NA
      99        q6  92       3      NA      NA      NA      NA      NA      NA
      100       q6  95       3      NA      NA      NA      NA      NA      NA
          Zuord 8 Zuord 9 Zuord 10
      1        NA      NA       NA
      2        NA      NA       NA
      3        NA      NA       NA
      4        NA      NA       NA
      5        NA      NA       NA
      6        NA      NA       NA
      7        NA      NA       NA
      8        NA      NA       NA
      9        NA      NA       NA
      10       NA      NA       NA
      11       NA      NA       NA
      12       NA      NA       NA
      13       NA      NA       NA
      14       NA      NA       NA
      15       NA      NA       NA
      16       NA      NA       NA
      17       NA      NA       NA
      18       NA      NA       NA
      19       NA      NA       NA
      20       NA      NA       NA
      21       NA      NA       NA
      22       NA      NA       NA
      23       NA      NA       NA
      24       NA      NA       NA
      25       NA      NA       NA
      26       NA      NA       NA
      27       NA      NA       NA
      28       NA      NA       NA
      29       NA      NA       NA
      30       NA      NA       NA
      31       NA      NA       NA
      32       NA      NA       NA
      33       NA      NA       NA
      34       NA      NA       NA
      35       NA      NA       NA
      36       NA      NA       NA
      37       NA      NA       NA
      38       NA      NA       NA
      39       NA      NA       NA
      40       NA      NA       NA
      41       NA      NA       NA
      42       NA      NA       NA
      43       NA      NA       NA
      44       NA      NA       NA
      45       NA      NA       NA
      46       NA      NA       NA
      47       NA      NA       NA
      48       NA      NA       NA
      49       NA      NA       NA
      50       NA      NA       NA
      51       NA      NA       NA
      52       NA      NA       NA
      53       NA      NA       NA
      54       NA      NA       NA
      55       NA      NA       NA
      56       NA      NA       NA
      57       NA      NA       NA
      58       NA      NA       NA
      59       NA      NA       NA
      60       NA      NA       NA
      61       NA      NA       NA
      62       NA      NA       NA
      63       NA      NA       NA
      64       NA      NA       NA
      65       NA      NA       NA
      66       NA      NA       NA
      67       NA      NA       NA
      68       NA      NA       NA
      69       NA      NA       NA
      70       NA      NA       NA
      71       NA      NA       NA
      72       NA      NA       NA
      73       NA      NA       NA
      74       NA      NA       NA
      75       NA      NA       NA
      76       NA      NA       NA
      77       NA      NA       NA
      78       NA      NA       NA
      79       NA      NA       NA
      80       NA      NA       NA
      81       NA      NA       NA
      82       NA      NA       NA
      83       NA      NA       NA
      84       NA      NA       NA
      85       NA      NA       NA
      86       NA      NA       NA
      87       NA      NA       NA
      88       NA      NA       NA
      89       NA      NA       NA
      90       NA      NA       NA
      91       NA      NA       NA
      92       NA      NA       NA
      93       NA      NA       NA
      94       NA      NA       NA
      95       NA      NA       NA
      96       NA      NA       NA
      97       NA      NA       NA
      98       NA      NA       NA
      99       NA      NA       NA
      100      NA      NA       NA
      
      $Verbatims[[7]]$labs
      $Verbatims[[7]]$labs$q6mdg
        Code       lab
      1    1      love
      2    2       joy
      3    3 happiness
      4    4  noch wat
      5   97    Others
      6   99 No answer
      
      
      
      
      $Free1
      # A tibble: 37 x 6
         X1     X2                     X3                            X4    X5      row
         <chr>  <chr>                  <chr>                         <chr> <chr> <int>
       1 #COMP  "x"                    "q1 == 2"                     <NA>   <NA>     1
       2 #IF    "q1 == 1 | q3 == 2"    "abc = 7"                     <NA>   <NA>     2
       3 #IF    "q{2_renamed 3} == 1"  "kq{5 6} = {7 8}"             <NA>   <NA>     3
       4 #REC   "q{1 3}"               "kq{1 3}"                     summ~  <NA>     5
       5 <NA>   "1"                    "2"                           1     "1-2"     6
       6 <NA>   "3"                    "3"                           2     "3"       7
       7 .      "4"                    "5"                           3     "4-5"     8
       8 <NA>   "1"                    "2"                           3     "lin~     9
       9 <NA>   "1"                    "2"                           3     "lin~    10
      10 #KG    "kq1"                  "q2_renamed"                  <NA>   <NA>    11
      11 #COMP  "n"                    "1"                           <NA>   <NA>    12
      12 #VARL  "n "                   "my new label"                <NA>   <NA>    13
      13 #VALL  "n"                    "overwrite new label"         <NA>   <NA>    15
      14 <NA>   "1"                    "also with"                   <NA>   <NA>    16
      15 <NA>   "2"                    "value labels "               <NA>   <NA>    17
      16 .      "3"                    "now"                         <NA>   <NA>    18
      17 #AVALL "n"                     <NA>                         <NA>   <NA>    20
      18 .      "4"                    "added label"                 <NA>   <NA>    21
      19 #VARL  "q{ 3 5}"              "Almost same variable label ~ <NA>   <NA>    25
      20 <NA>   "should be ignored"     <NA>                         <NA>   <NA>    26
      21 <NA>    <NA>                  "should be ignored"           <NA>   <NA>    27
      22 #COMP  "a{1 2}"               "{3 4}"                       <NA>   <NA>    28
      23 #VARL  "a1 a2 "               "same variable label for a1 ~ <NA>   <NA>    29
      24 #DIC   "q3"                   "q4_renamed"                  <NA>   <NA>    31
      25 <NA>    <NA>                  "!!! Standard auto-correctio~ <NA>   <NA>    32
      26 <NA>    <NA>                  "see here: https://superuser~ <NA>   <NA>    33
      27 #COMPR "r_expr_var"           "haven::labelled(ifelse(q1 =~ <NA>   <NA>    34
      28 #MERGE "fake_survey.sav"      "id"                          q1 q2  <NA>    36
      29 #RFUN  "example_R_function.R" "calc_sum_of_k_vars"          <NA>   <NA>    38
      30 #REC   "q1  "                 "kkq1"                        vl     <NA>    46
      31 <NA>   "1"                     <NA>                         1     "a"      47
      32 <NA>   "2"                     <NA>                         2     "b"      48
      33 <NA>   "3"                     <NA>                         2      <NA>    49
      34 <NA>   "4"                     <NA>                         2      <NA>    50
      35 <NA>   "5"                     <NA>                         2      <NA>    51
      36 #RMVAL "q1"                   "q1"                          new_~  <NA>    54
      37 <NA>   "99"                    <NA>                         <NA>   <NA>    55
      
      $Free2
      # A tibble: 1 x 6
        X1    X2        X3    X4    X5      row
        <chr> <chr>     <chr> <chr> <chr> <int>
      1 #COMP free2_var 3     <NA>  <NA>      1
      

