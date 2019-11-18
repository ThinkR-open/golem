context("test-add_file function")

test_that("add_css_file", {
  
  with_dir(pkg, {
    remove_files("inst/app/www", "\\.css$")
    add_css_file("style", pkg = pkg, open = FALSE)
    expect_exists("inst/app/www/style.css")
    
    add_css_file("stylebis", pkg = pkg, open = FALSE, dir = normalizePath(fp))
    expect_true(
      file.exists(
        file.path(fp, "stylebis.css")
      )
    )
    style <-list.files("inst/app/www/", pattern = "style")
    expect_equal(tools::file_ext(style), "css")
    
    # Test that extension is removed
    remove_file("inst/app/www/style.css")
    add_css_file("style.css", pkg = pkg, open = FALSE)
    expect_true(file.exists("inst/app/www/style.css"))
    
    remove_file("inst/app/www/style.css")
    remove_file("inst/app/www/stylebis.css")
  })
})

test_that("add_js_file", {
  with_dir(pkg, {
    remove_file("inst/app/www/script.js")
    add_js_file("script", pkg = pkg, open = FALSE)
    expect_true(file.exists("inst/app/www/script.js"))
    
    add_js_file("script", pkg = pkg, open = FALSE, dir = normalizePath(fp))
    expect_true(
      file.exists(
        file.path(fp, "script.js")
      )
    )
    script <-
      list.files("inst/app/www/", pattern = "script")
    expect_equal(tools::file_ext(script),
                 "js")
    remove_file("inst/app/www/script.js")
    
    # Test that extension is removed
    add_js_file("script.js", pkg = pkg, open = FALSE)
    expect_true(file.exists("inst/app/www/script.js"))
    remove_file("inst/app/www/script.js")
  })
})

test_that("add_js_handler", {
  with_dir(pkg, {
    remove_file("inst/app/www/handler.js")
    add_js_handler("handler", pkg = pkg, open = FALSE)
    expect_true(file.exists("inst/app/www/handler.js"))
    
    add_js_handler("handler",pkg = pkg, open = FALSE, dir = normalizePath(fp))
    expect_true(
      file.exists(
        file.path(fp, "handler.js")
      )
    )
    script <-
      list.files("inst/app/www/", pattern = "handler")
    expect_equal(tools::file_ext(script),
                 "js")
    remove_file("inst/app/www/handler.js")
    
    # Test that extension is removed
    add_js_handler("handler.js", pkg = pkg, open = FALSE)
    expect_true(file.exists("inst/app/www/handler.js"))
    remove_file("inst/app/www/handler.js")
  })
})

test_that("add_ui_server_files", {
  with_dir(pkg, {
    remove_file("inst/app/ui.R")
    remove_file("inst/app/server.R")
    add_ui_server_files(pkg = pkg)
    expect_true(file.exists("inst/app/ui.R"))    
    expect_true(file.exists("inst/app/server.R"))    
    script <- list.files("inst/app/", pattern = "ui")
    expect_equal(tools::file_ext(script), "R")
    script <- list.files("inst/app/", pattern = "server")
    expect_equal(tools::file_ext(script), "R")
    remove_file("inst/app/ui.R")
    remove_file("inst/app/server.R")
  })
})
