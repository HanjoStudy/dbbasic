#' Write data to a table in a database
#'
#' @param df a data.frame or tibble to write
#' @param table_name a table to write to
#' @param db a database to write to
#' @param type whether to append or overwrite the table
#'
#' @description creates a connection to the DB writes data.frame to table
#'
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

  if(grepl("greenplum", db) | grepl("psql", db)){
    table_name_og <- table_name
    table_name <- strsplit(table_name, "\\.")[[1]]

    if(length(table_name) == 1){
      table_name <- c("public", table_name)
    }

    table_name <- Id(schema = table_name[1], table = table_name[2])
  }

  log_debug(glue("Writing to {db} table: {table_name_og}"))

  res <- dbWriteTable(conn,  table_name,
                      df,
                      append = TRUE,
                      row.names = FALSE)

  return(res)
}
