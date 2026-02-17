# Introduction to survey data tabulation in R

## R for beginners

If you are new to R, you could have a look at one of the many
introductions. For instance:

- [this](https://rstudio-education.github.io/hopr/) is nice, but also
  becomes challenging quite quickly.
- [R for Data Science](https://r4ds.had.co.nz) is the most complete
  reference.
- [here](https://paulvanderlaken.com/2017/10/18/learn-r/) is another
  resource, but already a bit outdated (2017 is a long time in the R
  world).
- [swirl](https://swirlstats.com/students.html) is an interactive
  approach.
- [in this
  reddit](https://www.reddit.com/r/rstats/comments/eh5e4q/what_is_the_best_way_to_learn_r_for_a_complete/)
  you might still find other resources.

In the beginning, R can be very frustrating and it takes time.

## Setup

Click here to show steps in setup

Load packages needed for this document:

``` r

library(datadaptor)
library(tidyr)
library(stringr)
suppressMessages(library(dplyr))
```

## Survey data

### Toy survey

We’ll first define a small toy survey:

#### Q1. what’s your age?

#### Q2. What’s your gender?

- male
- female
- non-binary

#### Q3. Select all that applies

- I’m curious
- I’m cautious
- I’m lazy
- I don’t care

#### Q4. Please rate the following items

*Use a scale from 1 = “I really like it” to 5 = “I don’t like it at
all”.*

- Sports
- Watching TV
- Reading

### Survey data in R

The raw data of surveys is often stored in SPSS .sav files. SPSS files
can be imported in R with the [haven](https://haven.tidyverse.org/)
package. This yields labelled tabular data in data frames containing
variables of type
[`haven::labelled()`](https://haven.tidyverse.org/reference/labelled.html).

Another nice introduction to labelled data in R can be found
[here](https://www.pipinghotdata.com/posts/2020-12-23-leveraging-labelled-data-in-r/).

#### Labelled variables

Before looking at the whole table, let’s first have a look how one
labelled variable (corresponding to one column in tabular survey data)
looks in R.

Let’s define a toy labelled variable `v`:

``` r

v <- haven::labelled(
  1:3,
  label = "Variable label of v",
  labels = c(
    "value label of value 1" = 1,
    "value label of value 2" = 2,
    "value label of value 3" = 3
  )
)
```

… and then print it:

``` r

v
#> <labelled<integer>[3]>: Variable label of v
#> [1] 1 2 3
#> 
#> Labels:
#>  value                  label
#>      1 value label of value 1
#>      2 value label of value 2
#>      3 value label of value 3
```

We can have a different look at the structure of this variable using the
function [`str()`](https://rdrr.io/r/utils/str.html):

``` r

str(v)
#>  int+lbl [1:3] 1, 2, 3
#>  @ labels: Named int [1:3] 1 2 3
#>   ..- attr(*, "names")= chr [1:3] "value label of value 1" "value label of value 2" "value label of value 3"
#>  @ label : chr "Variable label of v"
```

`v` is a labelled integer containing the values 1, 2 and 3. The label
information is stored in extra attributes of the variable. First,
there’s the **variable label** in the attribute “label”, containing the
string “Variable label of v”:

``` r

attr(v, "label")
#> [1] "Variable label of v"
```

Second, a labelled variable can contain **value labels** in the
attribute “labels”:

``` r

attr(v, "labels")
#> value label of value 1 value label of value 2 value label of value 3 
#>                      1                      2                      3
```

This is a named vector where label strings can be assigned to values, in
our case the 3 strings “value label of value 1”, “value label of value
2” and “value label of value 3” are assigned to the 3 values 1, 2 and 3.

In other words, a categorical variable with value labels corresponds to
a numeric vector with a kind of lookup table where a value is assigned
to each of the possible responses.

When a labelled variable inside a
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) is
printed, (parts of) the value labels are printed in brackets (\[…\])
next to their values (cf. the print output of `df` [below](#dfdef)):

``` r

tibble(v)
#> # A tibble: 3 × 1
#>   v                         
#>   <int+lbl>                 
#> 1 1 [value label of value 1]
#> 2 2 [value label of value 2]
#> 3 3 [value label of value 3]
```

### Making up a dataset of the toy survey

We define a small toy dataframe `df` showing how the responses of 10
respondents to the above questionnaire could look like in R.

Click here to show code generating this dataframe

``` r

set.seed(123)
tibble()
#> # A tibble: 0 × 0
q1 <- haven::labelled(sample(18:88, 10, TRUE), label = c("what's your age?"), labels = NULL)
q2 <- haven::labelled(sample(c(NA, 1:3), 10, TRUE), label = c("What's your gender?"), labels = c(male = 1, female = 2, "non-binary" = 3))
q3_1 <- haven::labelled(sample(0:1, 10, TRUE), label = c("Select all that applies - I'm curious"), labels = c(unselected = 0, selected = 1))
q3_2 <- haven::labelled(sample(0:1, 10, TRUE), label = c("Select all that applies - I'm cautios"), labels = c(unselected = 0, selected = 1))
q3_3 <- haven::labelled(sample(0:1, 10, TRUE), label = c("Select all that applies - I'm lazy"), labels = c(unselected = 0, selected = 1))
q3_4 <- haven::labelled(sample(0:1, 10, TRUE), label = c("Select all that applies - I don't care"), labels = c(unselected = 0, selected = 1))
q4_vallabs <- c("1 = I like it" = 1, "2" = 2, "3" = 3, "4" = 4, "5 = I don`t like it at all" = 5)
q4_answers <-
  q4_text <- 'Please rate the following items from 1 = "I really like it" to 5 = "I don`t like it at all'
q4_1 <- haven::labelled(sample(1:5, 10, TRUE), label = paste(q4_text, "Sports", sep = " - "), labels = q4_vallabs)
q4_2 <- haven::labelled(sample(1:5, 10, TRUE), label = paste(q4_text, "Watching TV", sep = " - "), labels = q4_vallabs)
q4_3 <- haven::labelled(sample(1:5, 10, TRUE), label = paste(q4_text, "Reading", sep = " - "), labels = q4_vallabs)

df <- tibble(id = 1:10, q1, q2, q3_1, q3_2, q3_3, q3_4, q4_1, q4_2, q4_3)
```

``` r

df
#> # A tibble: 10 × 10
#>       id q1     q2       q3_1    q3_2    q3_3    q3_4    q4_1    q4_2    q4_3   
#>    <int> <int+> <int+lb> <int+l> <int+l> <int+l> <int+l> <int+l> <int+l> <int+l>
#>  1     1 48      2 [fem… 0 [uns… 0 [uns… 0 [uns… 1 [sel… 3 [3]   1 [1 =… 3 [3]  
#>  2     2 68      2 [fem… 1 [sel… 1 [sel… 0 [uns… 0 [uns… 1 [1 =… 2 [2]   4 [4]  
#>  3     3 31     NA       0 [uns… 0 [uns… 1 [sel… 0 [uns… 5 [5 =… 4 [4]   1 [1 =…
#>  4     4 84      3 [non… 1 [sel… 1 [sel… 0 [uns… 1 [sel… 1 [1 =… 5 [5 =… 3 [3]  
#>  5     5 59     NA       0 [uns… 1 [sel… 0 [uns… 1 [sel… 2 [2]   5 [5 =… 5 [5 =…
#>  6     6 67     NA       1 [sel… 0 [uns… 0 [uns… 0 [uns… 4 [4]   3 [3]   3 [3]  
#>  7     7 60     NA       1 [sel… 0 [uns… 0 [uns… 0 [uns… 4 [4]   1 [1 =… 2 [2]  
#>  8     8 31      2 [fem… 0 [uns… 0 [uns… 1 [sel… 1 [sel… 3 [3]   4 [4]   5 [5 =…
#>  9     9 42      3 [non… 0 [uns… 0 [uns… 1 [sel… 0 [uns… 1 [1 =… 1 [1 =… 5 [5 =…
#> 10    10 86      1 [mal… 0 [uns… 1 [sel… 0 [uns… 0 [uns… 2 [2]   1 [1 =… 3 [3]
```

Each row of the dataset `df` corresponds to one respondent (specified by
the first column `id`). Their answers to the 4 questions are coded in
the other columns. These columns are [labelled variables](#labvars) (of
type
[`haven::labelled()`](https://haven.tidyverse.org/reference/labelled.html)).

## Question types

Let’s have a closer look at the different types of survey questions in
this questionnaire:

### Numeric variable

In addition to the values of age stored in [Q1](#Q1), the variable has
the variable label “what’s your age?”:

``` r

q1
#> <labelled<integer>[10]>: what's your age?
#>  [1] 48 68 31 84 59 67 60 31 42 86
```

### Categorical variable

Question [Q2](#Q2) in the questionnaire asks for a single answer of the
pre-defined choices in the value labels:

``` r

q2
#> <labelled<integer>[10]>: What's your gender?
#>  [1]  2  2 NA  3 NA NA NA  2  3  1
#> 
#> Labels:
#>  value      label
#>      1       male
#>      2     female
#>      3 non-binary
```

Like `q1`, the variable `q2` also contains numeric values (corresponding
to these value labels) and has a variable label.

If the respondent didn’t reply to the question, the information is
missing, which is often stored as `NA` in R (as in the rows 3, 5, 6 and
7 of `q2`.

### Multiple choice questions

In contrast to [Q2](#Q2), the question [Q3](#Q3) allows for multiple
answers. This information usually isn’t stored in a single variable.
Instead you can define a variable for every possible response. For
instance, the first response option “Select all that applies - I’m
curious” is stored in the variable `q3_1`:

``` r

q3_1
#> <labelled<integer>[10]>: Select all that applies - I'm curious
#>  [1] 0 1 0 1 0 1 1 0 0 0
#> 
#> Labels:
#>  value      label
#>      0 unselected
#>      1   selected
```

This is a binary numeric variable with values

- 0 (meaning “unselected”), and
- 1 (meaning “selected”).

``` r

attr(q3_1, "labels")
#> unselected   selected 
#>          0          1
```

### Multiple answers on the same scale

A common pattern in questionnaires is to ask for a rating (or just a
numeric value) of multiple items on the same scale like in [Q4](#Q4).
This information can also be put in categorical (or numeric) variables.
The responses to the first item are stored in the first variable:

``` r

q4_1
#> <labelled<integer>[10]>: Please rate the following items from 1 = "I really like it" to 5 = "I don`t like it at all - Sports
#>  [1] 3 1 5 1 2 4 4 3 1 2
#> 
#> Labels:
#>  value                      label
#>      1              1 = I like it
#>      2                          2
#>      3                          3
#>      4                          4
#>      5 5 = I don`t like it at all
```

## Tabulation of frequency counts of survey data

When analyzing survey data it is of great interest to count how often
the responses occur. We’ll have a look at some recurring tasks using the
examples in our toy survey.

There are also other R packages that can help to modify labelled data
like [labelled](https://larmarange.github.io/labelled/) or
[sjlabelled](https://strengejacke.github.io/sjlabelled/articles/labelleddata.html).

### Numeric variable

*This kind of tabulation is done with the type* **`cat`** *in the type
column of the “Questions” sheet in the Excel mapping file.*

Counting the values in numeric variables is straight-forward:

``` r

df %>% count(q1)
#> # A tibble: 9 × 2
#>   q1            n
#>   <int+lbl> <int>
#> 1 31            2
#> 2 42            1
#> 3 48            1
#> 4 59            1
#> 5 60            1
#> 6 67            1
#> 7 68            1
#> 8 84            1
#> 9 86            1
```

In this case it might be more interesting to summarize the data to age
categories, like for instance

- 18 - 39
- 40 - 59
- 60 +

We can **rec**ode the variable with datadaptor, using the `#REC` command
on one of the `Free` sheets.

| \#REC command block |  |  |  |  |
|----|----|----|----|----|
| recode a numerical variable into a labelled variable summarising intervals |  |  |  |  |
| A¹ | B¹ | C¹ | D¹ | E¹ |
| \#REC | q1 | kq1 | Age category |  |
|  | 18 | 39 | 1 | 18 - 39 |
|  | 40 | 59 | 2 | 40 - 59 |
|  | 60 | Inf | 3 | 60+ |
| ¹ hover over the column names to show the required data in these cells |  |  |  |  |

Be careful, if you want to enter a string like “1 - 20” into excel
because it might turn it into a date 🙃.

Additionally, you might want to add statistics like the mean or the
median to the table:

``` r

mean(q1)
#> [1] 57.6
median(q1)
#> [1] 59.5
```

If you want to put this table in a report, the question text should also
be added somewhere. In our case, you could get this text from the
variable label:

``` r

attr(q1, "label")
#> [1] "what's your age?"
```

But usually it is better to copy the question title from the
questionnaire, as details of surveys tend to change during projects and
the labels in the data file might not be up-to-date.

### Categorical variable

*This kind of tabulation is also done with the type* **`cat`** *in the
type column of the “Questions” sheet in the Excel mapping file.*

The counting of the different replies in a categorical variable is the
same as for a numeric variable:

``` r

df %>% count(q2)
#> # A tibble: 4 × 2
#>   q2                  n
#>   <int+lbl>       <int>
#> 1  1 [male]           1
#> 2  2 [female]         3
#> 3  3 [non-binary]     2
#> 4 NA                  4
```

If we want to assign a text to the cases where no answer was given, we
can directly modify the dataset `df`:

``` r

df$q2[is.na(df$q2)] <- 4
```

Now, the cases where `q2` was NA before were set to 4:

``` r

df %>% count(q2)
#> # A tibble: 4 × 2
#>   q2                 n
#>   <int+lbl>      <int>
#> 1 1 [male]           1
#> 2 2 [female]         3
#> 3 3 [non-binary]     2
#> 4 4                  4
```

In order to label this new value 4, we need to modify the value labels
of the variable:

``` r

attr(df$q2, "labels") <- c(
  attr(df$q2, "labels"),
  "No answer" = 4
)
```

Now, we added the value label “No answer” the new value 4:

``` r

df %>% count(q2)
#> # A tibble: 4 × 2
#>   q2                 n
#>   <int+lbl>      <int>
#> 1 1 [male]           1
#> 2 2 [female]         3
#> 3 3 [non-binary]     2
#> 4 4 [No answer]      4
```

Alternatively, we can modify the variable with datadaptor, using the
`#IF` command on one of the `Free` sheets.

To **a**dd a **val**ue **l**abel with datadaptor, we can use the
`#AVALL` command on one of the `Free` sheets:

| A       | B         | C         |
|---------|-----------|-----------|
| \#IF    | is.na(q2) | q2 = 4    |
| \#AVALL | q2        |           |
|         | 4         | No answer |

### Multiple choice questions

*This kind of tabulation is done with the type* **`mdg`** *in the type
column of the “Questions” sheet in the Excel mapping file.*

Tabulating the answers of multiple choice questions as categorical
variables doesn’t lead to a nice output:

``` r

df %>% count(q3_1)
#> # A tibble: 2 × 2
#>   q3_1               n
#>   <int+lbl>      <int>
#> 1 0 [unselected]     6
#> 2 1 [selected]       4
df %>% count(q3_2)
#> # A tibble: 2 × 2
#>   q3_2               n
#>   <int+lbl>      <int>
#> 1 0 [unselected]     6
#> 2 1 [selected]       4
# ...
```

Instead, we’ll first transform `df_q3` the data relevant for [Q3](#Q3):

``` r

df_q3 <- df %>% select(q3_1:q3_4)
df_q3
#> # A tibble: 10 × 4
#>    q3_1           q3_2           q3_3           q3_4          
#>    <int+lbl>      <int+lbl>      <int+lbl>      <int+lbl>     
#>  1 0 [unselected] 0 [unselected] 0 [unselected] 1 [selected]  
#>  2 1 [selected]   1 [selected]   0 [unselected] 0 [unselected]
#>  3 0 [unselected] 0 [unselected] 1 [selected]   0 [unselected]
#>  4 1 [selected]   1 [selected]   0 [unselected] 1 [selected]  
#>  5 0 [unselected] 1 [selected]   0 [unselected] 1 [selected]  
#>  6 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected]
#>  7 1 [selected]   0 [unselected] 0 [unselected] 0 [unselected]
#>  8 0 [unselected] 0 [unselected] 1 [selected]   1 [selected]  
#>  9 0 [unselected] 0 [unselected] 1 [selected]   0 [unselected]
#> 10 0 [unselected] 1 [selected]   0 [unselected] 0 [unselected]
```

… into a long format:

``` r

df_q3_long <- df_q3 %>%
  pivot_longer(everything(), names_to = "var")
df_q3_long
#> # A tibble: 40 × 2
#>    var   value         
#>    <chr> <int+lbl>     
#>  1 q3_1  0 [unselected]
#>  2 q3_2  0 [unselected]
#>  3 q3_3  0 [unselected]
#>  4 q3_4  1 [selected]  
#>  5 q3_1  1 [selected]  
#>  6 q3_2  1 [selected]  
#>  7 q3_3  0 [unselected]
#>  8 q3_4  0 [unselected]
#>  9 q3_1  0 [unselected]
#> 10 q3_2  0 [unselected]
#> # ℹ 30 more rows
```

… and we’ll only consider those cases where those variables were = 1
(selected):

``` r

df_q3_long <- df_q3_long %>%
  filter(value == 1)
df_q3_long
#> # A tibble: 15 × 2
#>    var   value       
#>    <chr> <int+lbl>   
#>  1 q3_4  1 [selected]
#>  2 q3_1  1 [selected]
#>  3 q3_2  1 [selected]
#>  4 q3_3  1 [selected]
#>  5 q3_1  1 [selected]
#>  6 q3_2  1 [selected]
#>  7 q3_4  1 [selected]
#>  8 q3_2  1 [selected]
#>  9 q3_4  1 [selected]
#> 10 q3_1  1 [selected]
#> 11 q3_1  1 [selected]
#> 12 q3_3  1 [selected]
#> 13 q3_4  1 [selected]
#> 14 q3_3  1 [selected]
#> 15 q3_2  1 [selected]
```

Now we can do the counting as above:

``` r

df_q3_counts <- df_q3_long %>% count(var)
df_q3_counts
#> # A tibble: 4 × 2
#>   var       n
#>   <chr> <int>
#> 1 q3_1      4
#> 2 q3_2      4
#> 3 q3_3      3
#> 4 q3_4      4
```

However, we want to show the variable labels in this frequency table. We
can obtain the variable labels from the dataset:

``` r

varlabs <- df_q3 %>% gen_var_table()
varlabs
#> # A tibble: 4 × 7
#>   var   type    varlab                            new_label new_name op    hash 
#>   <chr> <chr>   <chr>                             <chr>     <chr>    <chr> <chr>
#> 1 q3_1  integer Select all that applies - I'm cu… ""        ""       ""    4bda…
#> 2 q3_2  integer Select all that applies - I'm ca… ""        ""       ""    a61e…
#> 3 q3_3  integer Select all that applies - I'm la… ""        ""       ""    11d1…
#> 4 q3_4  integer Select all that applies - I don'… ""        ""       ""    c16a…
```

We just want to get rid of the questionnaire text and remove everything
(`".*"`) before the hyphen surrounded by spaces (`" - "`) in these
strings:

``` r

varlabs <- varlabs %>% mutate(varlab = str_remove(varlab, ".* - "))
varlabs
#> # A tibble: 4 × 7
#>   var   type    varlab       new_label new_name op    hash                      
#>   <chr> <chr>   <chr>        <chr>     <chr>    <chr> <chr>                     
#> 1 q3_1  integer I'm curious  ""        ""       ""    4bda9e2413b87e8fa25b98cb5…
#> 2 q3_2  integer I'm cautios  ""        ""       ""    a61eea89a075cbb9d7e01bd07…
#> 3 q3_3  integer I'm lazy     ""        ""       ""    11d13260b0118e9ac635b8120…
#> 4 q3_4  integer I don't care ""        ""       ""    c16a28608df904484625e2b0f…
```

Now, we can add this information to our frequency table:

``` r

full_join(
  varlabs,
  df_q3_counts
)
#> Joining with `by = join_by(var)`
#> # A tibble: 4 × 8
#>   var   type    varlab       new_label new_name op    hash                     n
#>   <chr> <chr>   <chr>        <chr>     <chr>    <chr> <chr>                <int>
#> 1 q3_1  integer I'm curious  ""        ""       ""    4bda9e2413b87e8fa25…     4
#> 2 q3_2  integer I'm cautios  ""        ""       ""    a61eea89a075cbb9d7e…     4
#> 3 q3_3  integer I'm lazy     ""        ""       ""    11d13260b0118e9ac63…     3
#> 4 q3_4  integer I don't care ""        ""       ""    c16a28608df90448462…     4
```

Alternatively, we can directly modify the variable labels with
datadaptor, using the `#VARL` command on one of the `Free` sheets:

| A      | B    | C            |
|--------|------|--------------|
| \#VARL | q3_1 | I'm curious  |
| \#VARL | q3_2 | I'm cautious |
| \#VARL | q3_3 | I'm lazy     |
| \#VARL | q3_4 | I don't care |

### Multiple answers on the same scale

*This kind of tabulation is done with the type* **`mw`** *in the type
column of the “Questions” sheet in the Excel mapping file.*

The variables in [Q4](#Q4) are also categorical variables and it’s of
interest to plot them each on their own, e.g., the first one:

``` r

df %>% count(q4_1)
#> # A tibble: 5 × 2
#>   q4_1                               n
#>   <int+lbl>                      <int>
#> 1 1 [1 = I like it]                  3
#> 2 2 [2]                              2
#> 3 3 [3]                              2
#> 4 4 [4]                              2
#> 5 5 [5 = I don`t like it at all]     1
```

As all the answers to [Q4](#Q4) share the same scale, it’s also useful
to tabulate statistics (such as the mean) in a single table:

``` r

df_q4 <- df %>%
  select(q4_1:q4_3)
df_q4_means <- df_q4 %>%
  pivot_longer(everything(), names_to = "var") %>%
  group_by(var) %>%
  summarise(mean = mean(value))
df_q4_means
#> # A tibble: 3 × 2
#>   var    mean
#>   <chr> <dbl>
#> 1 q4_1    2.6
#> 2 q4_2    2.7
#> 3 q4_3    3.4
```

We’ll also add the modified variable labels to the our summary of means
table, as we already did for the multiple choice question [Q3](#Q3)

``` r

varlabs <- df_q4 %>% gen_var_table()
varlabs <- varlabs %>% mutate(varlab = str_remove(varlab, ".* - "))
varlabs
#> # A tibble: 3 × 7
#>   var   type    varlab      new_label new_name op    hash                       
#>   <chr> <chr>   <chr>       <chr>     <chr>    <chr> <chr>                      
#> 1 q4_1  integer Sports      ""        ""       ""    c5ff64f751472d0d0eb785ca08…
#> 2 q4_2  integer Watching TV ""        ""       ""    8541aa138b46056f21f7b72db5…
#> 3 q4_3  integer Reading     ""        ""       ""    0b9b96e292267af6b7e045a120…
```

``` r

full_join(
  varlabs,
  df_q4_means
)
#> Joining with `by = join_by(var)`
#> # A tibble: 3 × 8
#>   var   type    varlab      new_label new_name op    hash                   mean
#>   <chr> <chr>   <chr>       <chr>     <chr>    <chr> <chr>                 <dbl>
#> 1 q4_1  integer Sports      ""        ""       ""    c5ff64f751472d0d0eb7…   2.6
#> 2 q4_2  integer Watching TV ""        ""       ""    8541aa138b46056f21f7…   2.7
#> 3 q4_3  integer Reading     ""        ""       ""    0b9b96e292267af6b7e0…   3.4
```
