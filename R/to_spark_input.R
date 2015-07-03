to_spark_input <- function(lazy, dfname, columns) {
  expr <- lazy$expr
  envir <- lazy$env
  spark_expr <- translate_spark_columns(expr, dfname, columns)
  eval(spark_expr, envir = envir)
}

translate_spark_columns <- function(call, dfname, columns) {
  if(is.atomic(call)) return(call)
  
  if(is.symbol(call)) {
    name <- as.character(call)
    if(name %in% columns) {
      parse(text = sprintf("%s$%s", dfname, name))[[1]]
    } else {
      call
    }
  } else if(is.call(call)) {
    name <- as.character(call[[1]])
    if(name %in% c("$", "[[", "[")) {
      call
    } else {
      call[-1] <- lapply(call[-1], translate_spark_columns, dfname, columns)
      call
    }
  }
}
