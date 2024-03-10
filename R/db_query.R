#' db_query
#' @description creates a connection to the DB and runs SQL query
#'
#' @param db the database to connect to
#' @param query SQL query to run
#' @param tbl logical whether to return a tibble (T) or a data frame (F)
#'
#' @return data.frame
#' @export
#'
db_query <- function(query, db){
  conn <- db_connect(db)

  on.exit(dbDisconnect(conn))

  log_debug(glue("Query: {query}"))
  df <- dbGetQuery(conn, query) %>% as_tibble()

  return(df)
}
