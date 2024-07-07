test_that("use_utils_ui works", {
  on.exit(
    unlink(pkg, TRUE, TRUE)
  )
  pkg <- file.path(
    tempdir(),
    "dummygolem"
  )


  dir.create(
    file.path(
      pkg,
      "R"
    ),
    recursive = TRUE
  )
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
  withr::with_dir(pkg, {
    dir.create(
      "tests/testthat/",
      recursive = TRUE
    )
  })
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
  pkg <- file.path(
    tempdir(),
    "dummygolem"
  )
  dir.create(
    file.path(
      pkg,
      "R"
    ),
    recursive = TRUE
  )
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
  withr::with_dir(pkg, {
    dir.create(
      "tests/testthat/",
      recursive = TRUE
    )
  })
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
