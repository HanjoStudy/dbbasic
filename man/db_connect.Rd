% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/db_connect.R
\name{db_connect}
\alias{db_connect}
\title{db_connect}
\usage{
db_connect(
  db = c("mysql_mysql", "greenplum_warehouse", "psql_warehouse",
    "clickhouse_warehouse")[3]
)
}
\arguments{
\item{db}{name of the database to connect to MySQL ('mysql_<db_name>'), Greenplum/postgres ('greenplum_<db_name>')}
}
\value{
connection
}
\description{
creates low level database connection
}
\examples{
\dontrun{
conn <- db_connect("mysql_mysql")
dbGetQuery(conn, "SELECT * FROM table_x limit 10")
}
}
