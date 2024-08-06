test_that(
  "set_golem_funs works",
  {
    dummy_golem <- create_dummy_golem()
    withr::with_options(
      c("usethis.quiet" = TRUE),{
        set_golem_wd(
          golem_wd <- tempdir(),
          pkg = dummy_golem,
          talkative = FALSE
        )
        set_golem_name(
          golem_name <- "testpkg",
          pkg = dummy_golem,
          talkative = FALSE,
          old_name = "shinyexample"
        )
        set_golem_name_tests(
          "shinyexample",
          "testpkg",
          path = dummy_golem
        )
        set_golem_name_vignettes(
          "testpkg",
          "pif",
          path = dummy_golem
        )
        set_golem_version(
          version = "0.0.0.912",
          pkg = dummy_golem,
          talkative = FALSE
        )
      }
    )
    expect_equal(
      normalizePath(
        get_golem_wd(pkg = dummy_golem)
      ),
      normalizePath(
        golem_wd
      )
    )
    expect_equal(
      get_golem_name(pkg = dummy_golem),
      "testpkg"
    )
    expect_true(
      grepl(
        "testpkg",
        paste0(readLines(
          file.path(
            dummy_golem,
            "tests/testthat.R"
          )
        ), collapse = "")
      )
    )
    expect_true(
      grepl(
        "pif",
        paste0(readLines(
          file.path(
            dummy_golem,
            "vignettes/pif.Rmd"
          )
        ), collapse = "")
      )
    )
    expect_equal(
      get_golem_version(pkg = dummy_golem),
      "0.0.0.912"
    )

    unlink(
      dummy_golem,
      recursive = TRUE,
      force = TRUE
    )
  }
)
