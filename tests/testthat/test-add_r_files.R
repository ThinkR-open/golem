test_that("add_fct and add_utils", {
  with_dir(pkg, {
    util_file <- "R/utils_ui.R"
    fct_file <- "R/fct_ui.R"
    mod <- "R/mod_plop.R"
    remove_file(util_file)
    remove_file(fct_file)
    remove_file(mod)
    add_fct("ui", pkg = pkg, open = FALSE, with_test = TRUE)
    add_utils("ui", pkg = pkg, open = FALSE, with_test = TRUE)

    expect_error(
      add_fct(c("a", "b")),
    )
    expect_error(
      add_utils(c("a", "b")),
    )

    expect_true(file.exists(util_file))
    expect_true(file.exists(fct_file))
    expect_true(file.exists("tests/testthat/test-utils_ui.R"))
    expect_true(file.exists("tests/testthat/test-fct_ui.R"))

    rand <- rand_name()
    add_module(rand, pkg = pkg, open = FALSE)
    add_fct("ui", rand, pkg = pkg, open = FALSE)
    add_utils("ui", rand, pkg = pkg, open = FALSE)
    expect_true(file.exists(sprintf("R/mod_%s_fct_ui.R", rand)))
    expect_true(file.exists(sprintf("R/mod_%s_utils_ui.R", rand)))

    expect_error(
      add_module(c("a", "b")),
    )

    # If module not yet created an error is thrown
    expect_error(
      add_fct("ui", module = "notyetcreated", pkg = pkg, open = FALSE),
      regexp = "The module 'notyetcreated' does not exist."
    )
    expect_error(
      add_utils("ui", module = "notyetcreated", pkg = pkg, open = FALSE),
      regexp = "The module 'notyetcreated' does not exist."
    )

    # Module file passed instead of name
    mod_ploup_file <- "R/mod_ploup.R"
    remove_file(mod_ploup_file)
    add_module("ploup", pkg = pkg, open = FALSE)
    add_fct("fct", module = basename(mod_ploup_file), pkg = pkg, open = FALSE)
    add_utils("utils", module = basename(mod_ploup_file), pkg = pkg, open = FALSE)
    expect_true(file.exists("R/mod_ploup_fct_fct.R"))
    expect_true(file.exists("R/mod_ploup_utils_utils.R"))


    remove_file(mod_ploup_file)
    remove_file("R/mod_ploup_fct_fct.R")
    remove_file("R/mod_ploup_utils_utils.R")

    remove_file(sprintf("R/mod_%s.R", rand))
    remove_file(sprintf("R/mod_%s_fct_ui.R", rand))
    remove_file(sprintf("R/mod_%s_utils_ui.R", rand))
  })
})
