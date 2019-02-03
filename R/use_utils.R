#' Use the utils files
#' 
#' \describe{
#'   \item{use_utils_ui}{Copies the golem_utils_ui.R to the R folder.}
#'   \item{use_utils_prod}{Copies the golem_utils_prod.R to the R folder.}
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
}

#' @export
#' @rdname utils_files
use_utils_prod <- function(pkg = "."){
  use_utils(file_name = "golem_utils_prod.R", pkg=pkg)
}

#' @export
#' @rdname utils_files
use_utils_server <- function(pkg = "."){
  use_utils(file_name = "golem_utils_server.R", pkg=pkg)
} 

use_utils <- function(file_name,pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  file.copy(
    system.file("utils", file_name, package = "golem"), 
    to <- file.path(normalizePath(pkg), "R", file_name)
  )
  cat_bullet(glue::glue("File created at {to}"), bullet = "tick", bullet_col = "green")
} 

# "utils_server.R"
