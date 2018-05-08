# Naming convention :
# all Shinymodule have to begin with `mod_`, in lowercase Except for `UI` , `Input` and `Output`
# use `Input` as sufix if your module is an Input
# use `Output` as sufix if your module is an Output
# use `UI` as sufix if your module is both Input and Output
#
# examples :
# ui side : mod_truc_bidulUI 
# server side : mod_truc_bidul
#
# ui side : mod_machin_chouetteInput 
# server side : mod_machin_chouette

# all shinyModule must have a documentation page
# one unique page for both ui and server side ( you can use `#' @rdname` to link both function)

# A minimalist example is mandatory

#' @title   mod_csv_fileInput and mod_csv_file
#' @description  A shiny Module that imports csv file
#'
#' @param id shiny id
#' @param label fileInput label
#'
#' @export
#' @examples 
#' library(shiny)
#' library(DT)
#' if (interactive()){
#' ui <- fluidPage(
#'   mod_csv_fileInput("fichier"),
#' DTOutput("tableau")
#' )
#' 
#' server <- function(input, output, session) {
#'   data <- callModule(mod_csv_file,"fichier")
#'   output$tableau <- renderDT({data()})
#' }
#' 
#' shinyApp(ui, server)
#' }
#' 
mod_csv_fileInput <- function(id, label = "CSV file") {
  ns <- NS(id)

  tagList(
    fileInput(ns("file"), label),
    checkboxInput(ns("heading"), "Has heading"),
    selectInput(ns("quote"), "Quote", c(
      "None" = "",
      "Double quote" = "\"",
      "Single quote" = "'"
    )),
    selectInput(ns("sep"), "Separator", c(
      "comma" = ",",
      "tabulation" = "\t",
      "semicolon" = ";"
    ))
  )

}


#' mod_csv_file server function
#'
#' @param input internal
#' @param output internal
#' @param session internal
#' @param stringsAsFactors logical: should character vectors be converted to factors? 
#'
#' @importFrom utils read.csv
#' @importFrom glue glue
#' @export
#' @rdname mod_csv_fileInput
mod_csv_file <- function(input, output, session, stringsAsFactors=TRUE) {

  userFile <- reactive({
    validate(need(input$file, message = FALSE))
    input$file
  })

  observe({
    message( glue::glue("File {userFile()$name} uploaded" ) )
  })

  dataframe <- reactive({
    read.csv(userFile()$datapath,
             header = input$heading,
             quote = input$quote,
             sep = input$sep,
             stringsAsFactors = stringsAsFactors)
  })

  dataframe
}
