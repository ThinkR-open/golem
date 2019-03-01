#' Add recommended elements
#' 
#' \describe{
#'   \item{use_recommended_dep}{Adds `shiny`, `DT`, `attempt`, `glue`, `golem`, `htmltools` to dependencies}
#'   \item{use_recommended_tests}{Adds a test folder and copy the golem tests}
#' }
#'
#' @inheritParams add_module
#' @param to in case of use_recommended_js, the path to write the JS
#' 
#' @importFrom cli cat_bullet
#' @rdname use_recommended 
#' 
#' @export
use_recommended_dep <- function(pkg = ".",
                                recommended = c("shiny","DT","attempt","glue","golem","htmltools")){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  for ( i in recommended){
       try(usethis::use_package(i))
  }
  cat_bullet("Dependencies added", bullet = "tick", bullet_col = "green")
}


#' @rdname use_recommended 
#' @export
use_recommended_tests <- function(pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  if (!dir.exists(
    file.path(normalizePath(pkg), "tests")
  )){
    usethis::use_testthat()
  }
  file.copy(
    system.file("utils", "test-golem-recommended.R", package = "golem"), 
    file.path(normalizePath(pkg), "tests", "testthat")
  )
  cat_bullet("Tests added", bullet = "tick", bullet_col = "green")
} 

# #' @rdname use_recommended 
# #' @export
# use_recommended_js <- function(pkg = ".", to = "inst/app/www/"){
#   old <- setwd(normalizePath(pkg))
#   on.exit(setwd(old))
# 
#   file.copy(
#     system.file("utils", "golem-js.js", package = "golem"), 
#     file.path(normalizePath(pkg), to)
#   )
#   
#   cat_bullet("JS added", bullet = "tick", bullet_col = "green")
#   
# } 

