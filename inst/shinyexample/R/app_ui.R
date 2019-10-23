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
#' @importFrom golem app_sys
golem_add_external_resources <- function(){
  
  golem::add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon(),
    tags$title("shinyexample")
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
    
  )
}