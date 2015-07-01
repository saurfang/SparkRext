# context("filter")
# 
# sc <- sparkR.init(master="local")
# sqlContext <- sparkRSQL.init(sc)
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
# test_that("one condition", {
#   result <- filter(df, month == 12) %>% collect
#   expect_equal(nrow(result), 883)
# })
# 
# test_that("two conditions", {
#   result <- filter(df, month == 12, day == 31) %>% collect
#   expect_equal(nrow(result), 27)
# })
# 
# test_that("no conditions", {
#   expect_error(filter(df), "unable to find an inherited method for function*")
# })
# 
# test_that("use variable", {
#   x <- 12
#   result <- filter(df, month == x) %>% collect
#   expect_equal(nrow(result), 883)
# })
# 
# test_that("use variable same name", {
#   x <- list(month = 12)
#   result <- filter(df, month == x$month) %>% collect
#   expect_equal(nrow(result), 883)
# })
# 
# message("Stopping Spark...")
# sparkR.stop()
# message("OK.")
