#' Add resource path
#'
#' @inheritParams shiny::addResourcePath
#' @param warn_empty Boolean. By default FALSE, if TRUE display message if directory is empty.
#'
#' @importFrom shiny addResourcePath
#' 
#' @export
#'
add_resource_path <- function(
  prefix, 
  directoryPath,
  warn_empty = FALSE
){
  
  list_f <- length(
    list.files(path = directory_path)
  ) == 0
  
  if ( list_f & warn_empty ) {
    warning("No resources to add from resource path (directory empty).")
  } else {
    addResourcePath(prefix, directoryPath)
  }
}
