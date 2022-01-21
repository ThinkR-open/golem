
### Helpers functions ----------------------------------------------------------

is_properly_populated_golem <- function(path) {

  # All files excepts *.Rproj which changes based on the project name
  expected_files <- c(
    "DESCRIPTION",
    "dev/01_start.R", "dev/02_dev.R", "dev/03_deploy.R", "dev/run_dev.R",
    "inst/app/www/favicon.ico", "inst/golem-config.yml",
    "man/run_app.Rd",
    "NAMESPACE",
    "R/app_config.R", "R/app_server.R", "R/app_ui.R", "R/run_app.R"
  )

  if (rstudioapi::isAvailable()) {
    expected_files <- c(
      expected_files,
      paste0(basename(path), ".Rproj")
    )
  }

  actual_files <- list.files(path, recursive = TRUE)

  identical(sort(expected_files), sort(actual_files))
}


is_with_comments <- function(path) {
  all_r_files <- list.files(
    path = c(
      file.path(path, "dev/"),
      file.path(path, "R/")
    ),
    pattern = "\\.R$",
    full.names = TRUE
  )

  has_comments <- function(r_file) {
    any(grepl("(\\s*#+[^'@].*$| #+[^#].*$)", readLines(r_file)))
  }

  any(vapply(all_r_files, has_comments, logical(1)))
}


### Tests ----------------------------------------------------------------------

## For each call to test_that two scenarios are tested:
# 1 - path is specified as an absolute path => dummy_golem_path
# 2 - path is only the new golem directory => dummy_golem_rstudio_ui_path
# This is similar to what is happening in Rstudio Project Wizard Gui

dummy_dir <- tempfile(pattern = "dummy")
dir.create(dummy_dir)

withr::with_dir(dummy_dir, {

  ## Default
  test_that("golem is created and properly populated", {
    dummy_golem_path <- file.path(dummy_dir, "koko")
    create_golem(dummy_golem_path, open = FALSE)
    expect_true(is_properly_populated_golem(dummy_golem_path))
    expect_true(is_with_comments(dummy_golem_path))
    expect_false(dir.exists(file.path(dummy_golem_path, ".git/")))

    dummy_golem_rstudio_ui_path <- "kokogui"
    create_golem(dummy_golem_rstudio_ui_path, open = FALSE)
    expect_true(is_properly_populated_golem(dummy_golem_rstudio_ui_path))
    expect_true(is_with_comments(dummy_golem_rstudio_ui_path))
    expect_false(dir.exists(file.path(dummy_golem_rstudio_ui_path, ".git/")))


    ## overwrite
    expect_error(
      create_golem(dummy_golem_path, open = FALSE),
      regexp = "^Project directory already exists\\."
    )
    expect_error(
      create_golem(dummy_golem_rstudio_ui_path, open = FALSE),
      regexp = "^Project directory already exists\\."
    )

    create_golem(dummy_golem_path, open = FALSE, overwrite = TRUE)
    expect_true(is_properly_populated_golem(dummy_golem_path))

    create_golem(dummy_golem_rstudio_ui_path, open = FALSE, overwrite = TRUE)
    expect_true(is_properly_populated_golem(dummy_golem_rstudio_ui_path))
  })

  ## open
  test_that("open == TRUE sets wd to project directory in non-interactive mode", {
    dummy_golem_path <- file.path(dummy_dir, "sesame")
    expect_identical(basename(getwd()), basename(dummy_dir))
    create_golem(dummy_golem_path, open = TRUE)
    expect_identical(basename(getwd()), basename(dummy_golem_path))
    # Set wd back to test dir
    setwd(dummy_dir)
  })

  ## with git
  test_that("git is activated", {
    dummy_golem_path <- file.path(dummy_dir, "gigit")
    create_golem(dummy_golem_path, open = FALSE, with_git = TRUE)
    expect_true(is_properly_populated_golem(dummy_golem_path))
    expect_true(is_with_comments(dummy_golem_path))
    expect_true(dir.exists(file.path(dummy_golem_path, ".git/")))

    dummy_golem_rstudio_ui_path <- "gigitgui"
    create_golem(dummy_golem_rstudio_ui_path, open = FALSE, with_git = TRUE)
    expect_true(is_properly_populated_golem(dummy_golem_rstudio_ui_path))
    expect_true(is_with_comments(dummy_golem_rstudio_ui_path))
    expect_true(dir.exists(file.path(dummy_golem_rstudio_ui_path, ".git/")))
  })

  ## without_comments
  test_that("All comments are gone", {
    dummy_golem_path <- file.path(dummy_dir, "withooutcomments")
    create_golem(dummy_golem_path, open = FALSE, without_comments = TRUE)

    expect_true(is_properly_populated_golem(dummy_golem_path))
    expect_false(is_with_comments(dummy_golem_path))
    expect_false(dir.exists(file.path(dummy_golem_path, ".git/")))

    dummy_golem_rstudio_ui_path <- "withooutcommentsgui"
    create_golem(dummy_golem_rstudio_ui_path, open = FALSE, without_comments = TRUE)
    expect_true(is_properly_populated_golem(dummy_golem_rstudio_ui_path))
    expect_false(is_with_comments(dummy_golem_rstudio_ui_path))
    expect_false(dir.exists(file.path(dummy_golem_rstudio_ui_path, ".git/")))
  })


  ## check_name
  unsyntactic_pkgname <- "2cou_cou"

  test_that("Unsyntactic package name throws an error", {
    dummy_golem_path <- file.path(dummy_dir, unsyntactic_pkgname)
    expect_error(
      create_golem(dummy_golem_path, open = FALSE)
    )

    # Rstudio UI scenario
    expect_error(
      create_golem(unsyntactic_pkgname, open = FALSE)
    )
  })

  test_that("Tolerates unsyntactic package", {
    dummy_golem_path <- file.path(dummy_dir, unsyntactic_pkgname)
    create_golem(dummy_golem_path, open = FALSE, check_name = FALSE)
    expect_true(is_properly_populated_golem(dummy_golem_path))
    unlink(unsyntactic_pkgname, recursive = TRUE)

    # Rstudio UI scenario
    create_golem(unsyntactic_pkgname, open = FALSE, check_name = FALSE)
    expect_true(is_properly_populated_golem(unsyntactic_pkgname))
  })

  ## projects_hook
  no_dev <- function(path, package_name, ...) {
    fs::dir_delete("dev")
  }
  test_that("Example project hook works", {
    dummy_golem_path <- file.path(dummy_dir, "examplehook")
    create_golem(dummy_golem_path, open = FALSE, project_hook = no_dev)
    expect_false(is_properly_populated_golem(dummy_golem_path))
    expect_false(dir.exists(file.path(dummy_golem_path, "dev/")))

    dummy_golem_rstudio_ui_path <- "examplehookgui"
    create_golem(dummy_golem_rstudio_ui_path, open = FALSE, project_hook = no_dev)
    expect_false(is_properly_populated_golem(dummy_golem_rstudio_ui_path))
    expect_false(dir.exists(file.path(dummy_golem_rstudio_ui_path, "dev/")))
  })

  test_that("Error is thrown if project hook is ill-specified in Rstudio GUI", {
    expect_error(
      create_golem_gui(path = "dummygolem", project_hook = "misspecifedhook")
    )
  })
})


unlink(dummy_dir, recursive = FALSE)