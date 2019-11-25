test_that("add_dockerfiles", {
  with_dir(pkg, {
    
    for (fun in list(
      add_dockerfile, 
      add_dockerfile_heroku, 
      add_dockerfile_shinyproxy
    )){
      burn_after_reading(
        "Dockerfile", {
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

test_that("add_rstudio_files", {
  with_dir(pkg, {
    
    for (fun in list(
      add_rstudioconnect_file, 
      add_shinyappsio_file, 
      add_shinyserver_file
    )){
      burn_after_reading(
        "app.R", {
          output <- testthat::capture_output(
            fun(pkg = pkg, open = FALSE)
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