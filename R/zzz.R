.onLoad <- function(libname, pkgname) {
  # load SparkR -------------------------------------------------------------  
  if(!require(SparkR)) {
    warning("Failed to load 'SparkR' package. You must install it or export path to library.")
  } else if(utils::packageVersion("SparkR") < 1.4) {
    warning(sprintf("Older version 'SparkR' %s found. Required version >= 1.4.0", utils::packageVersion("SparkR")))
  } else if(utils::packageVersion("SparkR") < 1.5) {
    # Override SparkR::collect --------------------------------------------------------  
    collect <- function(x, stringsAsFactors = FALSE) {
      # listCols is a list of raw vectors, one per column
      listCols <- SparkR:::callJStatic("org.apache.spark.sql.api.r.SQLUtils", "dfToCols", x@sdf)
      cols <- lapply(listCols, function(col) {
        objRaw <- rawConnection(col)
        numRows <- SparkR:::readInt(objRaw)
        col <- SparkR:::readCol(objRaw, numRows)
        close(objRaw)
        ### begin added area to read Timestamp ###
        if(is.list(col) && length(col) > 0) {
          obj <- col[[1]]
          class <- SparkR:::callJMethod(obj, "getClass")
          class_name <- SparkR:::callJMethod(class, "getName")
          if(class_name == "java.sql.Timestamp") {
            times <- lapply(col, function(x) {
              SparkR:::callJMethod(x, "getTime")
            })
            times <- unlist(times, use.names = FALSE) / 1000
            col <- as.POSIXct(times, origin = "1970-01-01")
          }
        }
        ### end added area ###
        col
      })
      names(cols) <- columns(x)
      do.call(cbind.data.frame, list(cols, stringsAsFactors = stringsAsFactors))
    }
    SparkR_env <- asNamespace("SparkR")
    environment(collect) <- SparkR_env
    invisible(eval(setMethod("collect", signature(x = "DataFrame"), collect), SparkR_env))
  }
}
