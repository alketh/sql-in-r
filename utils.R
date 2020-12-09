library(dplyr)

con <- DBI::dbConnect(RSQLite::SQLite(), dbname = ":memory:")

# let's copy some data to the databse
copy_to(con, nycflights13::flights, "flights",
        temporary = FALSE,
        indexes = list(
          c("year", "month", "day"),
          "carrier",
          "tailnum",
          "dest"
        )
)


# We set up indexes that will allow us to quickly process the data by day,
# carrier, plane, and destination.

# Take a reference to the table within the database:

flights_db <- tbl(con, "flights")

# the most common dplyr verbs work with a database and are parsed into
# native SQL.

flights_db %>% select(year:day, dep_delay, arr_delay)

flights_db %>% filter(dep_delay > 240)

flights_db %>%
  group_by(dest) %>%
  summarise(delay = mean(dep_time))

# SQL learning resources:
# https://www.sqlite.org/queryplanner.html
# https://blog.jooq.org/2016/03/17/10-easy-steps-to-a-complete-understanding-of-sql/

tailnum_delay_db <- flights_db %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay), n = n()) %>%
  arrange(desc(delay)) %>%
  filter(n > 100)

tailnum_delay_db

# Let's display the generated SQL-query.
show_query(tailnum_delay_db)
