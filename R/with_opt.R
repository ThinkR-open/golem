#' Add Golem options to a Shiny App
#'
#' You'll probably never have to write this function
#' as it is included in the golem template created on
#' launch.
#'
#' @param app the app object.
#' @param golem_opts A list of options to be added to the app
#' @param maintenance_page an html_document or a shiny tag list. Default is golem template.
#' @param print Whether or not to print the app. Default is to `FALSE`, which
#' should be what you need 99.99% of the time. In case you need to
#' actively print() the app object, you can set it to `TRUE`.
#'
#' @return a shiny.appObj object
#' @export
with_golem_options <- function(
  app,
  golem_opts,
  maintenance_page = golem::maintenance_page,
  print = FALSE
) {

  # Check if app is in maintenance
  if (Sys.getenv("GOLEM_MAINTENANCE_ACTIVE", "FALSE") == "TRUE") {
    app <- shiny::shinyApp(
      ui = maintenance_page,
      server = function(input, output, session) {}
    )
  }

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

  if (Sys.getenv("SHINY_PORT") != "") {
    print <- FALSE
  }

  # Almost all cases will be ok with not explicitely printing the
  # application object, but for corner cases like direct shinyApp
  # object manipulation, this feature can be turned on
  if (print) {
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
#'
#' @return The value of the option.
#'
#' @examples
#'
#' # Define and use golem_options
#' if (interactive()) {
#'   # 1. Pass parameters directly to `run_app`
#'
#'   run_app( title="My Golem App", 
#'            content = "something" )
#'
#'   # 2. Get the values 
#'   # 2.1 from the UI side
#'
#'   h1(get_golem_options("title"))
#'
#'   # 2.2 from the server-side
#'
#'   output$param <- renderPrint({
#'     paste("param content = ", get_golem_options("content"))
#'   })
#'   
#'   output$param_full <- renderPrint({
#'      get_golem_options() # list of all golem options as a list.
#'   })
#'   
#'   # 3. If needed, to set default value, edit `run_app` like this :
#'
#'   run_app <- function(
#'              title = "this",
#'              content = "that"
#'   ) {
#'     with_golem_options(
#'       app = shinyApp(
#'         ui = app_ui,
#'         server = app_server
#'       ),
#'       golem_opts = list(
#'       ...
#'       )
#'     )
#'   }
#'    
#'   
#' }
#'
get_golem_options <- function(which = NULL) {
  if (is.null(which)) {
    getShinyOption("golem_options")
  } else {
    getShinyOption("golem_options")[[which]]
  }
}

#' maintenance_page
#'
#' A default html page for maintenance mode
#'
#' @importFrom shiny htmlTemplate
#'
#' @return an html_document
#' @details see the vignette \code{vignette("f_extending_golem", package = "golem")} for details.
#' @export
maintenance_page <- function() {
  shiny::htmlTemplate(
    filename = system.file(
      "app",
      "maintenance.html",
      package = "golem"
    )
  )
}
