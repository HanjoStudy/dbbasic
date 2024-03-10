#' Write data to a table in a database
#'
#' @param df a data.frame or tibble to write
#' @param table_name a table to write to
#' @param db a database to write to
#' @param type whether to append or overwrite the table
#'
#' @description creates a connection to the DB writes data.frame to table
#'
#' @import logger
#' @importFrom glue glue
#' @returns logical
#' @export

db_write <- function(df, table_name, db, type = "append"){

  conn <- db_connect(db)

  on.exit(dbDisconnect(conn))

  if(type == "overwrite"){
    log_warn(glue("Truncating table {table_name}"))
    db_query(glue("
             TRUNCATE {table_name}
             "),
             db = db)
  }

  log_debug(glue("Writing to {db} table: {table_name}"))

  res <- dbWriteTable(conn,  table_name,
                      df,
                      append = TRUE,
                      row.names = FALSE)

  return(res)
}
