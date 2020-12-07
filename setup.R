library(DBI)

# create sqlite
con <- DBI::dbConnect(RSQLite::SQLite(), "fav-pkg.sqlite")

# Create the table with one row
dbWriteTable(con,
             "results",
             tibble::tibble(
               name = "Josiah",
               r_affinity = 5,
               fav_pkg = "genius"
             ))

# create list to fill in insert statement
res <- list(
  name = "josiah",
  r_affinity = 1,
  fav_pkg = "plyr")



insert_statement <- RSQLite::dbSendStatement(con,
  "INSERT INTO results (name, r_affinity, fav_pkg)
  VALUES(:name, :r_affinity, :fav_pkg);",
  params = res
  )


# get queries
dbDisconnect(con)


# create rds for all packages

pkgs <- tools::CRAN_package_db()$Package
readr::write_rds(pkgs, "pkgs.rds")
