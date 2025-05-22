test_that("use_recommended_deps works", {
  testthat::with_mocked_bindings(
    usethis_use_package = identity,
    {
      withr::with_options(
        c("usethis.quiet" = TRUE),
        {
          expect_warning(
            use_recommended_deps(
              tempdir()
            )
          )
        }
      )
    }
  )
})

test_that(
  "use_recommended_tests works",
  {
    run_quietly_in_a_dummy_golem({
      testthat::with_mocked_bindings(
        usethis_use_spell_check = function(...) {
          file.create(
            "tests/spelling.R"
          )
        },
        {
          use_recommended_tests(
            golem_wd = "."
          )

          expect_exists(
            file.path(
              "tests",
              "testthat",
              "test-golem-recommended.R"
            )
          )
          expect_error(
            use_recommended_tests(
              golem_wd = "."
            )
          )
        }
      )
    })
    # Testing adding testthat if not there
    run_quietly_in_a_dummy_golem({
      testthat::with_mocked_bindings(
        usethis_use_testthat = function() {
          dir.create("tests")
          dir.create("tests/testthat")
          file.create(
            "tests/testthat.R"
          )
        },
        {
          unlink("tests", TRUE, TRUE)
          use_recommended_tests(
            golem_wd = ".",
            spellcheck = FALSE
          )

          expect_exists(
            file.path(
              "tests",
              "testthat",
              "test-golem-recommended.R"
            )
          )
        }
      )
    })
    # Testing adding testthat if processx
    # is not available
    run_quietly_in_a_dummy_golem({
      testthat::with_mocked_bindings(
        usethis_use_testthat = function() {
          dir.create("tests")
          dir.create("tests/testthat")
          file.create(
            "tests/testthat.R"
          )
        },
        {
          use_recommended_tests(
            golem_wd = ".",
            spellcheck = FALSE
          )
        }
      )
    })
  }
)
