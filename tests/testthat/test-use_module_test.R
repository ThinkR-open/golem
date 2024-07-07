test_that("use_module_test", {
  res <- perform_inside_a_new_golem(function() {
    add_module("mod1", open = FALSE, pkg = ".")
    add_module("mod2", open = FALSE, pkg = ".")

    # Proper module name
    use_module_test("mod1", pkg = ".", open = FALSE)
    # Module file passed instead of name
    use_module_test("mod_mod2.R", pkg = ".", open = FALSE)

    # Non existing module
    testthat::expect_error(
      use_module_test("phatom", pkg = ".", open = FALSE),
      regex = "The module 'phatom' does not exist"
    )
    return(
      c(
        file.exists("tests/testthat/test-mod_mod1.R"),
        file.exists("tests/testthat/test-mod_mod2.R")
      )
    )
  })
  expect_true(
    all(res)
  )
})

test_that("mod_remove work", {
  expect_equal(
    mod_remove("mod_a"),
    "a"
  )
  expect_equal(
    mod_remove("mod__moda"),
    "_moda"
  )
  expect_equal(
    mod_remove("a_mod_a"),
    "a_mod_a"
  )
  expect_equal(
    mod_remove("mod_mod1"),
    "mod1"
  )
})
