test_that(
  "use_external_js_file works",
  {
    dummy_golem <- create_dummy_golem()
    testthat::with_mocked_bindings(
      utils_download_file = function( url, there ) {
        file.create(there)
      },
      {
        withr::with_options(
          c("usethis.quiet" = TRUE),
          {
            expect_false(
              use_external_js_file(
                url = "this.css",
                pkg = dummy_golem
              )
            )
            use_external_js_file_output <- use_external_js_file(
              url = "this.js",
              pkg = dummy_golem,
              open = TRUE
            )
            expect_exists(
              use_external_js_file_output
            )
          }
        )
      }
    )
    unlink(
      dummy_golem,
      TRUE,
      TRUE
    )
  }
)
