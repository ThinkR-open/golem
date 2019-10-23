context("function rstudio products")

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
