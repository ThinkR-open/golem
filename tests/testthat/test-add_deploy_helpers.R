context("function add_dockerfile")

test_that("add_dockerfile", {
  with_dir(pkg, {
    unlink("Dockerfile", force = TRUE)
    output <- testthat::capture_output(
      add_dockerfile(pkg = pkg, sysreqs = FALSE)
    )
    expect_exists("Dockerfile")
    test <- stringr::str_detect(
      output, 
      "Dockerfile created at Dockerfile"
    )
    expect_true(test)
    remove_files("Dockerfile")
  })
})
# 
# 
test_that("add_dockerfile_heroku", {
  with_dir(pkg, {
    unlink("Dockerfile", force = TRUE)
    output <- testthat::capture_output(add_dockerfile_heroku(pkg = pkg, sysreqs = FALSE))
    expect_exists("Dockerfile")
    test <- stringr::str_detect(output, "Dockerfile created at Dockerfile")
    expect_true(test)
    remove_files("Dockerfile")
  })
})

test_that("add_dockerfile_shinyproxy", {
  with_dir(pkg, {
    unlink("Dockerfile", force = TRUE)
    output <- testthat::capture_output(add_dockerfile_shinyproxy(pkg = pkg, sysreqs = FALSE))
    expect_exists("Dockerfile")
    test <- stringr::str_detect(output, "Dockerfile created at Dockerfile")
    remove_files("Dockerfile")
  })
})

context("function add_rstudioconnect_file")

test_that("add_rstudioconnect_file", {
  with_dir(pkg, {
    remove_file("app.R")
    output <- testthat::capture_output(add_rstudioconnect_file(pkg = pkg, open = FALSE))
    expect_true(file.exists("app.R"))
    test <-
      stringr::str_detect(output, "ile created at .*/app.R")
    expect_true(test)
    remove_file("app.R")
  })
  with_dir(pkg, {
    remove_file("app.R")
    output <- testthat::capture_output(add_shinyappsio_file(pkg = pkg,open = FALSE))
    expect_true(file.exists("app.R"))
    test <-
      stringr::str_detect(output, "ile created at .*/app.R")
    expect_true(test)
    remove_file("app.R")
  })
  with_dir(pkg, {
    remove_file("app.R")
    output <- testthat::capture_output(add_shinyserver_file(pkg = pkg,open = FALSE))
    expect_true(file.exists("app.R"))
    test <-
      stringr::str_detect(output, "ile created at .*/app.R")
    expect_true(test)
    remove_file("app.R")
  })
})