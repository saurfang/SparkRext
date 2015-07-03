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
# context("summarize")
# 
# test_that("one column", {
#   result <- summarize(df, size=n(distance)) %>% collect
#   expect_equal(result$size, 10000)
# })
# 
# test_that("two columns", {
#   result <- summarize(df, months=n_distinct(month), days=n_distinct(day)) %>% collect
#   expect_equal(result$months, 12)
#   expect_equal(result$days, 31)
# })
# 
# test_that("first()", {
#   result <- summarize(df, first_distance=first(distance)) %>% collect
#   expect_equal(result$first_distance, 488)
# })
# 
# test_that("last()", {
#   result <- summarize(df, last_distance=last(distance)) %>% collect
#   expect_equal(result$last_distance, 1400)
# })
# 
# test_that("with pipe", {
#   result <- df %>% summarize(size=n(distance)) %>% collect
#   expect_equal(result$size, 10000)
# })
