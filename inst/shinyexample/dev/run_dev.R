# Install the package
devtools::install(".", upgrade = "never")

# Set to prod or to dev
options(golem.app.prod = TRUE) 

# Run the app
shiny::runApp(system.file("app", package = "shinyexample"))
