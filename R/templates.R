#' Project Hook
#' 
#' Project hooks allow to define a function run just after {golem}
#' project creation.
#'
#' @inheritParams create_golem
#' @param ... Arguments passed from `create_golem()`, unused in the default 
#' function.
#'
#' @return Used for side effects
#' @export
#'
#' @examples
#' if (interactive()){
#'     my_proj <- function(...){
#'         unlink("dev/", TRUE, TRUE)
#'     }
#'     create_golem("ici", project_template = my_proj)
#' }
project_hook <- function(path, package_name, ...){
  return(TRUE)
}