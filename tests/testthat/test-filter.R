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
# context("filter")
# 
# test_that("one condition", {
#   result <- filter(df, month == 12) %>% count
#   expect_equal(result, 883)
# })
# 
# test_that("two conditions", {
#   result <- filter(df, month == 12, day == 31) %>% count
#   expect_equal(result, 27)
# })
# 
# test_that("no conditions", {
#   expect_error(filter(df), "unable to find an inherited method for function*")
# })
# 
# test_that("use variable", {
#   x <- 12
#   result <- filter(df, month == x) %>% count
#   expect_equal(result, 883)
# })
# 
# test_that("use variable same name", {
#   x <- list(month = 12)
#   result <- filter(df, month == x$month) %>% count
#   expect_equal(result, 883)
# })
