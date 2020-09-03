#' Add Golem options to a Shiny App 
#' 
#' @note 
#' You'll probably never have to write this function 
#' as it is included in the golem template created on 
#' launch.
#'
#' @param app the app object.
#' @param golem_opts A list of Options to be added to the app
#' @param print Whether or not to print the app. Default is to TRUE, which 
#' should be what you need in  99.99% of the cases. In case you need to 
#' actually get the app object, you can set it to `FALSE`.
#'
#' @return a shiny.appObj object
#' @export
with_golem_options <- function(
  app, 
  golem_opts, 
  print = TRUE
){
  # Setting the running option
  set_golem_global(
    "running", 
    TRUE
  )
  # Removing the option when the function exits
  on.exit(
    set_golem_global(
      "running", 
      FALSE
    )
  )
  
  # Bundling the options inside the shinyApp object
  app$appOptions$golem_options <- golem_opts
  
  # Almost all cases will be ok with explicitely printing the 
  # application object, but for corner cases like direct shinyApp
  # object manipulation, this feature can be turned off
  if (print){
    print(app)
  } else {
    app
  }
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

