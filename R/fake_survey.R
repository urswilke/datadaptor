#' Fake survey data
#'
#' A dataset containing made-up answers to a survey.
#' The data is stored in variables of the type haven::labelled.
#' The same data is also included in the package in SPSS format.
#' See in the examples section how to load the SPSS version to R.
#'
#'
#' @format A data frame of 100 respondents to 5 questions (variables):
#' \describe{
#'   \item{q1}{How much do you like the product?}
#'   \item{q2}{Do you want to recommend the product?}
#'   \item{q3}{How likely will you go dancing this weekend?}
#'   \item{q4}{How much do you like your friends?}
#'   \item{q5}{How much do you like your best friend}
#' }
#' @examples
#' datenanpassr::fake_survey
#' path <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' haven::read_sav(path)
"fake_survey"
