test_that("use_recommended_deps works", {
  testthat::with_mocked_bindings(
    usethis_use_package = identity,
    {
      withr::with_options(
        c("usethis.quiet" = TRUE),
        {
          expect_warning(
            use_recommended_deps(
              pkg = tempdir()
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
            pkg = "."
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
              pkg = "."
            )
          )
        }
      )
    })
  }
)
