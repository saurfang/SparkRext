.onLoad <- function(libname, pkgname) {
  if(!require(SparkR)) {
    warning("Failed to load 'SparkR' package. You must install it or export path to library.")
  } else if(utils::packageVersion("SparkR") < 1.4) {
    warning(sprintf("Older version 'SparkR' %s found. Required version >= 1.4.0", utils::packageVersion("SparkR")))
  }
}
