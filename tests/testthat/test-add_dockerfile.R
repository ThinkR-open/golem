context("function add_dockerfile")

test_that("add_dockerfile", {
  with_dir(pkg, {
    remove_file("Dockerfile")
    output <- testthat::capture_output(add_dockerfile(pkg = pkg))
    expect_true(file.exists("Dockerfile"))
    test <-
      stringr::str_detect(output, "Dockerfile created at Dockerfile")
    expect_true(test)
    remove_file("Dockerfile")
  })
})


test_that("add_dockerfile_heroku", {
  with_dir(pkg, {
    remove_file("Dockerfile")
    output <- testthat::capture_output(add_dockerfile_heroku(pkg = pkg))
    expect_true(file.exists("Dockerfile"))
    test <-
      stringr::str_detect(output, "Dockerfile created at Dockerfile")
    expect_true(test)
    remove_file("Dockerfile")
  })
})

test_that("add_dockerfile_shinyproxy", {
  with_dir(pkg, {
    remove_file("Dockerfile")
    output <- testthat::capture_output(add_dockerfile_shinyproxy(pkg = pkg))
    expect_true(file.exists("Dockerfile"))
    test <-
      stringr::str_detect(output, "Dockerfile created at Dockerfile")
    expect_true(test)
    remove_file("Dockerfile")
  })
})
