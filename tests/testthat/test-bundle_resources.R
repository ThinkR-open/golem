test_that("bundle_resources works", {
  withr::with_dir(pkg, {
    remove_file("inst/app/www/bundle.css")
    remove_file("inst/app/www/bundle.js")
    golem::add_css_file("bundle", open = FALSE)
    golem::add_js_file("bundle", open = FALSE)
    res <- bundle_resources(
      path = "inst/app/www",
      app_title = fakename,
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
})
