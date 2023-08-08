test_that("is_golem works", {
  expect_true(
    is_golem(pkg)
  )
  expect_false(
    is_golem(tempdir())
  )
})
