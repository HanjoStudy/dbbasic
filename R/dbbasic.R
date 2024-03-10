#' dbbasic.R
#' @import logger
#' @import DBI
#' @importFrom RMySQL MySQL
#' @importFrom digest digest
#' @importFrom RPostgreSQL PostgreSQL
#' @importFrom glue glue
#' @importFrom tibble as_tibble
#'

PKG_VERSION <- utils::packageDescription('dbbasic')$Version
