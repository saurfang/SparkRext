#' @export
mutate <- dplyr::mutate

#' @export
mutate_.DataFrame <- function(.data, ..., .dots) {
  .dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)
  
  if (length(.dots) == 0) return(.data)
  
  mutations <- mapply(function(col, name) {
    list(name = name, col = col)
  }, .dots, names(.dots), SIMPLIFY = FALSE)
  
  Reduce(function(prev, mutation) {
    SparkR::withColumn(
      prev, 
      colName = mutation$name, 
      col = to_spark_input(mutation$col, prev)
    )
  }, mutations, init = .data)
}
