test_that("multiplication works", {
  run_quietly_in_a_dummy_golem({
    add_css_file(
      pkg = ".",
      "bundle",
      open = FALSE
    )
    add_js_file(
      pkg = ".",
      "bundle",
      open = FALSE
    )
    res <- bundle_resources(
      path = "inst/app/www",
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
})
