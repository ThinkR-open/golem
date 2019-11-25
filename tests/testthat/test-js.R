test_that("active_js", {
  expect_is(activate_js(),'shiny.tag')
})


test_that("invoke_js", {
  expect_error(invoke_js())
})
