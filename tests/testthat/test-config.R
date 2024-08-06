test_that("guess_where_config works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
     config <-  guess_where_config(
        path = dummy_golem
      )
    }
  )
  expect_exists(
    config
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("try_user_config_location works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      config <- try_user_config_location(
        pth = dummy_golem
      )
    }
  )
  expect_exists(
    config
  )
  expect_null(
    try_user_config_location(tempdir())
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("get_current_config works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      config <- get_current_config(
        path = dummy_golem
      )
    }
  )
  expect_exists(
    config
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
