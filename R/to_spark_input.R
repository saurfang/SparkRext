to_spark_input <- function(lazy, df, columns = SparkR::columns(df)) {
  spark_expr <- translate_spark_columns(lazy$expr, df, columns)
  eval(spark_expr, envir = lazy$env)
}

translate_spark_columns <- function(call, df, columns) {
  if(is.atomic(call)) return(call)
  
  if(is.symbol(call)) {
    name <- as.character(call)
    if(name %in% columns) {
      do.call(`$`, list(df, name))
    } else {
      call
    }
  } else if(is.call(call)) {
    name <- as.character(call[[1]])
    if(name %in% c("$", "[[", "[")) {
      call
    } else {
      call[-1] <- lapply(call[-1], translate_spark_columns, df, columns)
      call
    }
  }
}
