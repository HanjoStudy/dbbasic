#' db_collapse
#' @export
db_collapse <- function(txt){
  paste0(paste0("'", txt, "'"), collapse = ',')
}

#' @noRd
#' @export
hash <- function(x, len = 64){
  if(is.null(x) | is.na(x))
    return(x)

  substr(digest(as.character(x), serialize = FALSE, ascii = T, algo = "sha256"), 1, len)
}

#' Push tibble to sql schema
#'
#' @return character
#'
#' @export
tibble_to_sql <- function(df, table_name = "XXX", type = "psql") {
  library(glue)

  # Get the column names and types
  cols <- colnames(df)
  types <- sapply(df, function(x) class(x)[1])

  # Define the type mapping for each SQL flavour
  type_mapping <- switch(
    type,
    "psql" = list(
      Date = "DATE",
      numeric = "DOUBLE PRECISION",
      integer = "INTEGER",
      logical = "BOOLEAN",
      character = "VARCHAR(255)",
      POSIXct = "TIMESTAMP WITHOUT TIME ZONE",
      POSIXlt = "TIMESTAMP WITHOUT TIME ZONE"
    ),
    "mysql" = list(
      Date = "DATE",
      numeric = "DOUBLE",
      integer = "INT",
      logical = "BOOLEAN",
      character = "VARCHAR(255)",
      POSIXct = "DATETIME",
      POSIXlt = "DATETIME"
    ),
    "clickhouse" = list(
      Date = "Date",
      numeric = "Float64",
      integer = "Int32",
      logical = "UInt8",  # ClickHouse has no BOOLEAN type
      character = "String",
      POSIXct = "DateTime",
      POSIXlt = "DateTime"
    ),
    stop(glue("Unsupported SQL type: {type}"))
  )

  # Get SQL column definitions
  sql_types <- sapply(types, function(x) {
    if (x %in% names(type_mapping)) {
      return(type_mapping[[x]])
    } else {
      stop(glue("Unsupported column type: {x}"))
    }
  })

  cols_and_types <- paste(paste0("`", cols, "` ", sql_types), collapse = ",\n  ")
  sql_str <- glue("CREATE TABLE `{table_name}` (\n  {cols_and_types}\n);")

  cat(sql_str)
}
