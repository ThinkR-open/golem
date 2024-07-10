test_that(
  "add_module works",
  {
    dummy_golem <- create_dummy_golem()
    withr::with_options(
      c("usethis.quiet" = TRUE),
      {
        add_module(
          "mod1",
          open = FALSE,
          pkg = dummy_golem,
          with_test = TRUE
        )
      }
    )
    expect_exists(
      file.path(
        dummy_golem,
        "R",
        "mod_mod1.R"
      )
    )
    expect_exists(
      file.path(
        dummy_golem,
        "tests",
        "testthat",
        "test-mod_mod1.R"
      )
    )
    unlink(
      dummy_golem,
      TRUE,
      TRUE
    )
  }
)

test_that("use_module_test", {
  dummy_golem <- create_dummy_golem()
  on.exit({
    unlink(dummy_golem, TRUE, TRUE)
  })
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_module(
        "mod1",
        open = FALSE,
        pkg = dummy_golem,
        with_test = FALSE
      )
      use_module_test(
        "mod1",
        pkg = dummy_golem,
        open = FALSE
      )
      expect_exists(
        file.path(
          dummy_golem,
          "tests",
          "testthat",
          "test-mod_mod1.R"
        )
      )
      expect_error(
        use_module_test(
          "phatom",
          pkg = dummy_golem,
          open = FALSE
        ),
        regex = "The module 'phatom' does not exist"
      )
    }
  )
})

test_that("mod_remove work", {
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
