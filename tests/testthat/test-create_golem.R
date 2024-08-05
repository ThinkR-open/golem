test_that("create_golem works", {
  res <- perform_inside_a_new_golem(function() {
    return(getwd())
  })
  expect_exists(
    res
  )
  expect_exists(
    file.path(
      res,
      "DESCRIPTION"
    )
  )
  expect_exists(
    file.path(
      res,
      "R"
    )
  )

  expect_exists(
    file.path(
      res,
      "inst"
    )
  )
  unlink(
    res,
    TRUE,
    TRUE
  )
})
