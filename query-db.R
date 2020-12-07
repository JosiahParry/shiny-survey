con <- DBI::dbConnect(RSQLite::SQLite(), "fav-pkg.sqlite")

DBI::dbGetQuery(con, "select * from results")

DBI::dbDisconnect(con)
