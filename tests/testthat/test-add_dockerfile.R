context("function add_dockerfile")

test_that("add_dockerfile", {
  with_dir(pkg, {
    unlink("Dockerfile", force = TRUE)
    output <- testthat::capture_output(add_dockerfile(pkg = pkg, sysreqs = FALSE))
    expect_exists("Dockerfile")
    test <- stringr::str_detect(output, "Dockerfile created at Dockerfile")
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
