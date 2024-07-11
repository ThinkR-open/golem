test_that("disable_autoload works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE), {
      disable_autoload(
        dummy_golem
      )
    }
  )
  expect_true(
    file.exists(
      file.path(
        dummy_golem,
        "R",
        "_disable_autoload.R"
      )
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
