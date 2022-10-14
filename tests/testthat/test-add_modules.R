test_that("add_module", {
  with_dir(pkg, {
    remove_file("R/mod_test.R")
    add_module(
      "test",
      open = FALSE,
      pkg = pkg,
      fct = "ftest",
      utils = "utest"
    )
    expect_true(file.exists("R/mod_test.R"))
    expect_true(file.exists("R/mod_test_fct_ftest.R"))
    expect_true(file.exists("R/mod_test_utils_utest.R"))
    script <- list.files("R", pattern = "mod_test")
    lapply(tools::file_ext(script), function(x) testthat::expect_equal(x, "R"))
    ## Test message of function
    remove_file("R/mod_output.R")
    withr::with_options(
      c("golem.quiet" =  FALSE),{
      output <- testthat::capture_output(add_module("output", open = FALSE))
    })
    expect_true(
      stringr::str_detect(output, "File created at R/mod_output.R")
    )

    # Check content is not over-added
    lmod <- length(readLines("R/mod_output.R"))
    add_module("output", open = FALSE)
    expect_equal(
      lmod,
      length(readLines("R/mod_output.R"))
    )

    remove_file("R/mod_test.R")

    # Test ext
    add_module(
      "test2.R",
      open = FALSE,
      pkg = pkg,
      fct = "ftest",
      utils = "utest"
    )
    expect_true(file.exists("R/mod_test2.R"))
    expect_true(file.exists("R/mod_test2_fct_ftest.R"))
    expect_true(file.exists("R/mod_test2_utils_utest.R"))
    remove_file("R/mod_test2.R")
    remove_file("R/mod_test2_fct_ftest.R")
    remove_file("R/mod_test2_utils_utest.R")
  })
})
