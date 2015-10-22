#' @export
select <- dplyr::select

#' @export
select_.DataFrame <- function(.data, ..., .dots) {
  .dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)
  
  if (is.character(.dots)) {
    cols <- as.list(.dots)
  } else {
    cols <- Map(function(lazy) lazy$expr, .dots)
    if (!is.character(unlist(cols))) {
      columns <- SparkR::columns(.data)
      vars <- dplyr::select_vars_(columns, .dots)
      cols <- as.list(vars)
    }
  }
  SparkR::select(.data, cols)
}
