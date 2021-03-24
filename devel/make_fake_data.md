---
title: "Generate fake survey data"
author: "Urs Wilke"
date: "12/1/2020"
output: 
  html_document:
    keep_md: true
---




```r
library(dplyr)
library(tibble)
library(purrr)
```

* prepare fake survey data


```r
set.seed(42)
n <- 100


reply_1_5 <- c("not at all" = 1, "a bit" = 2, "normal" = 3, "much" = 4, "very much" = 5, "no answer" = 99)
reply_yn <- c("yes" = 1, "no" = 2, "no answer" = 99)

question_texts <- c(
  "q1" = "How much do you like the product?",
  "q2" = "Do you want to recommend the product?",
  "q3" = "How likely will you go dancing this weekend?",
  "q4" = "How much do you like your friends?",
  "q5" = "How much do you like your best friend?"
)
types <- list(
  reply_1_5,
  reply_yn,
  reply_1_5,
  reply_1_5,
  reply_1_5
)


fake_labelled <- function(n = 100, labels_vec = NULL, label_str = NULL) {
  haven::labelled(
    sample(c(
      unname(labels_vec), NA), 
      size = n, 
      replace = TRUE,
      prob = c(rep(1, length(labels_vec)), 0.2)
    ), 
    labels = labels_vec, 
    label = label_str)
}
# fake_labelled()
enframe(question_texts, "var", "varlab") %>% mutate(types)
```

```
## # A tibble: 5 x 3
##   var   varlab                                       types    
##   <chr> <chr>                                        <list>   
## 1 q1    How much do you like the product?            <dbl [6]>
## 2 q2    Do you want to recommend the product?        <dbl [3]>
## 3 q3    How likely will you go dancing this weekend? <dbl [6]>
## 4 q4    How much do you like your friends?           <dbl [6]>
## 5 q5    How much do you like your best friend?       <dbl [6]>
```

* generate fake survey dataframe


```r
fake_survey <- map2_dfc(
  question_texts,
  types,
  ~fake_labelled(n, .y, label_str = .x)
  ) %>% 
  set_names(names(question_texts))
```

* add free answer string variables


```r
generate_bla_vector <- function(answer_text) {
  bla_text <- paste(rep("bla", sample(1:3, 1)), collapse = " ")
  paste(bla_text, sample(answer_text, 1), collapse = " ")
}
chr_vec1 <- map_chr(1:n, ~generate_bla_vector(c("love", "happiness", "joy")))
chr_vec2 <- map_chr(1:n, ~generate_bla_vector(c("sadness", "fear", "anger", "pain")))
q6 <- haven::labelled(chr_vec1, label = "Tell me something positive.")
q7 <- haven::labelled(chr_vec2, label = "Tell me something negative.")
q8 <- haven::labelled(
  sample(x = 1:10, size = n, replace = TRUE), 
  label = "A numeric variable in string format."
)


fake_survey <- fake_survey %>% mutate(id = row_number(), q6, q7, q8)
fake_survey
```

```
## # A tibble: 100 x 9
##            q1         q2       q3       q4        q5    id q6      q7         q8
##     <dbl+lbl>  <dbl+lbl> <dbl+lb> <dbl+lb> <dbl+lbl> <int> <chr+l> <chr+l> <int>
##  1  3 [norma…  2 [no]    3 [norm… 4 [much]  2 [a bi…     1 bla bl… bla bl…     2
##  2  3 [norma…  1 [yes]   5 [very… 4 [much]  5 [very…     2 bla bl… bla bl…     9
##  3  1 [not a…  1 [yes]   3 [norm… 2 [a bi…  5 [very…     3 bla joy bla bl…     3
##  4  3 [norma… 99 [no an… 4 [much] 4 [much]  4 [much]     4 bla bl… bla bl…     3
##  5  5 [very … NA         2 [a bi… 3 [norm…  3 [norm…     5 bla ha… bla fe…     9
##  6  5 [very … NA         4 [much] 3 [norm…  2 [a bi…     6 bla bl… bla pa…     7
##  7 99 [no an…  2 [no]    3 [norm… 4 [much] NA            7 bla lo… bla bl…    10
##  8  2 [a bit]  2 [no]    5 [very… 2 [a bi…  1 [not …     8 bla bl… bla bl…     1
##  9 99 [no an… 99 [no an… 1 [not … 1 [not …  2 [a bi…     9 bla bl… bla bl…     2
## 10 99 [no an…  1 [yes]   1 [not … 1 [not …  4 [much]    10 bla bl… bla bl…     4
## # … with 90 more rows
```


* use as internal dataset and spss file


```r
haven::write_sav(fake_survey, "../inst/extdata/fake_survey.sav")

usethis::use_data(fake_survey, overwrite = TRUE)
```

```
## ✓ Setting active project to '/home/chief/R/datenanpassr'
```

```
## ✓ Saving 'fake_survey' to 'data/fake_survey.rda'
```

```
## ● Document your data (see 'https://r-pkgs.org/data.html')
```

