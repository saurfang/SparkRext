#' @export
summarize <- function(.data, ..., .dots = lazyeval::lazy_dots(...)) {
  UseMethod("summarize")
}

#' @export
summarise <- summarize

summarize.DataFrame <- function(.data, ..., .dots = lazyeval::lazy_dots(...)) {
  dfname <- as.character(substitute(.data))
  columns <- SparkR::columns(.data)
  if(length(.dots) == 0) return(SparkR::summarize(.data))
  
  get_input <- function(lazy) to_spark_input(lazy, dfname, columns)
  
  inputs <- Map(get_input, .dots)
  
  args <- c(list(x=.data), inputs)
  
  do.call(SparkR::summarize, args)
}

summarize.SparkGroupedData <- function(.data, ..., .dots = lazyeval::lazy_dots(...)) {
  df <- .data$DataFrame
  columns <- SparkR::columns(df)
  .data <- .data$grouped_data

  if(length(.dots) == 0) return(SparkR::summarize(.data))
  
  get_input <- function(lazy) {
    assign(".dummy_data_frame", value = df, envir = lazy$env)
    to_spark_input(lazy, ".dummy_data_frame", columns)
  }
  
  inputs <- Map(get_input, .dots)
  
  args <- c(list(x=.data), inputs)
  
  do.call(SparkR::summarize, args)
}
