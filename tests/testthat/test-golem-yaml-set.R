test_that(
  "set_golem_funs works",
  {
    run_quietly_in_a_dummy_golem({
      set_golem_wd(
        golem_wd <- tempdir(),
        pkg = ".",
        talkative = FALSE
      )
      set_golem_name(
        golem_name <- "testpkg",
        pkg = ".",
        talkative = FALSE,
        old_name = "shinyexample"
      )
      set_golem_name_tests(
        "shinyexample",
        "testpkg",
        path = "."
      )
      set_golem_name_vignettes(
        "testpkg",
        "pif",
        path = "."
      )
      set_golem_version(
        version = "0.0.0.912",
        pkg = ".",
        talkative = FALSE
      )
      expect_equal(
        normalizePath(
          get_golem_wd(pkg = ".")
        ),
        normalizePath(
          golem_wd
        )
      )
      expect_equal(
        get_golem_name(pkg = "."),
        "testpkg"
      )
      expect_true(
        grepl(
          "testpkg",
          paste0(
            readLines(
              "tests/testthat.R"
            ),
            collapse = ""
          )
        )
      )
      expect_true(
        grepl(
          "pif",
          paste0(
            readLines(
              "vignettes/pif.Rmd"
            ),
            collapse = ""
          )
        )
      )
      expect_equal(
        get_golem_version(pkg = "."),
        "0.0.0.912"
      )
    })
  }
)
