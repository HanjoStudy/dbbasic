#' db_connect
#' @description creates low level database connection
#' @param db name of the database to connect to MySQL ('mysql_<db_name>'), Greenplum/postgres ('greenplum_<db_name>')
#' @examples
#' \dontrun{
#' conn <- db_connect("mysql_mysql")
#' dbGetQuery(conn, "SELECT * FROM table_x limit 10")
#'}
#' @return connection
#' @export
#'
db_connect <- function(db = c("mysql_mysql", "greenplum_warehouse", "psql_warehouse")[3]){

  log_debug(glue("Connecting to {db}"))

  if(grepl("mysql", db)){
    db <- gsub("mysql_","", db)

    out <- dbConnect(
      MySQL(),
      host = Sys.getenv("mysql_host"),
      port = as.numeric(Sys.getenv("mysql_port")),
      user = Sys.getenv("mysql_user"),
      password = Sys.getenv("mysql_passwd"),
      dbname = db,
      timeout = 10
    )
  }

  if(grepl("greenplum", db) | grepl("psql", db)){
    db <- gsub("greenplum_|psql_","", db)
    # Create the database connection
    out <- dbConnect(
      Postgres(),
      user = Sys.getenv("gp_user"),
      password = Sys.getenv("gp_pass"),
      host = Sys.getenv("gp_host"),
      port = as.numeric(Sys.getenv("gp_port")),
      dbname = db
    )
  }

  log_debug(glue("Successful connection to {db}"))

  return(out)
}
