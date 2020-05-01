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
      invisible(lapply(
        all_attached,
        detach, 
        character.only = TRUE, 
        unload = TRUE
        )
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
  pkg = get_golem_wd()
){
  if (rstudioapi::hasFun("documentSaveAll")) {
    rstudioapi::documentSaveAll()
  }
  roxed <- try({
    roxygenise(package.dir = pkg)
    })
  if (attempt::is_try_error(roxed)){
    cli::cat_rule(
      "Error documenting your package"
    )
    dialog_if_has("Alert", "Error documenting your package")
    return(invisible(FALSE))
  }
  loaded <- try({
    load_all(pkg,export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)
  })
  
  if (attempt::is_try_error(loaded)){
    cli::cat_rule(
      "Error loading your package"
    )
    dialog_if_has("Alert", "Error loading your package")
    return(invisible(FALSE))
  }
  
}

dialog_if_has <- function(title, message, url = ""){
  if (rstudioapi::hasFun("showDialog")) {
    rstudioapi::showDialog(title, message, url)
  }
}
