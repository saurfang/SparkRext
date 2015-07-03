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
# context("group_by")
# 
# test_that("check class", {
#   grouped_data <- group_by(df, tailnum)
#   grouped_data_class <- class(grouped_data$grouped_data)
#   attributes(grouped_data_class) <- NULL
#   expect_equal(class(grouped_data), "SparkGroupedData")
#   expect_equal(grouped_data_class, "GroupedData")
#   expect_equal(grouped_data$DataFrame, df)
# })
# 
# test_that("one column", {
#   grouped_data <- group_by(df, tailnum)
#   result <- summarize(grouped_data, size=n(distance)) %>% head
#   expect_equal(result$tailnum, c("N600LR", "N3HAAA", "N77518", "N66051", "N5DCAA", "N947DL"))
#   expect_equal(result$size, c(5, 2, 2, 1, 1, 2))
# })
# 
# test_that("three columns", {
#   grouped_data <- group_by(df, year, month, day)
#   result <- summarize(grouped_data, size=n(distance)) %>% head
#   expect_equal(result$year, c(2013, 2013, 2013, 2013, 2013, 2013))
#   expect_equal(result$month, c(1, 6, 1, 6, 1, 6))
#   expect_equal(result$day, c(5, 20, 6, 21, 7, 22))
#   expect_equal(result$size, c(16, 28, 35, 25, 24, 26))
# })
# 
# test_that("with pipe", {
#   result <- df %>%
#     group_by(tailnum) %>%
#     summarize(size=n(distance)) %>% head
#   expect_equal(result$tailnum, c("N600LR", "N3HAAA", "N77518", "N66051", "N5DCAA", "N947DL"))
#   expect_equal(result$size, c(5, 2, 2, 1, 1, 2))
# })
