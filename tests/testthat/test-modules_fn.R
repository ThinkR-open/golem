test_that(
  "add_module works",
  {
    run_quietly_in_a_dummy_golem({
      add_module(
        "mod1",
        open = FALSE,
        golem_wd = ".",
        with_test = TRUE
      )
      expect_exists(
        file.path(
          "R",
          "mod_mod1.R"
        )
      )
      expect_exists(
        file.path(
          "tests",
          "testthat",
          "test-mod_mod1.R"
        )
      )
    })
  }
)

test_that("use_module_test", {
  run_quietly_in_a_dummy_golem({
    add_module(
      "mod1",
      open = FALSE,
      pkg = ".",
      with_test = FALSE
    )
    use_module_test(
      "mod1",
      pkg = ".",
      open = FALSE
    )
    expect_exists(
      file.path(
        "tests",
        "testthat",
        "test-mod_mod1.R"
      )
    )
    expect_error(
      use_module_test(
        "phatom",
        pkg = ".",
        open = FALSE
      ),
      regex = "The module 'phatom' does not exist"
    )
  })
})

test_that(
  "module_template works",
  {
    module_template(
      "mod1",
      path <- tempfile(),
      export = TRUE,
      open = FALSE
    )
    on.exit({
      unlink(
        path,
        recursive = TRUE,
        force = TRUE
      )
    })
    mod_read <- paste(
      readLines(
        path
      ),
      collapse = " "
    )
    expect_true(
      grepl(
        "mod_mod1",
        mod_read
      )
    )
    expect_true(
      grepl(
        "@export",
        mod_read
      )
    )
  }
)


test_that("mod_remove work", {
  expect_equal(
    mod_remove("mod_a"),
    "a"
  )
  expect_equal(
    mod_remove("mod__moda"),
    "_moda"
  )
  expect_equal(
    mod_remove("a_mod_a"),
    "a_mod_a"
  )
  expect_equal(
    mod_remove("mod_mod1"),
    "mod1"
  )
})
