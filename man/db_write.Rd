% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/db_write.R
\name{db_write}
\alias{db_write}
\title{Write data to a table in a database}
\usage{
db_write(df, table_name, db, type = "append")
}
\arguments{
\item{df}{a data.frame or tibble to write}

\item{table_name}{a table to write to}

\item{db}{a database to write to}

\item{type}{whether to append or overwrite the table}
}
\value{
logical
}
\description{
creates a connection to the DB writes data.frame to table
}
