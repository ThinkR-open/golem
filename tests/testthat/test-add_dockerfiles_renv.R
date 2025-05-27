test_that("add_dockerfile_with_renv_ works", {
  skip_on_cran()
  skip_if_not_installed("renv")
  skip_if_not_installed("dockerfiler", "0.2.3")
  skip_if_not_installed("attachment", "0.2.5")
  dummy_golem <- create_dummy_golem()
  testthat::with_mocked_bindings(
    attachment_create_renv_for_prod = function(...) {
      return(normalizePath("renv.lock.prod"))
    },
    dockerfiler_dock_from_renv = function(...) {
      return(
        readRDS(
          "dockerfiler_dock_from_renv_socle.RDS"
        )
      )
    },
    {
      withr::with_options(
        c("usethis.quiet" = TRUE),
        {
          dockerfile_with_renv <- add_dockerfile_with_renv_(
            golem_wd = dummy_golem,
            lockfile = "renv.lock.prod",
            pkgbuild_quiet = TRUE
          )

          dockerfile_with_renv_output <- add_dockerfile_with_renv(
            golem_wd = dummy_golem,
            lockfile = "renv.lock.prod",
            open = FALSE
          )
          dockerfile_with_renv_shinyproxy_output <- add_dockerfile_with_renv_shinyproxy(
            golem_wd = dummy_golem,
            lockfile = "renv.lock.prod",
            open = FALSE
          )
          dockerfile_with_renv_heroku_output <- add_dockerfile_with_renv_heroku(
            golem_wd = dummy_golem,
            lockfile = "renv.lock.prod",
            open = FALSE
          )
        }
      )
    }
  )
  expect_true(
    inherits(
      dockerfile_with_renv,
      "Dockerfile"
    )
  )
  expect_true(
    file.exists(
      dockerfile_with_renv_output
    )
  )
  expect_true(
    file.exists(
      dockerfile_with_renv_shinyproxy_output
    )
  )
  expect_true(
    file.exists(
      dockerfile_with_renv_heroku_output
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
