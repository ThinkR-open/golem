# This scripts tests that {golem} can actually build an app

install.packages("remotes")

remotes::install_local("/golem/golem.tar.gz")

setwd("/tmp")

library(golem)
packageVersion("golem")

library(testthat)

# Create the golem
golem::create_golem( "gogolele", open = FALSE)
setwd("/tmp/gogolele/")

usethis::use_mit_license("Golem")
devtools::check()

golem::set_golem_options()


golem::use_recommended_tests()
golem::use_recommended_deps()
golem::use_utils_ui()
golem::use_utils_server()

golem::add_module( 
  name = "my_first_module", 
  ph_ui = "#ui_plop", 
  ph_server = "#server_plop", 
  open = FALSE
)

mod1 <- readLines("R/mod_my_first_module.R")
mod1 <- append(
  mod1,
  c(
    "actionButton(ns('go'), 'go'),",
    "plotOutput(ns('plot'))"
  ), 
  grep(
    "ui_plop", 
    mod1
  )
)
mod1 <- append(
  mod1,
  c(
    "observeEvent(input$go, {",
    "  golem::invoke_js('alert', 'hey')",
    "})",
    "output$plot <- renderPlot({",
    "   graphics::plot(datasets::iris)",
    "})"
  ), 
  grep(
    "server_plop", 
    mod1
  )
)
write(mod1, "R/mod_my_first_module.R")

ui <- readLines("R/app_ui.R")
ui <- append(
  ui,
  c(
    ',mod_my_first_module_ui("my_first_module_ui_1")'
  ), 
  grep(
    "h1", 
    ui
  )
)
write(ui, "R/app_ui.R")

server <- readLines("R/app_server.R")
server <- append(
  server,
  c(
    'callModule(mod_my_first_module_server, "my_first_module_ui_1")'
  ), 
  grep(
    "first level callModules", 
    server
  )
)
write(server, "R/app_server.R")

devtools::document()
devtools::check()
remotes::install_local()
