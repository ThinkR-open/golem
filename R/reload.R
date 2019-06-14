#' Detach all attached package
#' 
#' @importFrom attempt attempt
#' @importFrom utils sessionInfo
#'
#' @export
detach_all_attached <- function(){
  all_attached <-  paste("package:", names(sessionInfo()$otherPkgs), sep = "")
 attempt(
    suppressWarnings(
      lapply(
        all_attached,
        detach, 
        character.only = TRUE, 
        unload = TRUE
      )
    ), 
    silent = TRUE
  )
}




#' Document and reload your package
#' 
#' This function calls \code{rstudioapi::documentSaveAll()}, 
#' \code{roxygen2::roxygenise()} and \code{pkgload::load_all()}.
#'
#' @inheritParams add_module
#' @importFrom roxygen2 roxygenise
#' @importFrom pkgload load_all
#' @export
document_and_reload <- function(
  pkg = "."
){
  if (rstudioapi::hasFun("documentSaveAll")) {
    rstudioapi::documentSaveAll()
  }
  roxygenise(package.dir = pkg)
  load_all(pkg)
}