#' @param request needed for bookmarking
#'
#' @import shiny
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      h1("shinyexample")
    )
  )
}
 
#' @import shiny
golem_add_external_resources <- function(){
  
  golem::add_resource_path(
    'www', system.file('app/www', package = 'shinyexample')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon(),
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
    tags$title("shinyexample")
  )
}