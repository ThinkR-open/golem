context("golem tests")

library(golem)

test_that("app ui", {
  ui <- app_ui()
  expect_shinytaglist(ui)
})

test_that("app server", {
  server <- app_server
  expect_is(server, "function")
})

# Configure this test to fit your need
test_that(
  "app launches",{
    skip_if_not(interactive())
    expect_running(sleep = 5)
  }
)