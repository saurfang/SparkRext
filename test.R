library(SparkRext)
sc <- sparkR.init(master="local")
sqlContext <- sparkRSQL.init(sc)

library(nycflights13)

prior_package(dplyr)

set.seed(123)
data <- sample_n(flights, 10000)

df <- createDataFrame(sqlContext, data.frame(data))

filter(data, month == 12, day == 31)
filter(data, month == 1 | day == 31)
select(data, year, month, day)
select(data, year:day)
select(data, year:day, -month)
select(data, -arr_time, year) # different
select(data, -arr_time, arr_time) # different
select(data, -(year:day), month) # different
select(data, 1:3)


prior_package(SparkR)

filter(df, df$month == 12) %>% filter(df$day == 31) %>% head
filter(df, df$month == 1 | df$day == 31) %>% head
select(df, "year", "month", "day") %>% head

columns(df)

prior_package(SparkRext)

filter(df, month == 12, day == 31) %>% head
filter(df, month == 1 | day == 31) %>% head
select(df, year, month, day) %>% head
select(df, year:day) %>% head
select(df, -(year:day)) %>% head
select(df, year:day, -month) %>% head
select(df, -(year:day), month) %>% head
select(df, 1, 2, 3) %>% head
select(df, 1:3) %>% head

mutate(df, hoge = sqrt(year)) %>% head
mutate(df, year = sqrt(year)) %>% head

sparkR.stop()

