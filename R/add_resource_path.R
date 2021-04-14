#' Add resource path
#'
#' @inheritParams shiny::addResourcePath
#' @param warn_empty Boolean. Default is `FALSE`.
#'     If TRUE display message if directory is empty.
#'
#' @importFrom shiny addResourcePath
#' 
#' @export
#'
#' @return Used for side effects.
add_resource_path <- function(
  prefix, 
  directoryPath,
  warn_empty = FALSE
){
  
  list_f <- length(
    list.files(
      path = directoryPath
    )
  ) == 0
  
  if ( list_f ) {
    if (warn_empty){
      warning("No resources to add from resource path (directory empty).")
    }
  } else {
    addResourcePath(prefix, directoryPath)
  }
}
