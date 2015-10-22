#' @export
filter <- dplyr::filter

#' @export
filter_.DataFrame <- function(.data, ..., .dots) {
  .dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)
  
  if (length(.dots) == 0) return(.data)
  
  get_conditions <- function(lazy) to_spark_input(lazy, .data)
  
  conditions <- Map(get_conditions, .dots)
  
  Reduce(function(prev, cond) SparkR::filter(prev, cond), conditions, init = .data)
}
