library(dplyr)

con <- DBI::dbConnect(RSQLite::SQLite(), dbname = ":memory:")

# let's copy some data to the databse
copy_to(con, nycflights13::flights, "flights", temporary = FALSE)
copy_to(con, nycflights13::planes, "planes", temporary = FALSE)

con1 <- tbl(con, "flights")
con2 <- tbl(con, "planes")

tbl <- left_join(con1, con2, by = "tailnum")

show_query(tbl)


