#' Write dataset properties to database (needs Dataset-database, see `inst/SQL/Dataset-CreateTables.sql`)
#'
#' @param dat data dataframe
#' @param filepath Path to the data file
#' @param database_dsn dsn to database
#' @param version mapping version number
#' @param project_name project name
#' @param cmd_tbl if not `NULL`, `cmd_tbl` is saved to dscmdlog
#' @param data_origin if not `NULL`, the datanos of the original data files are saved to dsorigin
#' @return datano of dataset
#' @noRd
#'
#' @examples
#' spss_file <- system.file(
#'   "extdata",
#'   "mtcars_labelled.sav",
#'   package = "datadaptor"
#' )
#' mapping_file <- system.file(
#'   "extdata",
#'   "mapping.xlsx",
#'   package = "datadaptor"
#' )
#' mapping <- Mapping$new(spss_file, mapping_file, database_dsn = "TabBooksPG")
dataset_to_database <- function(
    dat,
    filepath,
    database_dsn,
    version = "",
    project_name = "",
    cmd_tbl = NULL,
    data_origin = NULL
) {
  # check if dataset already in database
  filedate <- strftime(file.mtime(filepath), format = "%Y-%m-%d %H:%M:%S")

  conn <- dbConnect(odbc(), dsn = database_dsn)

  sql <- sqlInterpolate(
    conn,
    "SELECT datano FROM dsdataset
       WHERE filepath = ?filepath AND filedate = ?filedate;",
    filepath = filepath,
    filedate = format(filedate)
  )
  datano <- dbGetQuery(conn, sql)$datano

  #if dataset not in database, ...
  if (length(datano) == 0) {
    # ... add dataset information to dsdataset
    hash <- digest(dat)
    sql <- sqlInterpolate(
      conn,
      "INSERT INTO dsdataset (version, projectname, filepath, filedate, hash)
         VALUES (?version, ?projectname, ?filepath, ?filedate, ?hash);",
      version = version,
      projectname = project_name,
      filepath = filepath,
      filedate = format(filedate),
      hash = hash
    )
    dbExecute(conn, sql)
    datano <- dbGetQuery(conn, "SELECT LASTVAL();")$lastval

    # ... add variable information to dsvariable
    vartable <- gen_var_table(dat) |>
      mutate(datano) |>
      select(c(datano, var, type, varlab, hash))

    dbWriteTable(conn, "dsvariable", vartable, append = TRUE)

    # ... add value label information to dslabel
    valtable <- gen_label_table(dat) |>
      mutate(datano) |>
      select(c(datano, var, nv, vallab))

    dbWriteTable(conn, "dslabel", valtable, append = TRUE)

    # if cmd_tbl is passed, add cmd_tbl to dscmdtbl
    if (!is.null(cmd_tbl)) {
      log <- cmd_tbl |>
        mutate(datano) |>
        mutate(raw = sapply(raw, paste0, collapse = '; ')) |>
        select(c(datano, sheet, action, row, new_var, raw, error ))

      dbWriteTable(
        conn,
        "dscmdlog",
        log,
        append = TRUE
      )
    }

    # if dataset originas are passed, add them to dsorigin
    if (!is.null(data_origin)) {
      df_origin <- data.frame(origin= data_origin) |>
        mutate(datano) |>
        select(c(datano, origin))

      dbWriteTable(
        conn,
        "dsorigin",
        df_origin,
        append = TRUE
      )
    }
  }
  dbDisconnect(conn)
  datano
}
