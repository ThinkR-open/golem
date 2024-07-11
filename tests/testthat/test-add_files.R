test_that("add_js_file works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE), {
      add_js_file(
        "testjsfile",
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "testjsfile.js"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("add_js_handler works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_js_handler(
        "testjsfile",
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "testjsfile.js"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("add_js_input_binding works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_js_input_binding(
        "testjsfile",
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "input-testjsfile.js"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("add_js_output_binding works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_js_output_binding(
        "testjsfile",
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "output-testjsfile.js"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("add_css_file works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_css_file(
        "testcss",
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "testcss.css"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("add_sass_file works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_sass_file(
        "test",
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "test.sass"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("empty file works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_empty_file(
        "test",
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "test"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("add_html_template works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_html_template(
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "template.html"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})

test_that("add_partial_html_template works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      add_partial_html_template(
        pkg = dummy_golem,
        open = FALSE
      )
    }
  )
  expect_exists(
    file.path(
      dummy_golem,
      "inst/app/www",
      "partial_template.html"
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
