test_that("talk_once", {
  once_sum <- talk_once(sum, "Hey there")
  expect_output(
    once_sum(),
    "Hey there"
  )
  expect_silent(
    once_sum()
  )
})

test_that("add_dockerfile works", {
  skip_on_cran()
  skip_if_not_installed("dockerfiler", "0.2.3")
  dummy_golem <- create_dummy_golem()

  testthat::with_mocked_bindings(
    dockerfiler_dock_from_desc = function(...) {
      return(readRDS("Dockerfile.RDS"))
    },
    usethis_use_build_ignore = function(...) {
      return(NULL)
    },
    {
      withr::with_options(
        c("usethis.quiet" = TRUE),
        {
          dockerfile_with_add_dockerfile <- add_dockerfile(
            path = file.path(
              dummy_golem,
              "DESCRIPTION"
            ),
            golem_wd = dummy_golem,
            output = file.path(
              dummy_golem,
              "Dockerfile_add_dockerfile"
            ),
            open = FALSE
          )
          dockerfile_with_add_dockerfile_shinyproxy <- add_dockerfile_shinyproxy(
            path = file.path(
              dummy_golem,
              "DESCRIPTION"
            ),
            golem_wd = dummy_golem,
            output = file.path(
              dummy_golem,
              "Dockerfile_add_dockerfile_shinyproxy"
            ),
            open = FALSE
          )

          dockerfile_with_add_dockerfile_heroku <- add_dockerfile_heroku(
            path = file.path(
              dummy_golem,
              "DESCRIPTION"
            ),
            golem_wd = dummy_golem,
            ,
            output = file.path(
              dummy_golem,
              "Dockerfile_add_dockerfile_heroku"
            ),
            open = FALSE
          )
        }
      )
    }
  )
  expect_true(
    inherits(
      dockerfile_with_add_dockerfile,
      "Dockerfile"
    )
  )
  expect_true(
    inherits(
      dockerfile_with_add_dockerfile_shinyproxy,
      "Dockerfile"
    )
  )
  expect_true(
    inherits(
      dockerfile_with_add_dockerfile_heroku,
      "Dockerfile"
    )
  )
  unlink(dummy_golem, TRUE, TRUE)
})
