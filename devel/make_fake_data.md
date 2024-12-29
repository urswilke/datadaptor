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
## # A tibble: 5 × 3
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
  sample(x = 1:10, size = n, replace = TRUE) %>% as.character(), 
  label = "A numeric variable in string format."
)
q9 <- rep(NA_real_, times = n)

fake_survey <- fake_survey %>% mutate(id = row_number(), q6, q7, q8, q9)
fake_survey
```

```
## # A tibble: 100 × 10
##           q1        q2       q3       q4       q5    id q6    q7     q8       q9
##    <dbl+lbl> <dbl+lbl> <dbl+lb> <dbl+lb> <dbl+lb> <int> <chr> <chr+> <chr> <dbl>
##  1  3 [norm…  2 [no]   3 [norm… 4 [much]  2 [a b…     1 bla … bla b… 2        NA
##  2  3 [norm…  1 [yes]  5 [very… 4 [much]  5 [ver…     2 bla … bla b… 9        NA
##  3  1 [not …  1 [yes]  3 [norm… 2 [a bi…  5 [ver…     3 bla … bla b… 3        NA
##  4  3 [norm… 99 [no a… 4 [much] 4 [much]  4 [muc…     4 bla … bla b… 3        NA
##  5  5 [very… NA        2 [a bi… 3 [norm…  3 [nor…     5 bla … bla f… 9        NA
##  6  5 [very… NA        4 [much] 3 [norm…  2 [a b…     6 bla … bla p… 7        NA
##  7 99 [no a…  2 [no]   3 [norm… 4 [much] NA           7 bla … bla b… 10       NA
##  8  2 [a bi…  2 [no]   5 [very… 2 [a bi…  1 [not…     8 bla … bla b… 1        NA
##  9 99 [no a… 99 [no a… 1 [not … 1 [not …  2 [a b…     9 bla … bla b… 2        NA
## 10 99 [no a…  1 [yes]  1 [not … 1 [not …  4 [muc…    10 bla … bla b… 4        NA
## # … with 90 more rows
```


* use as internal dataset and spss file


```r
haven::write_sav(fake_survey, "../inst/extdata/fake_survey.sav")

usethis::use_data(fake_survey, overwrite = TRUE)
```

```
## ✓ Setting active project to '/home/chief/R/datadaptor'
```

```
## ✓ Saving 'fake_survey' to 'data/fake_survey.rda'
```

```
## • Document your data (see 'https://r-pkgs.org/data.html')
```

