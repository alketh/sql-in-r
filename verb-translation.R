# select() and mutate() modify the SELECT clause.
# filter() generates a WHERE clause.
# arrange() generates an ORDER BY clause.
# summarise() and group_by() work together to generate a GROUP BY clause.
# inner_join() 	SELECT * FROM x JOIN y ON x.a = y.a
# left_join() 	SELECT * FROM x LEFT JOIN y ON x.a = y.a
# right_join() 	SELECT * FROM x RIGHT JOIN y ON x.a = y.a
# full_join() 	SELECT * FROM x FULL JOIN y ON x.a = y.a
# semi_join() 	SELECT * FROM x WHERE EXISTS (SELECT 1 FROM y WHERE x.a = y.a)
# anti_join() 	SELECT * FROM x WHERE NOT EXISTS (SELECT 1 FROM y WHERE x.a = y.a)
# intersect(x, y) 	SELECT * FROM x INTERSECT SELECT * FROM y
# union(x, y) 	SELECT * FROM x UNION SELECT * FROM y
# setdiff(x, y) 	SELECT * FROM x EXCEPT SELECT * FROM y

# Note: x and y don’t have to be tables in the same database. If you specify copy = TRUE

# Translation into actual SQL code works in three steps:

# sql_build() recurses over the lazy op data structure building up query objects
# that represent the different subtypes of SELECT queries that we might generate.

# sql_optimise() takes a pass over these SQL objects, looking for potential optimisations.

# sql_render() calls an SQL generation function to produce the actual SQL.

