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

show_query(chk)

# SELECT `origin`, COUNT(*) AS `count`
# FROM (SELECT `year.x`, `month`, `day`, `dep_time`, `sched_dep_time`, `dep_delay`, `arr_time`, `sched_arr_time`, `arr_delay`, `carrier`, `flight`, `tailnum`, `origin`, `dest`, `air_time`, `distance`, `hour`, `minute`, `time_hour`, `year.y`, `type`, `manufacturer`, `model`, `engines`, `seats`, `speed`, `engine`, `name`, `lat`, `lon`, `alt`, `tz`, `dst`, `tzone`
#       FROM (SELECT `LHS`.`year` AS `year.x`, `month`, `day`, `dep_time`, `sched_dep_time`, `dep_delay`, `arr_time`, `sched_arr_time`, `arr_delay`, `carrier`, `flight`, `LHS`.`tailnum` AS `tailnum`, `origin`, `dest`, `air_time`, `distance`, `hour`, `minute`, `time_hour`, `RHS`.`year` AS `year.y`, `type`, `manufacturer`, `model`, `engines`, `seats`, `speed`, `engine`
#            FROM `flights` AS `LHS`
#            LEFT JOIN `planes` AS `RHS`
#            ON (`LHS`.`tailnum` = `RHS`.`tailnum`)
#      ) AS `LHS`
#      LEFT JOIN `airports` AS `RHS`
#      ON (`LHS`.`origin` = `RHS`.`faa`)
# )
# GROUP BY `origin`

system.time(collect(chk))

system.time(left_join(nycflights13::flights, nycflights13::planes, by = "tailnum") %>%
              left_join(nycflights13::airports, by = c("origin" = "faa")) %>%
              group_by(origin) %>%
              summarise(count = n()))

