#' Run the Shiny Application
#'
#' @param onStart optional, described in ?shiny::shinyApp
#' @param options optional, described in ?shiny::shinyApp
#' @param enableBookmarking optional, described in ?shiny::shinyApp
#' @param ... arguments to pass to golem_opts
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(onStart = NULL,
                    options = list(), 
                    enableBookmarking = NULL,
                    ...) {
  with_golem_options(
    app = shinyApp(ui = app_ui,
                   server = app_server,
                   onStart = onStart,
                   options = options, 
                   enableBookmarking = enableBookmarking), 
    golem_opts = list(...)
  )
}