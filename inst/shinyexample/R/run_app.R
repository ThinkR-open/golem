#' Run the Shiny Application
#'
#' @param ... A list of Options to be added to the app
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(...) {
  with_golem_options(
    app = shinyApp(ui = app_ui, server = app_server), 
    golem_opts = list(...)
  )
}
