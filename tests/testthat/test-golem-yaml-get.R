test_that("get_golem_things works", {
  dummy_golem <- create_dummy_golem()
  expect_equal(
    get_golem_things(
      "golem_version",
      path = dummy_golem
    ),
    "0.0.0.9000"
  )
  expect_equal(
    get_golem_wd(
      pkg = dummy_golem
    ),
    getwd()
  )
  expect_equal(
    get_golem_name(
      pkg = dummy_golem
    ),
    "shinyexample"
  )
  expect_equal(
    get_golem_version(
      pkg = dummy_golem
    ),
    "0.0.0.9000"
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
