#' dbbasic.R
#' @import logger
#' @import DBI
#' @importFrom RMySQL MySQL
#' @importFrom RClickhouse clickhouse
#' @importFrom digest digest
#' @importFrom RPostgres Postgres
#' @importFrom glue glue
#' @importFrom tibble as_tibble
#'

PKG_VERSION <- utils::packageDescription('dbbasic')$Version
