context("golem tests")

test_that("app ui", {
  ui <- app_ui()
  expect_is(ui, "shiny.tag.list")
})