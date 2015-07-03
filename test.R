library(SparkRext)
sc <- sparkR.init(master="local")
sqlContext <- sparkRSQL.init(sc)

library(nycflights13)

prior_package(dplyr)

set.seed(123)
data <- sample_n(flights, 10000)

df <- createDataFrame(sqlContext, data.frame(data))

arrange(data, dep_delay) %>% head

prior_package(SparkR)

arrange(df, desc(abs(df$dep_delay))) %>% head
arrange(x = )

prior_package(SparkRext)

arrange(df, month)

sparkR.stop()

