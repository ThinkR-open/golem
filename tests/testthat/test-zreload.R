context("tests reload")

test_that("test detach_all_attached",{
  env <- environment()
  test <-  eval(golem::detach_all_attached(),envir = env)
  ok <- all(purrr::map_lgl(test,~ is.null(.x)))
  expect_true(test)
  
})
