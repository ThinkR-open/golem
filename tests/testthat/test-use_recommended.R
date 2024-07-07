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
    dummy_golem <- file.path(
      tempdir(),
      "dummygolem"
    )
    dir.create(
      file.path(
        dummy_golem,
        "R"
      ),
      recursive = TRUE
    )
    dir.create(
      file.path(
        dummy_golem,
        "tests/testthat"
      ),
      recursive = TRUE
    )
    withr::with_options(
      c("usethis.quiet" = TRUE),
      {
        testthat::with_mocked_bindings(
          usethis_use_spell_check = function(...) {
            file.create(
              file.path(
                dummy_golem,
                "tests/spelling.R"
              )
            )
          },
          {
            use_recommended_tests(
              pkg = dummy_golem
            )
          }
        )
      }
    )
    expect_error(
      use_recommended_tests(
        pkg = dummy_golem
      )
    )
    expect_exists(
      file.path(
        dummy_golem,
        "tests",
        "testthat",
        "test-golem-recommended.R"
      )
    )
    unlink(
      dummy_golem,
      TRUE,
      TRUE
    )
  }
)
