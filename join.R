library(dplyr)

con <- DBI::dbConnect(RSQLite::SQLite(), dbname = ":memory:")

# let's copy some data to the databse
copy_to(con, nycflights13::flights, "flights", temporary = FALSE)
copy_to(con, nycflights13::planes, "planes", temporary = FALSE)

con1 <- tbl(con, "flights")
con2 <- tbl(con, "planes")

tbl <- left_join(con1, con2, by = "tailnum")

show_query(tbl)

# 3 tbl join query!
all(unique(nycflights13::flights$origin) %in% unique(nycflights13::airports$faa))

copy_to(con, nycflights13::airports, "airports", temporary = FALSE)

con3 <- tbl(con, "airports")

chk <- left_join(con1, con2, by = "tailnum") %>%
  left_join(con3, by = c("origin" = "faa")) %>%
  group_by(origin) %>%
  summarise(count = n())

collect(chk)


