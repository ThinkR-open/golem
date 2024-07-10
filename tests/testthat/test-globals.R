test_that("set_golem_global function sets global variables correctly", {
  set_golem_global("test_var", "test_value")
  expect_equal(.golem_globals$test_var, "test_value")
  rm("test_var", envir = .golem_globals)

  set_golem_global("another_var", 123)
  expect_equal(.golem_globals$another_var, 123)
  rm("another_var", envir = .golem_globals)

})
