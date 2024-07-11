test_that("add_fct and add_utils", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_fct(
        "ui",
        pkg = dummy_golem,
        open = FALSE,
        with_test = TRUE
      )
      add_utils(
        "ui",
        pkg = dummy_golem,
        open = FALSE,
        with_test = TRUE
      )

      add_module(
        "rand",
        pkg = dummy_golem,
        open = FALSE,
        with_test = TRUE
      )
      add_fct(
        "ui",
        "rand",
        pkg = dummy_golem,
        open = FALSE
      )
      add_utils(
        "ui",
        "rand",
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )

  expect_exists(
    file.path(
      dummy_golem,
      "R",
      "fct_ui.R"
    )
  )
  expect_exists(
    file.path(
      dummy_golem,
      "R",
      "utils_ui.R"
    )
  )
  expect_exists(
    file.path(
      dummy_golem,
      "tests/testthat/test-utils_ui.R"
    )
  )
  expect_exists(
    file.path(
      dummy_golem,
      "tests/testthat/test-fct_ui.R"
    )
  )

  expect_error(
    add_fct(c("a", "b")),
  )
  expect_error(
    add_utils(c("a", "b")),
  )

  expect_error(
    add_module(c("a", "b")),
  )

  # If module not yet created an error is thrown
  expect_error(
    add_fct(
      "ui",
      module = "notyetcreated",
      pkg = dummy_golem,
      open = FALSE
    ),
    regexp = "The module 'notyetcreated' does not exist."
  )
  expect_error(
    add_utils(
      "ui",
      module = "notyetcreated",
      pkg = dummy_golem,
      open = FALSE
    ),
    regexp = "The module 'notyetcreated' does not exist."
  )

  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
