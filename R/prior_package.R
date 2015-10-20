#' @export
unload_package <- function(pkg_name) {
  pkg_name <- as.character(substitute(pkg_name))
  unload_package_(pkg_name)
}

#' @export
unload_package_ <- function(pkg_name) {
  packages <- Filter(function(x) stringr::str_detect(x, "^package:"), search())
  packages <- Map(function(x) stringr::str_replace(x, "^package:", ""), packages)
  packages <- unlist(unname(packages))
  
  if(!(pkg_name %in% packages)) {
    return(pkg_name)
  }
  
  result_packages <- pkg_name
  while(TRUE) {
    tryCatch({
      detach(paste0("package:", pkg_name), character.only = TRUE)
      break
    }, error = function(e) {
      required_package <- stringr::str_match(e$message, pattern = "required by ([\\S]+)")[1, 2]
      required_package <- stringr::str_sub(required_package, start = 2, end = -2)
      required_packages <- unload_package_(required_package)
      result_packages <<- c(result_packages, required_packages)
    })
  }
  unique(result_packages)
}

#' @export
prior_library <- function(pkg_name) {
  pkg_name <- as.character(substitute(pkg_name))
  prior_library_(pkg_name)
}

#' @export
prior_library_ <- function(pkg_name) {
  pkg_names <- unload_package_(pkg_name)
  if(pkg_name == "SparkRext") {
    unload_package(SparkR)
    pkg_names <- c("SparkR", pkg_name)
  }
  for (pkg_name in pkg_names) {
    suppressPackageStartupMessages(library(pkg_name, character.only = TRUE))
  }
}
