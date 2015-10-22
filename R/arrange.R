#' @export
arrange <- dplyr::arrange

#' @export
arrange_.DataFrame <- function(.data, ..., .dots) {
  .dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)
  
  if (length(.dots) == 0) return(.data)
  
  get_input <- function(lazy) to_spark_input(lazy, .data)
  
  inputs <- Map(get_input, .dots)
  
  args <- c(list(x = .data), unname(inputs))
  
  do.call(SparkR::arrange, args)
}
