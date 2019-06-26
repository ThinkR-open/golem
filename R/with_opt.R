#' Add Golem options to a Shiny App 
#' 
#' @note 
#' You'll probably never have to write this function 
#' as it is included in the golem template created on 
#' launch.
#'
#' @param app the app object.
#' @param golem_opts A list of Options to be added to the app
#'
#' @return a shiny.appObj object
#' @export
with_golem_options <- function(app, golem_opts){
  app$appOptions$golem_options <- golem_opts
  app
}

#' Get all or one golem options
#' 
#' This function is to be used inside the 
#' server and UI from your app, in order to call the 
#' parameters passed to \code{run_app()}.
#'
#' @param which NULL (default), or the name of an option
#' @importFrom shiny getShinyOption
#' @export
get_golem_options <- function(which = NULL){
  if (is.null(which)){
    getShinyOption("golem_options")
  } else {
    getShinyOption("golem_options")[[which]]
  }
}