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

expect_running <- function(sleep){
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()
  x <- processx::process$new(
    "R", 
    c(
      "-e", 
      "pkgload::load_all(here::here());run_app()"
    )
  )
  Sys.sleep(sleep)
  expect_true(x$is_alive())
  x$kill()
}

# Configure this test to fit your need
test_that(
  "app launches",{
    skip_if_not(interactive())
    expect_running(sleep = 5)
  }
)