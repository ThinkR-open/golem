context("golem tests")

test_that("app ui", {
  ui <- app_ui()
  expect_is(ui, "shiny.tag.list")
})

test_that("app server", {
  server <- app_server
  expect_is(server, "function")
})