#' @export
group_by <- function(.data, ..., .dots = lazyeval::lazy_dots(...)) {
  dfname <- as.character(substitute(.data))
  columns <- SparkR::columns(.data)
  if(length(.dots) == 0) return(SparkR::group_by(.data))
  
  get_input <- function(lazy) to_spark_input(lazy, dfname, columns)
  
  inputs <- Map(get_input, .dots)
  
  args <- c(list(x=.data), inputs)

  result <- list(grouped_data=do.call(SparkR::group_by, args), DataFrame=.data)
  class(result) <- "SparkGroupedData"
  result
}
