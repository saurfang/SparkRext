#' 
#' @export
filter <- function(data, ...) {
  data_name <- as.character(substitute(data))
  dots <- lazyeval::lazy_dots(...)
  if(length(dots) == 0) return(SparkR::filter(data))
  
  get_condition <- function(dot) {
    expr <- deparse(dot$expr)
    envir <- dot$env
    condition <- Reduce(function(prev, colname) {
      gsub(pattern = colname, replacement = paste0(data_name, "$", colname), prev)
    }, columns(data), init = expr)
    eval(parse(text = condition), envir = envir)
  }
  
  conditions <- Map(get_condition, dots)

  Reduce(function(prev, cond) SparkR::filter(prev, cond), conditions, init = data)
}
