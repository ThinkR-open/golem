test_that("add_dockerfiles", {
  skip_if_not_installed("dockerfiler", "0.1.4")
  with_dir(pkg, {
    for (fun in list(
      add_dockerfile,
      add_dockerfile_heroku,
      add_dockerfile_shinyproxy
    )) {
      burn_after_reading(
        "Dockerfile",
        {
          output <- testthat::capture_output(
            fun(pkg = pkg, sysreqs = FALSE, open = FALSE)
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
  with_dir(pkg, {
    for (fun in list(
      add_dockerfile,
      add_dockerfile_heroku,
      add_dockerfile_shinyproxy
    )) {
      burn_after_reading(
        c("Dockerfile1", "Dockerfile2"),
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
      add_rstudioconnect_file,
      add_shinyappsio_file,
      add_shinyserver_file
    )) {
      burn_after_reading(
        "app.R",
        {
          output <- testthat::capture_output(
            fun(
              pkg = pkg,
              open = FALSE
            )
          )
          expect_exists("app.R")
          test <- stringr::str_detect(
            output,
            "ile created at .*/app.R"
          )
          expect_true(test)
        }
      )
    }
  })
})
