#' Fake survey data
#'
#' A dataset containing made-up answers to a survey.
#' The data is stored in variables of the type haven::labelled.
#' The same data is also included in the package in SPSS format.
#' See in the examples section how to load the SPSS version to R.
#'
#'
#' @format A data frame of 100 respondents to the following questions (variables):
#' \describe{
#'   \item{id}{respondent id}
#'   \item{q1}{How much do you like the product?}
#'   \item{q2}{Do you want to recommend the product?}
#'   \item{q3}{How likely will you go dancing this weekend?}
#'   \item{q4}{How much do you like your friends?}
#'   \item{q5}{How much do you like your best friend}
#'   \item{q6}{Tell me something positive.}
#'   \item{q7}{Tell me something negative.}
#'   \item{q8}{A numeric variable in string format.}
#'   \item{q9}{An empty variable.}
#' }
#' @examples
#' datenanpassr::fake_survey
#' path <- system.file("extdata", "fake_survey.sav", package = "datenanpassr")
#' df <- haven::read_sav(path)
#' df
"fake_survey"

#' `command_block` overview
#'
#' A dataset containing the list of `keyword`s that can be used in the Excel
#' mapping file to generate command_block objects.
#'
#'
#' @format A data frame of 24 `keyword`s and their corresponding command_block
#' classes:
#' \describe{
#'   \item{keyword}{Excel mapping file keyword}
#'   \item{command_block}{String denoting the name of the command_block subclass}
#'   \item{sheet}{The sheet(s) in the Excel mapping file from where this command can be called}
#' }
#' @examples
#' command_block_classes
"command_block_classes"
