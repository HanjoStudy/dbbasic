#' db_collapse
#' @export
db_collapse <- function(txt){
  paste0(paste0("'", txt, "'"), collapse = ',')
}

#' @noRd
#' @export
hash <- function(x, len = 32){
  if(is.null(x) | is.na(x))
    return(x)

  substr(digest(as.character(x), serialize = FALSE, ascii = T, algo = "sha256"), 1, len)
}

#' Push tibble to sql schema
#'
#' @return character
#'
#' @export
tibble_to_sql <- function(df, table_name  = "XXX", type = "psql"){
  # Get the column names and types
  cols <- colnames(df)
  types <- sapply(df, function(x) class(x)[1])

  # Define the mapping from R types to SQL types
  if(type == "psql"){
    type_mapping <- list(
      Date = "DATE",
      numeric = "FLOAT",
      integer = "INTEGER",
      logical = "BOOLEAN",
      character = "VARCHAR(255)",
      POSIXct = "TIMESTAMP WITHOUT TIME ZONE",
      POSIXlt = "TIMESTAMP WITHOUT TIME ZONE"
    )
  }

  if(type == "psql"){
    type_mapping <- list(
      Date = "DATE",
      numeric = "DOUBLE",
      integer = "INTEGER",
      logical = "BOOLEAN",
      character = "VARCHAR(255)",
      POSIXct = "DATETIME",
      POSIXlt = "DATETIME"
    )
  }

  # Get the SQL types for the tibble columns
  sql_types <- sapply(types, function(x) {
    if (x %in% names(type_mapping)) {
      return(type_mapping[[x]])
    } else {
      stop(glue("Unsupported column type: {x}"))
    }
  })

  # Generate the SQL statement
  cols_and_types <- paste(paste(cols, sql_types), collapse = ",\n ")
  sql_str <- glue("CREATE TABLE {table_name} ({cols_and_types});")

  cat(sql_str)
}
