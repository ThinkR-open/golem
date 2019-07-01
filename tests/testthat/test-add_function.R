context("test-add_file function")

test_that("add_css_file", {
  with_dir(pkg, {
    add_css_file("style", open = FALSE)
    expect_true(file.exists("inst/app/www/style.css"))
    
    add_css_file("style", open = FALSE, dir = normalizePath(fp))
    expect_true(
      file.exists(
        file.path(fp, "style.css")
      )
    )
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
    
    add_js_file("script", open = FALSE, dir = normalizePath(fp))
    expect_true(
      file.exists(
        file.path(fp, "script.js")
      )
    )
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
    
    add_js_handler("handler", open = FALSE, dir = normalizePath(fp))
    expect_true(
      file.exists(
        file.path(fp, "handler.js")
      )
    )
    script <-
      list.files("inst/app/www/", pattern = "handler")
    expect_equal(tools::file_ext(script),
                 "js")
  })
})

test_that("add_js_handler", {
  with_dir(pkg, {
    add_ui_server_files()
    expect_true(file.exists("inst/app/ui.R"))    
    expect_true(file.exists("inst/app/server.R"))    
    
    add_ui_server_files(dir = normalizePath(fp))
    expect_true(
      file.exists(
        file.path(fp, "ui.R")
      )
    )
    expect_true(
      file.exists(
        file.path(fp, "server.R")
      )
    )
    script <- list.files("inst/app/", pattern = "ui")
    expect_equal(tools::file_ext(script), "R")
    script <- list.files("inst/app/", pattern = "server")
    expect_equal(tools::file_ext(script), "R")
  })
})
