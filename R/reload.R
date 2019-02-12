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
#' @inheritParams add_module
#' @importFrom devtools document
#' @importFrom pkgload load_all
#' @export
document_and_reload <- function(pkg = "."){
  document(pkg)
  load_all(pkg)
}