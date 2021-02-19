#' Add Golem options to a Shiny App 
#' 
#' You'll probably never have to write this function 
#' as it is included in the golem template created on 
#' launch.
#' 
#' @note 
#' For compatibility issue, this function turns `options(shiny.autoload.r)`
#' to `FALSE`. See https://github.com/ThinkR-open/golem/issues/468 for more background.
#'
#' @param app the app object.
#' @param golem_opts A list of Options to be added to the app
#' @param print Whether or not to print the app. Default is to FALSE, which 
#' should be what you need in  99.99% of the cases. In case you need to 
#' actively print the app object, you can set it to `TRUE`.
#'
#' @return a shiny.appObj object
#' @export
with_golem_options <- function(
  app, 
  golem_opts, 
  print = FALSE
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
  
  # On shiny server, Connect & shinyapp.io, print should be turned off, 
  # as it would throw an error
  
  if (Sys.getenv('SHINY_PORT') != ""){
    print <- FALSE
  }
  
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
#' @examples 
#' 
#' if (interactive()){
#'   
#'   # Define and use golem_options
#'   
#'   # 1. Pass parameters to `run_app`
#'   
#'   # to set default value, edit run_app like this :
#'   run_app <- function(
#'     title = "this",
#'     content = "that"
#'   ) {
#'     with_golem_options(
#'       app = shinyApp(
#'         ui = app_ui,
#'         server = app_server
#'       ),
#'       golem_opts = list(
#'         p1 = p1,
#'         p3 = p3
#'       )
#'     )
#'   }
#'   
#'   # 2. Get the values from the UI side
#'   
#'   h1( get_golem_options("title") )
#'   
#'   # 3. Get the value from the server-side
#'   
#'   output$param <- renderPrint({
#'     paste("param p2 = ",get_golem_options("p2"))
#'   })
#'   
#' }
#' 
get_golem_options <- function(which = NULL){
  
  if (is.null(which)){
    getShinyOption("golem_options")
  } else {
    getShinyOption("golem_options")[[which]]
  }
}

