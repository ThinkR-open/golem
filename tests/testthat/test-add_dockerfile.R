context("function add_dockerfile")


test_that("http_proxy", {
  with_dir(pkg, {
    unlink("Dockerfile", force = TRUE)
    output <- testthat::capture_output(add_dockerfile(pkg = pkg, sysreqs = FALSE,http_proxy = "coucou"))
    expect_exists("Dockerfile")
    test <- stringr::str_detect(output, "Dockerfile created at Dockerfile")
    expect_true(test)
     
    expect_true(any(stringr::str_detect(readLines(con = file("Dockerfile")),"http_proxy= 'coucou'")))
    
    remove_files("Dockerfile")
  })
})

test_that("https_proxy", {
  with_dir(pkg, {
    unlink("Dockerfile", force = TRUE)
    output <- testthat::capture_output(add_dockerfile(pkg = pkg, sysreqs = FALSE,https_proxy = "coucou"))
    expect_exists("Dockerfile")
    test <- stringr::str_detect(output, "Dockerfile created at Dockerfile")
    expect_true(test)
     
    expect_true(any(stringr::str_detect(readLines(con = file("Dockerfile")),"https_proxy= 'coucou'")))
    
    remove_files("Dockerfile")
  })
})


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
