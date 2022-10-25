#' Generate data counts table
#'
#' @param df dataframe
#'
#' @return Counts and labels data frame
#' @export
#'
#' @examples
#' gen_data_table(fake_survey)
gen_data_table <- function(df) {
  count1 <- df %>%
    purrr::map(table) %>%
    purrr::map(as.data.frame)
  res1 <- dplyr::bind_rows(count1, .id="var")
  colnames(res1)[colnames(res1)=="Var1"] <- "nv"

  var1 <- gen_var_table(df) %>%
    dplyr::select(c("var","type", "varlab"))

  label1 <- tablab::tab_vallabs(df) %>%
    dplyr::select(c("var","nv", "vallab"))

  res1 <- merge(res1, var1, by="var", all=TRUE)
  merge(res1, label1, by=c("var", "nv"), all=TRUE)

}
