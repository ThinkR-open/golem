test_that("config finding works", {
  run_quietly_in_a_dummy_golem({
    config <- guess_where_config(
      path = "."
    )
    expect_exists(
      config
    )
    config <- try_user_config_location(
      pth = "."
    )
    expect_exists(
      config
    )
    expect_null(
      try_user_config_location(tempdir())
    )

    config <- get_current_config(
      path = "."
    )

    expect_exists(
      config
    )
  })
})