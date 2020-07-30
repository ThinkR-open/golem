#' Run run_dev.R
#'
#' @param file File path to `run_dev.R`. Defaults to `R/run_dev.R`.
#' @param pkg Package name to run the file. Defaults to current active package.
#' 
#' @export
run_dev <- function(
  file, 
  pkg = pkgload::pkg_name()
){
  if (missing(file)) { 
    file <- "dev/run_dev.R"
  } 
  
  if (pkgload::is_dev_package(pkg)) {
    run_dev_lines <- readLines(
      file.path(
        pkgload::pkg_path(), 
        file
      )
    )
    
  } else {
    try_dev <- file.path(
      pkgload::pkg_path(),
      file
    )
    
    if ( file.exists(try_dev) ) {
      run_dev_lines <- readLines("dev/run_dev.R")
      
    } else {
      stop("Unable to locate dev file")
    }
  }
  
  eval(parse(text = run_dev_lines))
}