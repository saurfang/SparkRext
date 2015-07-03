#' @export
select <- function(.data, ..., .dots = lazyeval::lazy_dots(...)) {
  columns <- SparkR::columns(.data)
  vars <- dplyr::select_vars_(columns, .dots)
  cols <- as.list(vars)
  SparkR::select(.data, cols)
}
