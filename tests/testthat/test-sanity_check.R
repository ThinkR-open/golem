test_that("sanity_check works", {
  dummy_golem <- create_dummy_golem()
  write(
    "browser()",
    file.path(
      dummy_golem,
      "R/app.R"
    ),
    append = TRUE
  )
  write(
    "#TODO",
    file.path(
      dummy_golem,
      "R/app.R"
    ),
    append = TRUE
  )
  write(
    "#TOFIX",
    file.path(
      dummy_golem,
      "R/app.R"
    ),
    append = TRUE
  )
  write(
    "#BUG",
    file.path(
      dummy_golem,
      "R/app.R"
    ),
    append = TRUE
  )
  write(
    "# TODO",
    file.path(
      dummy_golem,
      "R/app.R"
    ),
    append = TRUE
  )
  write(
    "# TOFIX",
    file.path(
      dummy_golem,
      "R/app.R"
    ),
    append = TRUE
  )
  write(
    "# BUG",
    file.path(
      dummy_golem,
      "R/app.R"
    ),
    append = TRUE
  )
  res <- sanity_check(
    dummy_golem
  )
  expect_true(
    nrow(res) == 7
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
