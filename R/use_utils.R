#' Use the utils files
#' 
#' \describe{
#'   \item{use_utils_ui}{Copies the golem_utils_ui.R to the R folder.}
#'   \item{use_utils_server}{Copies the golem_utils_server.R to the R folder.}
#' }
#'
#' @inheritParams add_module
#'
#' @export
#' @rdname utils_files
#' 
#' @importFrom cli cat_bullet
#' @importFrom glue glue
#' @importFrom utils capture.output
use_utils_ui <- function(
  pkg = get_golem_wd()
){
  use_utils(
    file_name = "golem_utils_ui.R", 
    pkg = pkg
  )
  capture.output(
    usethis::use_package("htmltools")
  )
  cat_green_tick("Utils UI added")
}
#' @export
#' @rdname utils_files
use_utils_server <- function(
  pkg = get_golem_wd()
){
  use_utils(
    file_name = "golem_utils_server.R", 
    pkg = pkg
  )
  cat_green_tick("Utils server added")
} 

#' @importFrom fs file_copy path_abs
use_utils <- function(
  file_name, 
  pkg = get_golem_wd()
){
  old <- setwd(
    path_abs(pkg)
  )
  on.exit( setwd(old) )
  where <- path(path_abs(pkg), "R", file_name)
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  file_copy(
    path = golem_sys("utils", file_name), 
    new_path = where
  )
  cat_green_tick(glue::glue("File created at {where}"))
} 
