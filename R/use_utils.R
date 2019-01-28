#' Use the utils files
#'
#' @inheritParams add_module
#'
#' @export
#' @rdname utils_files
#' @importFrom cli cat_bullet
#' 
use_utils_ui <- function(pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  file.copy(
    system.file("utils", "utils_ui.R", package = "golem"), 
    file.path(normalizePath(pkg), "R", "utils_ui.R")
  )
  cat_bullet("File added", bullet = "tick", bullet_col = "green")
}

#' @export
#' @rdname utils_files
use_utils_prod <- function(pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  file.copy(
    system.file("utils", "utils_prod.R", package = "golem"), 
    file.path(normalizePath(pkg), "R", "utils_prod.R")
  )
  cat_bullet("File added", bullet = "tick", bullet_col = "green")
}

#' @export
#' @rdname utils_files
use_utils_server <- function(pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  file.copy(
    system.file("utils", "utils_server.R", package = "golem"), 
    file.path(normalizePath(pkg), "R", "utils_server.R")
  )
  cat_bullet("File added", bullet = "tick", bullet_col = "green")
} 