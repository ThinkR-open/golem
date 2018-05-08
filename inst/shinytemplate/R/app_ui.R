
#' @import shiny
app_ui <- function() {
  fluidPage(
    titlePanel("My Awesome Shiny App"),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        sliderInput("bins",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 30),
        mod_csv_fileInput("fichier")
      ),

      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("distPlot"),
        DT::DTOutput("tableau")
      )
    )
  )
}
