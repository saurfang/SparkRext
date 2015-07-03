#'
#' @export
arrange <- function(.data, ..., .dots = lazyeval::lazy_dots(...)) {
  dfname <- as.character(substitute(.data))
  columns <- SparkR::columns(.data)
  if(length(.dots) == 0) return(SparkR::arrange(.data))
  
  get_input <- function(lazy) to_spark_input(lazy, dfname, columns)
  
  inputs <- Map(get_input, .dots)
  
  args <- c(list(x=.data), inputs)
  
  do.call(SparkR::arrange, args)
}
