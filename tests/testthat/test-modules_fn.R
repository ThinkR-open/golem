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
