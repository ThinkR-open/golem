# This script allow you to quick clean your R session
# update documentation and NAMESPACE, localy install the package
# and run the example used to show how mod_csv_fileInput work
.rs.api.documentSaveAll() # close and save all open file
suppressWarnings(lapply(paste('package:',names(sessionInfo()$otherPkgs),sep=""),detach,character.only=TRUE,unload=TRUE))
rm(list=ls(all.names = TRUE))
devtools::document('.')
devtools::load_all('.')
options(app.prod=FALSE) # TRUE = production mode, FALSE = development mode

# example("mod_csv_fileInput",package = "shinytemplate") # PR welcome 
library(shiny)
library(DT)
if (interactive()){
  ui <- fluidPage(
    mod_csv_fileInput("fichier"),
    DTOutput("tableau")
  )

  server <- function(input, output, session) {
    data <- callModule(mod_csv_file,"fichier")
    output$tableau <- renderDT({data()})
  }

  shinyApp(ui, server)
}