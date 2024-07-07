test_that("use_utils_ui works", {
  on.exit(
    unlink(pkg, TRUE, TRUE)
  )
  pkg <- create_dummy_golem()
  withr::with_options(
    c(
      "usethis.quiet" = TRUE
    ),
    {
      use_utils_ui(pkg = pkg)
    }
  )

  expect_exists(
    file.path(
      pkg,
      "R/golem_utils_ui.R"
    )
  )
  remove_file(
    file.path(
      pkg,
      "R/golem_utils_ui.R"
    )
  )
  withr::with_options(
    c(
      "usethis.quiet" = TRUE
    ),
    {
      use_utils_ui(
        pkg = pkg,
        with_test = TRUE
      )
    }
  )
  # Testint that the function is
  # indempotent by running it twice
  withr::with_options(
    c(
      "usethis.quiet" = TRUE
    ),
    {
      use_utils_ui(
        pkg = pkg,
        with_test = TRUE
      )
    }
  )

  expect_exists(
    file.path(
      pkg,
      "R/golem_utils_ui.R"
    )
  )
  expect_exists(
    file.path(
      pkg,
      "tests/testthat/test-golem_utils_ui.R"
    )
  )
  # We test that we can still add the tests even if the utils ui
  # is already there
  remove_file(
    file.path(
      pkg,
      "R/golem_utils_ui.R"
    )
  )
  withr::with_options(
    c(
      "usethis.quiet" = TRUE
    ),
    {
      use_utils_ui(
        pkg = pkg,
        with_test = TRUE
      )
    }
  )
  expect_exists(
    file.path(
      pkg,
      "R/golem_utils_ui.R"
    )
  )
  expect_exists(
    file.path(
      pkg,
      "tests/testthat/test-golem_utils_ui.R"
    )
  )
  unlink(
    pkg,
    TRUE,
    TRUE
  )
})

test_that("use_utils_ui works", {
  on.exit(
    unlink(pkg, TRUE, TRUE)
  )
  pkg <- create_dummy_golem()
  withr::with_options(
    c(
      "usethis.quiet" = TRUE
    ),
    {
      use_utils_server(pkg = pkg)
    }
  )
  expect_exists(
    file.path(
      pkg,
      "R/golem_utils_server.R"
    )
  )
  remove_file(
    file.path(
      pkg,
      "R/golem_utils_server.R"
    )
  )
  withr::with_options(
    c(
      "usethis.quiet" = TRUE
    ),
    {
      use_utils_server(
        pkg = pkg,
        with_test = TRUE
      )
    }
  )
  # Testint that the function is
  # indempotent by running it twice
  withr::with_options(
    c(
      "usethis.quiet" = TRUE
    ),
    {
      use_utils_server(
        pkg = pkg,
        with_test = TRUE
      )
    }
  )

  expect_exists(
    file.path(
      pkg,
      "R/golem_utils_server.R"
    )
  )
  expect_exists(
    file.path(
      pkg,
      "tests/testthat/test-golem_utils_server.R"
    )
  )
  remove_file(
    file.path(
      pkg,
      "R/golem_utils_server.R"
    )
  )
  withr::with_options(
    c(
      "usethis.quiet" = TRUE
    ),
    {
      use_utils_server(
        pkg = pkg,
        with_test = TRUE
      )
    }
  )

  expect_exists(
    file.path(
      pkg,
      "R/golem_utils_server.R"
    )
  )
  expect_exists(
    file.path(
      pkg,
      "tests/testthat/test-golem_utils_server.R"
    )
  )
  unlink(
    pkg,
    TRUE,
    TRUE
  )
})
