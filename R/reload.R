#' Detach all attached package
#'
#' @export
detach_all_attached <- function(){
  all_attached <-  paste("package:", names(sessionInfo()$otherPkgs), sep = "")
  attempt::attempt(
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
#' @inheritParams add_module
#'
#' @export
document_and_reload <- function(pkg = "."){
  devtools::document(pkg)
  pkgload::load_all(pkg)
}