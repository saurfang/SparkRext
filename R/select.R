#'
#' @export
select <- function(data, ...) {
  dots <- lazyeval::lazy_dots(...)
  columns <- SparkR::columns(data)
  
  get_col_seq <- function(expr) {
    expr <- gsub(pattern = "[\\(\\)]", replacement = "", x = expr)
    args <- strsplit(expr, split = ":")[[1]]
    if(length(args) == 1) return(args)
    begin <- args[1]
    end <- args[2]
    if(!(begin %in% columns) || !(end %in% columns))
      stop(sprintf("%s is invalid for select()", expr))
    result <- NULL
    for(col in columns) {
      if(col == end) {
        result <- c(result, col)
        break
      } else if(col == begin) {
        result <- begin
      } else if(!is.null(result)) {
        result <- c(result, col)
      }
    }
    result
  }
  extract_cols <- function(dot) {
    expr <- dot$expr
    args <- as.character(expr)
    if(length(args) == 1) {
      return(args)
    } else {
      operator <- args[1]
      if(operator == ":") {
        return(get_col_seq(deparse(expr)))
      } else if(operator == "-") {
        return(paste0("-", get_col_seq(args[2])))
      }
    }
  }
  cols_list <- Map(extract_cols, dots)
  
  is_minus_state <- FALSE
  result_col_list <- NULL
  tmp_list <- NULL
  for(cols in cols_list) {
    for(col in cols) {
      if(substring(col, 1, 1) == "-") {
        if(!is_minus_state) {
          result_col_list <- c(result_col_list, list(tmp_list))
          tmp_list <- list()
          is_minus_state <- TRUE
        }
        tmp_list <- c(tmp_list, list(col))
      } else {
        if(is_minus_state) {
          result_col_list <- c(result_col_list, list(tmp_list))
          tmp_list <- list()
          is_minus_state <- FALSE
        }
        tmp_list <- c(tmp_list, list(col))
      }
    }
  }
  result_col_list <- c(result_col_list, list(tmp_list))
  result_col_list <- Filter(function(cols) !is.null(cols), result_col_list)
  result_col_list <- Map(function(cols) {
    if(substring(cols[[1]], 1, 1) == "-") {
      cols <- Map(function(x) gsub(pattern = "-", replacement = "", x), cols)
      cols <- Filter(Negate(function(col) col %in% cols), columns)
      cols <- Map(function(x) x, cols)
      cols <- unname(cols)
    }
    cols
  }, result_col_list)
  result_col_list
  Reduce(function(prev, cols) {
    columns <- columns(prev)
    cols <- Filter(function(x) x %in% columns, cols)
    SparkR::select(prev, cols)
  }, result_col_list, init = data)
}
