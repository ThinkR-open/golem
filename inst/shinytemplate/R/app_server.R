#' @import shiny
#' @importFrom graphics hist
#' @importFrom stats rnorm
#'
app_server <- function(input, output,session) {

  if ( app_prod() ){message("prod mode")}else{message("dev mode")}
  output$distPlot <- renderPlot({
    x    <- rnorm(1000)
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })

  data <- callModule(mod_csv_file,"fichier")
  output$tableau <- DT::renderDT({data()})
}
