#' @export
group_by <- dplyr::group_by

#' @export
group_by_.DataFrame <- function(.data, ..., .dots, add = FALSE) {
  .dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)
  
  get_input <- function(lazy) to_spark_input(lazy, .data)
  
  inputs <- Map(get_input, .dots)
  
  args <- c(list(x = .data), inputs)

  structure(
    list(grouped_data = do.call(SparkR::group_by, args), DataFrame = .data),
    class = "SparkGroupedData"
  )
}
