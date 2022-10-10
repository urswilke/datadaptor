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
    map(table) %>%
    map(as.data.frame)
  res1 <- bind_rows(count1, .id="var")
  colnames(res1)[colnames(res1)=="Var1"] <- "nv"

  var1 <- gen_var_table(df) %>%
    select(c("var","type", "varlab"))

  label1 <- tablab::tab_vallabs(df) %>%
    select(c("var","nv", "vallab"))


  merge(res1,label1,by=c("var", "nv"), all=TRUE)

}
