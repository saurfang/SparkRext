.onLoad <- function(libname, pkgname) {
  # load SparkR -------------------------------------------------------------  
  if(!requireNamespace("SparkR")) {
    warning("Failed to load 'SparkR' package. You must install it or export path to library.")
  } else if(utils::packageVersion("SparkR") < 1.5) {
    warning(sprintf("Older version 'SparkR' %s found. Required version >= 1.5.0", utils::packageVersion("SparkR")))
  }
}
