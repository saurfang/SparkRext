#' @export
summarize <- dplyr::summarize

#' @export
summarise_.DataFrame <- function(.data, ..., .dots) {
  summarise_(group_by(.data), ..., .dots = .dots)
}

#' @export
summarise_.SparkGroupedData <- function(.data, ..., .dots) {
  .dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)
  
  if (length(.dots) == 0) return(SparkR::summarize(.data$grouped_data))
  
  df <- .data$DataFrame
  .data <- .data$grouped_data
  
  get_input <- function(lazy) {
    to_spark_input(lazy, df)
  }
  
  inputs <- Map(get_input, .dots)
  
  # supress is.na check warning
  args <- suppressWarnings(c(x = .data, inputs))
  
  do.call(SparkR::summarize, args)
}
