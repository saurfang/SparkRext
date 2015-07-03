# context("select")
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
# on.exit({
#   message("Stopping Spark...")
#   sparkR.stop()
#   message("OK.")
# })
# 
# prior_package(SparkRext)
# 
# test_that("one column", {
#   result <- select(df, year)
#   expect_equal(columns(result), "year")
# })
# 
# test_that("two column", {
#   result <- select(df, year, day)
#   expect_equal(columns(result), c("year", "day"))
# })
# 
# test_that("column sequence", {
#   result <- select(df, year:day)
#   expect_equal(columns(result), c("year", "month", "day"))
# })
# 
# test_that("one minus column", {
#   result <- select(df, -year)
#   act <- Filter(function(col) col != "year", columns(result))
#   expect_equal(columns(result), act)
# })
# 
# test_that("two minus columns", {
#   result <- select(df, -year, -day)
#   act <- Filter(Negate(function(col) col %in% c("year", "day")), columns(result))
#   expect_equal(columns(result), act)
# })
# 
# test_that("minus column sequence", {
#   result <- select(df, -(year:day))
#   act <- Filter(Negate(function(col) col %in% c("year", "month", "day")), columns(result))
#   expect_equal(columns(result), act)
# })
# 
# test_that("one number column", {
#   result <- select(df, 1)
#   expect_equal(columns(result), "year")
# })
# 
# test_that("two number columns", {
#   result <- select(df, 1, 3)
#   expect_equal(columns(result), c("year", "day"))
# })
# 
# test_that("number column sequence", {
#   result <- select(df, 1:3)
#   expect_equal(columns(result), c("year", "month", "day"))
# })
# 
# test_that("one minus number column", {
#   result <- select(df, -1)
#   act <- Filter(function(col) col != "year", columns(result))
#   expect_equal(columns(result), act)
# })
# 
# test_that("two minus number columns", {
#   result <- select(df, -1, -3)
#   act <- Filter(Negate(function(col) col %in% c("year", "day")), columns(result))
#   expect_equal(columns(result), act)
# })
# 
# test_that("minus number column sequence", {
#   result <- select(df, -(1:3))
#   act <- Filter(Negate(function(col) col %in% c("year", "month", "day")), columns(result))
#   expect_equal(columns(result), act)
# })
