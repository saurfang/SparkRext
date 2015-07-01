to_spark_input <- function(dot, dfname, columns) {
  expr <- deparse(dot$expr)
  envir <- dot$env
  expr <- Reduce(function(prev, colname) {
    replacement <- sprintf("%s$%s", dfname, colname)
    tmp <- stringr::str_replace_all(prev, pattern = colname, replacement = replacement)
    pattern <- sprintf("$%s", dfname)
    stringr::str_replace_all(tmp, pattern = pattern, replacement = "")
  }, columns, init = expr)
  eval(parse(text = expr), envir = envir)
}
