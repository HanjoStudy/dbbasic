Hanjo Odendaal
2024-03-10

# dbbasic <img src="man/figures/logo.png" align="right" alt="" width="120" />

[<img src="https://img.shields.io/badge/lifecycle-stable-green.svg"
class="quarto-discovered-preview-image" />](https://www.tidyverse.org/lifecycle/#experimental)
[![](https://img.shields.io/github/last-commit/Stellenbosch-Econometrics/sarbR.svg)](https://github.com/HanjoStudy/dbbasic/commits/master)

Package for interacting with `MySQL` and `Greenplum`/`PostgreSQL`
database

## Install

``` r
remotes::install_github("HanjoStudy/dbbasic")
```

## Prerequisites

Your .Renviron should be setup with the following fields: `gp_user`,
`gp_passwd`, `mysql_user`, and `mysql_passwd`. The `gp_*` environment
variables contain your PostgreSQL credentials, the `mysql_*` environment
variables contain your MySQL credentials.

Example of an `.Renviron` file:

``` bash
gp_user=user
gp_pass=mypass
gp_port=5432
gp_host=localhost

mysql_user=user
mysql_passwd=mypass
mysql_port=3306
mysql_host=localhost
```

## Logging

`dbbasic` uses the `logger` package to capture process steps. To see
these steps:

``` r
library(logger)
log_threshold(DEBUG)
```

## Connect to a database

The `db_connect()` function enables connection with either a `MySQL` or
`PostgreSQL` database. This function takes as an input a concatenation
between the database server (MySQL or Greenplum/PSQL) and the database
with that server.

Example usage - connect to the warehouse database on the PostgreSQL
server.

``` r
library(dbbasic)
db_connect(db = "psql_datascience")
db_connect(db = "greenplum_warehouse")
db_connect(db = "mysql_warehouse")
```

## Query a database

The `db_query()` function takes as inputs a database query and a
database name. It connects to the database using `db_connect()`, returns
the results of the query, and disconnects from the database on exiting.

Example usage - count the number of rows in the XXX table in the
warehouse database on the PostgreSQL server -

``` r
db_query(query = "SELECT COUNT(*) FROM XXX", db = "psql_warehouse")
```

## Write to a database

The `db_write()` function allows for data to be written to a table in a
database. It takes the following inputs -

- `df`: a data frame to be written
- `table_name`: the table to write to
- `db`: the database to write to
- `type`: whether to append or overwrite

Example usage - write `mtcars` to PostgreSQL

``` r
# create testing db
db_query("CREATE DATABASE testing;", db = "psql_datascience")

# create table
db_query("DROP TABLE IF EXISTS mtcars", db = "psql_testing")
db_query("CREATE TABLE mtcars(
                        mpg FLOAT,
                        cyl FLOAT,
                        disp FLOAT,
                        hp FLOAT,
                        drat FLOAT,
                        qsec FLOAT,
                        wt FLOAT,
                        vs FLOAT,
                        am FLOAT,
                        gear FLOAT,
                        carb FLOAT
                        );", db = "psql_testing")


# write to table and overwrite
db_write(df = mtcars, table_name = "mtcars", db = "psql_testing", type = "overwrite")
# count records
db_query("SELECT COUNT(*) FROM mtcars", db = "psql_testing")

# write to table and append
db_write(df = mtcars, table_name = "mtcars", "psql_testing")

# count records
db_query("SELECT COUNT(*) FROM mtcars", db = "psql_testing")

# drop table
db_query("DROP TABLE IF EXISTS mtcars", db = "psql_testing")

# drop database - only for `superuser`, make sure to NOT connect to it before dropping
db_query("DROP DATABASE testing", db= "psql_datascience")
```

## Utilities

### db_collapse

If you need to collapse a string to use in an `IN` statement

``` r
db_collapse(c(month.name))
```

### hashing

Sometimes you want to create a unique hash of a string or object:

``` r
hash("hallo")
sapply(month.name[1:3], hash)
```

### tibble_to_sql

Quick method to get a SQL template:

``` r
tibble_to_sql(mtcars, table_name = "mtcars")
```
