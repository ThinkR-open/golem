
test_that("use_module_test", {
  with_dir(pkg, {
    add_module("mod1", open = FALSE, pkg = pkg)
    add_module("mod2", open = FALSE, pkg = pkg)

    # Proper module name
    use_module_test("mod1", pkg = pkg, open = FALSE)
    expect_true(file.exists("tests/testthat/test-mod_mod1.R"))

    # Non existing module
    expect_error(
      use_module_test("phatom", pkg = pkg, open = FALSE),
      regex = "The module 'phatom' does not exist"
    )

    # Module file passed instead of name
    use_module_test("mod_mod2.R", pkg = pkg, open = FALSE)
    expect_true(file.exists("tests/testthat/test-mod_mod2.R"))

    lapply(
      list.files(pattern = "(^|^test-)mod_mod\\d.R$", recursive = TRUE),
      remove_file
    )
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
  expect_equal(
    mod_remove("mod_mod1"),
    "mod1"
  )
})