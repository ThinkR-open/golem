test_that("multiplication works", {
  dummy_golem <- create_dummy_golem()
  on.exit({
    unlink(
      dummy_golem,
      TRUE,
      TRUE
    )
  })
  withr::with_dir(
    dummy_golem,
    {
      withr::with_options(
        c("usethis.quiet" = TRUE),
        {
          golem::add_css_file(
            pkg = ".",
            "bundle",
            open = FALSE
          )
          golem::add_js_file(
            pkg = ".",
            "bundle",
            open = FALSE
          )
        }
      )
    }
  )
  res <- bundle_resources(
    path = file.path(
      dummy_golem,
      "inst/app/www"
    ),
    app_title = "fakename",
    with_sparkles = TRUE
  )
  expect_equal(
    length(res),
    3
  )
  expect_true(
    inherits(res[[1]], "html_dependency")
  )
  expect_true(
    inherits(res[[2]], "shiny.tag")
  )
  expect_true(
    inherits(res[[3]], "html_dependency")
  )
})
