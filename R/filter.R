#' 
#' @export
filter <- function(.data, ...) {
  dfname <- as.character(substitute(.data))
  columns <- SparkR::columns(.data)
  dots <- lazyeval::lazy_dots(...)
  if(length(dots) == 0) return(SparkR::filter(.data))
  
  get_condition <- function(dot) {
    expr <- deparse(dot$expr)
    envir <- dot$env
    condition <- Reduce(function(prev, colname) {
      pattern <- sprintf("(^|[^$])%s", colname)
      replacement <- sprintf("%s$%s", dfname, colname)
      stringr::str_replace_all(prev, pattern = pattern, replacement = replacement)
    }, columns, init = expr)
    eval(parse(text = condition), envir = envir)
  }
  
  conditions <- Map(get_condition, dots)

  Reduce(function(prev, cond) SparkR::filter(prev, cond), conditions, init = .data)
}
