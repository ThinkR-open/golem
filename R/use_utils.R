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
use_utils_ui <- function(pkg = "."){
  use_utils(file_name = "golem_utils_ui.R", pkg=pkg)
  capture.output(
    usethis::use_package("htmltools")
  )
  cat_green_tick("Utils UI added")
  # automatiquement dans le fichier deplace
}
#' @export
#' @rdname utils_files
use_utils_server <- function(pkg = "."){
  use_utils(file_name = "golem_utils_server.R", pkg=pkg)
  cat_bullet("Utils server added", bullet = "tick", bullet_col = "green")
} 

use_utils <- function(file_name, pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  where <- file.path(normalizePath(pkg), "R", file_name)
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  file.copy(
    from = golem_sys("utils", file_name), 
    to = where
  )
  cat_bullet(glue::glue("File created at {where}"), bullet = "tick", bullet_col = "green")
} 

# "utils_server.R"
