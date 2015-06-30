#'
#' @export
prior_package <- function(pkg_name) {
  pkg_name <- as.character(substitute(pkg_name))
  prior_package_(pkg_name)
}

#'
#' @export
#' @rdname prior_package
prior_package_ <- function(pkg_name) {  
  default_packages <- c(options("defaultPackages")$defaultPackages, "base")
  if(pkg_name %in% default_packages) 
    stop(sporintf("Error. %s is default package.", pkg_name))
  
  packages <- Filter(function(x) stringr::str_detect(x, "^package:"), search())
  packages <- Map(function(x) stringr::str_replace(x, "^package:", ""), packages)
  packages <- unlist(unname(packages))
  
  unload_packages <- Filter(Negate(function(x) x %in% default_packages), packages)
  
  for(pkg in unload_packages) {
    detach(paste0("package:", pkg), character.only = TRUE)
  }
  
  ignore_packages <- c(default_packages, pkg_name)
  load_packages <- rev(Filter(Negate(function(x) x %in% ignore_packages), packages))
  
  for(pkg in load_packages) {
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
  suppressPackageStartupMessages(library(pkg_name, character.only = TRUE))
}
