#' Use the utils files
#'
#' @inheritParams add_module
#'
#' @export
#' @rdname utils_files
#' @importFrom cli cat_bullet
#' @importFrom glue glue
#' 
use_utils_ui <- function(pkg = "."){
  use_utils(file_name = "utils_ui.R", pkg=pkg)
}

#' @export
#' @rdname utils_files
use_utils_prod <- function(pkg = "."){
  use_utils(file_name = "utils_prod.R", pkg=pkg)
}

#' @export
#' @rdname utils_files
use_utils_server <- function(pkg = "."){
  use_utils(file_name = "utils_server.R", pkg=pkg)
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

"utils_server.R"
