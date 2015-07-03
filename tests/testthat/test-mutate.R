# context("mutate")
# 
# sc <- sparkR.init(master="local")
# sqlContext <- sparkRSQL.init(sc)
# 
# on.exit({
#   message("Stopping Spark...")
#   sparkR.stop()
#   message("OK.")
# })
# 
# suppressPackageStartupMessages(library(dplyr))
# suppressPackageStartupMessages(library(nycflights13))
# 
# set.seed(123)
# data <- sample_n(flights, 10000)
# df <- createDataFrame(sqlContext, data.frame(data))
# 
# prior_package(SparkRext)
# 
# test_that("add one column", {
#   result <- mutate(df, gain = arr_delay - dep_delay)
#   act <- c(columns(df), "gain")
#   expect_equal(SparkR::columns(result), act)
# })
# 
# test_that("add two columns", {
#   result <- mutate(df, gain = arr_delay - dep_delay, gain_per_hour = gain/(air_time/60))
#   act <- c(columns(df), "gain", "gain_per_hour")
#   expect_equal(SparkR::columns(result), act)
# })
