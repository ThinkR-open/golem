#' Add recommended elements
#' 
#' \describe{
#'   \item{use_recommended_deps}{Adds `shiny`, `DT`, `attempt`, `glue`, `golem`, `htmltools` to dependencies}
#'   \item{use_recommended_tests}{Adds a test folder and copy the golem tests}
#' }
#'
#' @inheritParams add_module
#' @inheritParams usethis::use_spell_check
#' @param recommended A vector of recommended packages.
#' @param spellcheck Whether or not to use a spellcheck test.
#' 
#' @importFrom usethis use_testthat use_package
#' @importFrom fs path_abs
#' @rdname use_recommended 
#' 
#' @export
#' 
#' @return Used for side-effects.
#' 
use_recommended_deps <- function(
  pkg = get_golem_wd(),
  recommended = c("shiny","DT","attempt","glue","htmltools","golem")
){
  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))
  for ( i in sort(recommended)){
    try(use_package(i))
  }
  cat_green_tick("Dependencies added")
}


#' @rdname use_recommended 
#' @export
#' @importFrom usethis use_testthat use_package use_spell_check
#' @importFrom utils capture.output
#' @importFrom attempt without_warning stop_if
#' @importFrom fs path_abs path file_exists
use_recommended_tests <- function (
  pkg = get_golem_wd(), 
  spellcheck = TRUE,
  vignettes = TRUE, 
  lang = "en-US", 
  error = FALSE
){
  old <- setwd(path_abs(pkg))
  
  on.exit(setwd(old)) 
  
  if (!dir.exists(
    path(path_abs(pkg), "tests")
  )){
    without_warning(use_testthat)()
  }
  if (requireNamespace("processx")){
    capture.output(use_package("processx")) 
  } else {
    stop("Please install the {processx} package to add these tests.")
  }
  
  stop_if(
    path(old, "tests", "testthat", "test-golem-recommended.R"), 
    file_exists, 
    "test-golem-recommended.R already exists. \nPlease remove it first if you need to reinsert it."
  )
  
  file_copy(
    golem_sys("utils", "test-golem-recommended.R"), 
    path(old, "tests", "testthat"), 
    overwrite = TRUE
  )
  
  if (spellcheck){
    use_spell_check(
      vignettes = vignettes, 
      lang = lang, 
      error = error
    )
  }
  
  
  cat_green_tick("Tests added")
} 


