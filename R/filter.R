#' @export
filter <- function(.data, ..., .dots = lazyeval::lazy_dots(...)) {
  dfname <- as.character(substitute(.data))
  columns <- SparkR::columns(.data)
  
  if(length(.dots) == 0) return(SparkR::filter(.data))
  
  get_conditions <- function(lazy) to_spark_input(lazy, dfname, columns)
  
  conditions <- Map(get_conditions, .dots)
  
  Reduce(function(prev, cond) SparkR::filter(prev, cond), conditions, init = .data)
}
