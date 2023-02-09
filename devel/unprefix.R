library(stringr)
library(purrr)
# !!! ATTENTION: function will modify your scripts !!!
# adapted from prefixer::unprefix() in https://github.com/dreamRs/prefixer
unprefix <- function(r_script) {
  script <- readLines(r_script)
  # don't remove prefixes in comments!:
  is_comment <- str_detect(script, "^#")
  script[!is_comment] <- script[!is_comment] |>
    str_replace_all(
      replacement = "",
      pattern = "[[:alnum:]\\.]+::(?=[[:alnum:]\\._]+)"
    )
  write(script, r_script)
}
fs::dir_ls("R") |> walk(unprefix)
