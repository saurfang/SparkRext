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
# prior_library(SparkRext)
# 
# context("arrange")
# 
# test_that("one variable", {
#   result <- arrange(df, month) %>% head
#   expect_equal(result$month, rep(1, 6))
# })
# 
# test_that("two variables", {
#   result <- arrange(df, month, day) %>% head
#   expect_equal(result$month, rep(1, 6))
#   expect_equal(result$day, rep(1, 6))
# })
# 
# test_that("use desc()", {
#   result <- arrange(df, desc(month)) %>% head
#   expect_equal(result$month, rep(12, 6))
# })
# 
# test_that("use other function", {
#   result <- arrange(df, abs(dep_delay)) %>% head
#   expect_equal(result$dep_delay, rep(0, 6))
# })
# 
# test_that("with pipe", {
#   result <- df %>% arrange(month) %>% head
#   expect_equal(result$month, rep(1, 6))
# })
