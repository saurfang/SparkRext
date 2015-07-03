#' @export
mutate <- function(.data, ..., .dots = lazyeval::lazy_dots(...)) {
  dfname <- as.character(substitute(.data))
  columns <- SparkR::columns(.data)
  if(length(.dots) == 0) return(SparkR::mutate(.data))
  
  spark_input <- to_spark_input(.dots[[1]], dfname, columns)
  colName <- names(.dots)[1]
  .dummy_data_frame <- SparkR::withColumn(.data, colName = colName, col = spark_input)
  if(length(.dots) == 1) {
    .dummy_data_frame
  } else {
    dots_tail <- tail(.dots, -1)
    assign(".dummy_data_frame", .dummy_data_frame, envir = .dots[[1]]$env)
    mutate(.dummy_data_frame, .dots=dots_tail)
  }
}
