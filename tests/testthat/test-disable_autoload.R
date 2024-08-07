test_that("disable_autoload works", {
  run_quietly_in_a_dummy_golem({
    disable_autoload()
    expect_exists(
      file.path(
        "R",
        "_disable_autoload.R"
      )
    )
  })
})
