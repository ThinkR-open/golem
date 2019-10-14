#' Add resource path
#'
#' @param prefix The URL prefix (without slashes). Valid characters are a-z, A-Z, 0-9, hyphen, period, and underscore. For example, a value of 'foo' means that any request paths that begin with '/foo' will be mapped to the given directory.
#' @param directory_path The directory that contains the static resources to be served.
#' @param warn_empty Boolean. By default FALSE, if TRUE diplay message if directory empty
#'
#' @importFrom rlang is_empty
#' @importFrom shiny addResourcePath
#' 
#' @export
#'
add_resource_path <- function(prefix, 
                              directory_path,
                              warn_empty = FALSE){
 
  list_f <- is_empty(list.files(path = directory_path))
  
  if(list_f & warn_empty ){
    message("Unable to add your directory because it is empty")
  }else{
    addResourcePath(prefix, directory_path)
  }
}