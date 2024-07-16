test_that("add_dockerfiles", {
  skip_on_cran()
  skip_if_not_installed("renv")
  skip_if_not_installed("dockerfiler", "0.2.0")
  skip_if_not_installed("attachment", "0.2.5")

  with_dir(pkg, {
    for (fun in list(
      add_dockerfile,
      add_dockerfile_heroku,
      add_dockerfile_shinyproxy
    )) {
      burn_after_reading(
        "Dockerfile",
        {
          withr::with_options(
            c("golem.quiet" = FALSE),
            {
              output <- testthat::capture_output(
                fun(pkg = pkg, sysreqs = FALSE, open = FALSE)
              )
            }
          )

          expect_exists("Dockerfile")
          test <- stringr::str_detect(
            output,
            "Dockerfile created at Dockerfile"
          )
          expect_true(test)
        }
      )
    }
  })
})
test_that("add_dockerfiles repos variation", {
  skip_if_not_installed("dockerfiler", "0.1.4")
  skip_on_cran()
  with_dir(pkg, {
    for (fun in list(
      add_dockerfile,
      add_dockerfile_heroku,
      add_dockerfile_shinyproxy
    )) {
      burn_after_reading(
        c("Dockerfile1", "Dockerfile2"),
        {
          withr::with_options(
            c("golem.quiet" = FALSE),
            {
              output1 <- testthat::capture_output(
                fun(
                  pkg = pkg,
                  sysreqs = FALSE,
                  open = FALSE,
                  repos = "https://cran.rstudio.com/",
                  output = "Dockerfile1"
                )
              )
              output2 <- testthat::capture_output(
                fun(
                  pkg = pkg,
                  sysreqs = FALSE,
                  open = FALSE,
                  repos = c("https://cran.rstudio.com/"),
                  output = "Dockerfile2"
                )
              )
              expect_exists("Dockerfile1")
              expect_exists("Dockerfile2")
            }
          )

          test1 <- stringr::str_detect(
            output1,
            "Dockerfile created at Dockerfile"
          )
          expect_true(test1)
          test2 <- stringr::str_detect(
            output2,
            "Dockerfile created at Dockerfile"
          )
          expect_true(test2)
          expect_true(
            all(
              readLines(con = "Dockerfile1") == readLines(con = "Dockerfile2")
            )
          )
        }
      )
    }
  })
})


test_that("add_rstudio_files", {
  with_dir(pkg, {
    for (fun in list(
      add_positconnect_file,
      add_shinyappsio_file,
      add_shinyserver_file
    )) {
      burn_after_reading(
        "app.R",
        {
          withr::with_options(
            c("golem.quiet" = FALSE),
            {
              output <- testthat::capture_output(
                fun(
                  pkg = pkg,
                  open = FALSE
                )
              )
            }
          )
          expect_exists("app.R")
          test <- stringr::str_detect(
            output,
            "File created at .*/app.R"
          )
          expect_true(test)
        }
      )
    }
  })
})

test_that("add_rscignore_file", {
  with_dir(
    pkg,
    {
      burn_after_reading(
        ".rscignore",
        {
          withr::with_options(
            c("golem.quiet" = FALSE),
            {
              output <- testthat::capture_output(
                add_rscignore_file(
                  pkg = pkg,
                  open = FALSE
                )
              )
            }
          )
          expect_exists(".rscignore")
          test <- stringr::str_detect(
            output,
            "File created at .*/.rscignore"
          )
          expect_true(test)
        }
      )
    }
  )
})
