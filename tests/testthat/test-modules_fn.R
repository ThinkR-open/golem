
test_that("use_module_test", {
  with_dir(pkg, {
    remove_file("R/mod_mod1.R")
    add_module("mod1", open = FALSE, pkg = pkg)
    
    use_module_test("mod1", pkg = pkg, open = FALSE)
    expect_true(file.exists("tests/testthat/test-mod_mod1.R"))
    
    expect_error(
      use_module_test("mod2", pkg = pkg, open = FALSE),
      regex = "^The mentionned 'module' does not yet exist.$"
    )
    
    remove_file("R/mod_mod1.R")
    remove_file("tests/testthat/test-mod_mod1.R")
  })
})

test_that("module_fn work", {
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
})
