context("Application")
library(shiny)
test_that("app ui", {
  ui <- shinytemplate:::app_ui()
  expect_is(ui, "shiny.tag.list")
})

# need to be updated to work with ShinyModule... PR welcome

# test_that("app server", {
#   session <- as.environment(list(
#     sendCustomMessage = function(type, message) {
#       session$lastCustomMessage = list(type = type, message = message)
#     },
#     sendInputMessage = function(inputId, message) {
#       session$lastInputMessage = list(id = inputId, message = message)
#     }
#   ))
# 
#   input <- as.environment(list())
#   output <- as.environment(list())
#   serv <- shinytemplate:::app_server(input = input,
#                                      output = output,
#                                      session = session)
#   expect_is(serv, "shiny.render.function")
# })

