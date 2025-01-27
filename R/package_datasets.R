#' Labelled mtcars version
#'
#' A labelled version of the `mtcars` dataset (see `?mtcars`).
#' The data is stored in variables of the type haven::labelled.
#' The same data is also included in the package in SPSS format.
#' See in the examples section how to load the SPSS version to R.
#'
#'
#' @format A data frame with 32 observations on 13 variables:
#' \describe{
#'   \item{id}{car id}
#'   \item{model}{
#'     Name of the car - this information is stored in rownames in `mtcars`.
#'   }
#'   \item{mpg}{see `?mtcars`}
#'   \item{cyl}{see `?mtcars`}
#'   \item{disp}{see `?mtcars`}
#'   \item{hp}{see `?mtcars`}
#'   \item{drat}{see `?mtcars`}
#'   \item{wt}{see `?mtcars`}
#'   \item{qsec}{see `?mtcars`}
#'   \item{vs}{see `?mtcars`}
#'   \item{am}{see `?mtcars`}
#'   \item{gear}{see `?mtcars`}
#'   \item{carb}{see `?mtcars`}
#' }
#' @examples
#' datadaptor::mtcars_labelled
#' path <- system.file("extdata", "mtcars_labelled.sav", package = "datadaptor")
#' df <- haven::read_sav(path)
#' df
"mtcars_labelled"

#' Toy data of a fictional survey about fruits
#'
#' This dataset contains the made-up answers of a fictional survey about fruits.
#' The same data is also included in the package in SPSS format.
#' See in the examples section how to load the SPSS version to R.
#'
#'
#' @format A data frame with 100 observations on 12 variables:
#' \describe{
#'   \item{id}{respondent id}
#'   \item{q1}{answers to Q1}
#'   \item{q2_1}{answers to Q2 - 1st item}
#'   \item{q2_2}{answers to Q2 - 2nd item}
#'   \item{q2_3}{answers to Q2 - 3rd item}
#'   \item{q2_97}{answers to Q2 - 4th item}
#'   \item{q3_1}{answers to Q3 - 1st item}
#'   \item{q3_2}{answers to Q3 - 2nd item}
#'   \item{q3_3}{answers to Q3 - 3rd item}
#'   \item{q3_97}{answers to Q3 - 4th item}
#'   \item{q4}{answers to Q4}
#'   \item{q5}{answers to Q5}
#' }
#' @examples
#' datadaptor::fruit_survey
#' path <- system.file("extdata", "fruit_survey.sav", package = "datadaptor")
#' df <- haven::read_sav(path)
#' df
#' labelled::generate_dictionary(fruit_survey)
"fruit_survey"

#' `command_block` overview
#'
#' A dataset containing the list of `keyword`s that can be used in the Excel
#' mapping file to generate command_block objects.
#'
#'
#' @format A data frame of 26 `keyword`s and their corresponding command_block
#' classes:
#' \describe{
#'   \item{keyword}{
#'     Excel mapping file keyword
#'   }
#'   \item{command_block}{
#'     String denoting the name of the command_block subclass
#'   }
#'   \item{sheet}{
#'     The sheet(s) in the Excel mapping file from where this command can be called
#'   }
#' }
#' @examples
#' # print all rows of tibble:
#' print(command_block_classes, n = 111)
"command_block_classes"
