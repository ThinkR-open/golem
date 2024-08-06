test_that("use_favicon works", {
  dummy_golem <- create_dummy_golem()
  withr::with_dir(
    dummy_golem,
    {
      withr::with_options(
        c("usethis.quiet" = TRUE),
        {
          use_favicon(pkg = dummy_golem)
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
        }
      )
    }
  )
  unlink(
    dummy_golem,
    recursive = TRUE,
    force = TRUE
  )
})

test_that("test use_favicon online", {
  dummy_golem <- create_dummy_golem()
  withr::with_dir(dummy_golem, {
    withr::with_options(
      c("usethis.quiet" = TRUE),
      {
        remove_favicon()
        expect_false(
          file.exists(
            "inst/app/www/favicon.ico"
          )
        )
      }
    )


    use_favicon(
      path = "https://fr.wikipedia.org//static/favicon/wikipedia.ico"
    )
    expect_true(
      file.exists("inst/app/www/favicon.ico")
    )
  })
  unlink(
    dummy_golem,
    recursive = TRUE,
    force = TRUE
  )
})
test_that("test use_favicon online fail", {
  dummy_golem <- create_dummy_golem()
  withr::with_dir(dummy_golem, {
    remove_favicon()
    expect_false(
      file.exists("inst/app/www/favicon.ico")
    )
    if (getRversion() >= "3.5") {
      expect_error(use_favicon(path = "https://fr.wikipedia.org//static/favicon/dontexist.ico"))
    }
    expect_false(
      file.exists("inst/app/www/favicon.ico")
    )
  })
  unlink(
    dummy_golem,
    recursive = TRUE,
    force = TRUE
  )
})

test_that("test favicon", {
  expect_s3_class(
    favicon("jean", "jean"),
    "shiny.tag"
  )
})
