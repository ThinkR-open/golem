context("test-add_file function")

test_that("add_css_file", {
  with_dir(pkg, {
    add_css_file("style", open = FALSE)
    expect_true(file.exists("inst/app/www/style.css"))
    style <-
      list.files("inst/app/www/", pattern = "style")
    expect_equal(tools::file_ext(style),
                 "css")
  })
})

test_that("add_js_file", {
  with_dir(pkg, {
    add_js_file("script", open = FALSE)
    expect_true(file.exists("inst/app/www/script.js"))
    script <-
      list.files("inst/app/www/", pattern = "script")
    expect_equal(tools::file_ext(script),
                 "js")
  })
})

test_that("add_js_handler", {
  with_dir(pkg, {
    add_js_handler("handler", open = FALSE)
    expect_true(file.exists("inst/app/www/handler.js"))
    script <-
      list.files("inst/app/www/", pattern = "handler")
    expect_equal(tools::file_ext(script),
                 "js")
  })
})
