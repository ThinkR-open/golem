is_properly_populated_golem <- function(path) {
  # All files excepts *.Rproj which changes based on the project name
  expected_files <- list.files(
    golem_sys(
      "shinyexample"
    ),
    recursive = TRUE
  )
  expected_files <- expected_files[!grepl(
    "Rproj",
    expected_files
  )]

  expected_files <- expected_files[!grepl(
    "REMOVEME.Rbuildignore",
    expected_files
  )]

  actual_files <- list.files(path, recursive = TRUE)

  identical(
    sort(expected_files),
    sort(actual_files)
  )
}

test_that("create_golem works", {{ dir <- tempfile(pattern = "golemcreategolem")
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      dir <- create_golem(
        dir,
        open = FALSE,
        package_name = "testpkg"
      )
    }
  )
  expect_true(
    is_properly_populated_golem(
      dir
    )
  )
  unlink(
    dir,
    TRUE,
    TRUE
  ) }})

test_that("create_golem_gui works", {
  testthat::with_mocked_bindings(
    create_golem = function(...) {
      return(TRUE)
    },
    {
      expect_error(
        create_golem_gui()
      )
      expect_true(
        create_golem_gui(
          project_hook = "golem::project_hook"
        )
      )
    }
  )
})
