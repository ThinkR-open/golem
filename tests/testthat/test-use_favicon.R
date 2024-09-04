test_that("use_favicon works", {
  run_quietly_in_a_dummy_golem({
    testthat::with_mocked_bindings(
      curl_get_headers = function(...) {
        res <- list()
        attr(res, "status") <- 200
        res
      },
      utils_download_file = function(path, destfile, method) {
        file.copy(
          golem_sys(
            "shinyexample/inst/app/www/favicon.ico"
          ),
          destfile
        )
      },
      {
        use_favicon()
        expect_true(
          file.exists("inst/app/www/favicon.ico")
        )

        lapply(
          c(
            "test.jpeg",
            "test.bmp",
            "test.gif",
            "test.tiff"
          ),
          function(.x) {
            expect_error(
              use_favicon(path = .x)
            )
          }
        )
        remove_favicon()
        expect_false(
          file.exists("inst/app/www/favicon.ico")
        )
        use_favicon(
          path = "https://fr.wikipedia.org//static/favicon/wikipedia.ico"
        )
        expect_true(
          file.exists("inst/app/www/favicon.ico")
        )
      }
    )
  })
})

test_that("use_favicon fails on 404", {
  testthat::with_mocked_bindings(
    curl_get_headers = function(...) {
      res <- list()
      attr(res, "status") <- 404
      res
    },
    {
      expect_error(
        use_favicon(pkg = "dummy")
      )
    }
  )
})

test_that("use_favicon fails on error", {
  testthat::with_mocked_bindings(
    curl_get_headers = function(...) {
      stop("error")
    },
    {
      expect_error(
        use_favicon(pkg = "dummy")
      )
    }
  )
})

test_that("test favicon class", {
  expect_s3_class(
    favicon("jean", "jean"),
    "shiny.tag"
  )
})
