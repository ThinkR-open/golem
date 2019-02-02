context("Application")

test_that("app ui", {
  ui <- shinyexample:::app_ui()
  expect_is(ui, "shiny.tag.list")
})

