#' Write dataset properties to database (needs Dataset-database, see `inst/SQL/Dataset-CreateTables.sql`)
#'
#' @param dat data dataframe
#' @param filepath Path to the data file
#' @param database_dsn dsn to database
#' @param version mapping version number
#' @param project_name project name
#' @param origin vector of datano field of original datasets
#' @param save_origin datanos of original datasets are saved to dsorigin
#' @return vector of origin datanos
#' @noRd
#'
#' @examples
#' spss_file <- system.file(
#'   "extdata",
#'   "mtcars_labelled.sav",
#'   package = "datenanpassr"
#' )
#' mapping_file <- system.file(
#'   "extdata",
#'   "mapping.xlsx",
#'   package = "datenanpassr"
#' )
#' mapping <- Mapping$new(spss_file, mapping_file, database_dsn = "TabBooksPG")
dataset_to_database <- function(
    dat,
    filepath,
    database_dsn,
    version = "",
    project_name = "",
    origin = NULL,
    save_origin = FALSE
) {
  filedate <- file.mtime(filepath)
  attr(filedate, "tzone") <- "UTC"

  hash <- digest(dat)

  conn <- dbConnect(odbc(), dsn = database_dsn)

  sql <- sqlInterpolate(
    conn,
    'SELECT datano FROM dsdataset WHERE filepath = ?filepath AND filedate = ?filedate;',
    filepath = filepath,
    filedate = format(filedate)
  )
  datano <- dbGetQuery(conn, sql)

  if (is.na(datano[1,1])) {
    sql <- sqlInterpolate(
      conn,
      'INSERT INTO dsdataset (version, projectname, filepath, filedate, hash)
          VALUES (?version,?projectname, ?filepath, ?filedate, ?hash);
        ',
      version = version,
      projectname = project_name,
      filepath = filepath,
      filedate = format(filedate),
      hash = hash
    )
    dbExecute(conn, sql)
    datano <- dbGetQuery(conn, "SELECT LASTVAL();")
    vartable <- gen_var_table(dat) |>
      mutate(datano = datano[1,1]) |>
      select(c(datano, var, type, varlab, hash))

    dbWriteTable(conn, "dsvariable", vartable, append = TRUE)
  }

  # if save_origin is set, then add origins of dataset to dsoriginal table,
  # otherwise append dataset origin to result
  if (!save_origin) {
    origin <- rbind(origin, datano)
    colnames(origin) <- c("origin")
  } else {
    dbWriteTable(
      conn,
      "dsorigin",
      origin |>
        as.data.frame() |>
        mutate(datano = datano[1,1]) |>
        select(datano, origin),
      append = TRUE
    )
  }
  dbDisconnect(conn)
  origin
}


