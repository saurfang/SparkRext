sc <- sparkR.init(master="local")
sqlContext <- sparkRSQL.init(sc)

on.exit({
  message("Stopping Spark...")
  sparkR.stop()
  message("OK.")
})

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(nycflights13))

set.seed(123)
data <- sample_n(flights, 10000)
df <- createDataFrame(sqlContext, data.frame(data))

prior_package(SparkRext)

context("filter")

test_that("one condition", {
  result <- filter(df, month == 12) %>% count
  expect_equal(result, 883)
})

test_that("two conditions", {
  result <- filter(df, month == 12, day == 31) %>% count
  expect_equal(result, 27)
})

test_that("no conditions", {
  expect_error(filter(df), "unable to find an inherited method for function*")
})

test_that("use variable", {
  x <- 12
  result <- filter(df, month == x) %>% count
  expect_equal(result, 883)
})

test_that("use variable same name", {
  x <- list(month = 12)
  result <- filter(df, month == x$month) %>% count
  expect_equal(result, 883)
})

context("select")

test_that("one column", {
  result <- select(df, year)
  expect_equal(columns(result), "year")
})

test_that("two column", {
  result <- select(df, year, day)
  expect_equal(columns(result), c("year", "day"))
})

test_that("column sequence", {
  result <- select(df, year:day)
  expect_equal(columns(result), c("year", "month", "day"))
})

test_that("one minus column", {
  result <- select(df, -year)
  act <- Filter(function(col) col != "year", columns(result))
  expect_equal(columns(result), act)
})

test_that("two minus columns", {
  result <- select(df, -year, -day)
  act <- Filter(Negate(function(col) col %in% c("year", "day")), columns(result))
  expect_equal(columns(result), act)
})

test_that("minus column sequence", {
  result <- select(df, -(year:day))
  act <- Filter(Negate(function(col) col %in% c("year", "month", "day")), columns(result))
  expect_equal(columns(result), act)
})

test_that("one number column", {
  result <- select(df, 1)
  expect_equal(columns(result), "year")
})

test_that("two number columns", {
  result <- select(df, 1, 3)
  expect_equal(columns(result), c("year", "day"))
})

test_that("number column sequence", {
  result <- select(df, 1:3)
  expect_equal(columns(result), c("year", "month", "day"))
})

test_that("one minus number column", {
  result <- select(df, -1)
  act <- Filter(function(col) col != "year", columns(result))
  expect_equal(columns(result), act)
})

test_that("two minus number columns", {
  result <- select(df, -1, -3)
  act <- Filter(Negate(function(col) col %in% c("year", "day")), columns(result))
  expect_equal(columns(result), act)
})

test_that("minus number column sequence", {
  result <- select(df, -(1:3))
  act <- Filter(Negate(function(col) col %in% c("year", "month", "day")), columns(result))
  expect_equal(columns(result), act)
})

context("mutate")

test_that("add one column", {
  result <- mutate(df, gain = arr_delay - dep_delay)
  act <- c(columns(df), "gain")
  expect_equal(SparkR::columns(result), act)
})

test_that("add two columns", {
  result <- mutate(df, gain = arr_delay - dep_delay, gain_per_hour = gain/(air_time/60))
  act <- c(columns(df), "gain", "gain_per_hour")
  expect_equal(SparkR::columns(result), act)
})

context("arrange")

test_that("one variable", {
  result <- arrange(df, month) %>% head
  expect_equal(result$month, rep(1, 6))
})

test_that("two variables", {
  result <- arrange(df, month, day) %>% head
  expect_equal(result$month, rep(1, 6))
  expect_equal(result$day, rep(1, 6))
})

test_that("use desc()", {
  result <- arrange(df, desc(month)) %>% head
  expect_equal(result$month, rep(12, 6))
})

test_that("use other function", {
  result <- arrange(df, abs(dep_delay)) %>% head
  expect_equal(result$dep_delay, rep(0, 6))
})

context("summarize")

test_that("one column", {
  result <- summarize(df, size=n(distance)) %>% collect
  expect_equal(result$size, 10000)
})

test_that("two columns", {
  result <- summarize(df, months=n_distinct(month), days=n_distinct(day)) %>% collect
  expect_equal(result$months, 12)
  expect_equal(result$days, 31)
})

test_that("first()", {
  result <- summarize(df, first_distance=first(distance)) %>% collect
  expect_equal(result$first_distance, 488)
})

test_that("last()", {
  result <- summarize(df, last_distance=last(distance)) %>% collect
  expect_equal(result$last_distance, 1400)
})
