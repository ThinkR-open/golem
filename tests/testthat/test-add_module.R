context("function add_module")


test_that("add_module", {
  with_dir(pkg, {
    remove_file("R/mod_test.R")
    add_module("test", open = FALSE, pkg = pkg,  fct = "ftest", utils = "utest")
    expect_true(file.exists("R/mod_test.R"))
    expect_true(file.exists("R/mod_test_fct_ftest.R"))
    expect_true(file.exists("R/mod_test_utils_utest.R"))
    script <- list.files("R", pattern = "mod_test")
    lapply(tools::file_ext(script), function(x) testthat::expect_equal(x, "R"))
    ## Test message of function
    if (file.exists("R/mod_output.R")) {
      file.remove("R/mod_output.R")
    }
    output <- testthat::capture_output(add_module("output", open = FALSE))
    expect_true(
      stringr::str_detect(output, "File created at R/mod_output.R")
    )
    remove_file("R/mod_test.R")
    
    # Test ext 
    add_module("test.R", open = FALSE, pkg = pkg,  fct = "ftest", utils = "utest")
    expect_true(file.exists("R/mod_test.R"))
    expect_true(file.exists("R/mod_test_fct_ftest.R"))
    expect_true(file.exists("R/mod_test_utils_utest.R"))
    remove_file("R/mod_test.R")
    remove_file("R/mod_test_fct_ftest.R")
    remove_file("R/mod_test_utils_utest.R")
    
  })
})
