context("test-add_file function")

expect_add_file <- function(
  fun,
  ext, 
  pak, 
  fp
){
  
  name <- rand_name()
  # Be sure to remove all files in case there are
  remove_files("inst/app/www", ext)
  # Launch the function
  fun(name, pkg = pak, open = FALSE)
  # Test that the file exists
  expect_exists(file.path("inst/app/www", paste0(name,".", ext)))
  # Check that the file exsts
  ff <- list.files("inst/app/www/", pattern = name, full.names = TRUE)
  expect_equal(tools::file_ext(ff), ext)
  
  # Check content is not over-added
  l_ff <- length(readLines(ff))
  fun(name, pkg = pak, open = FALSE)
  expect_equal(l_ff, length(readLines(ff)))
  
  # Try another file in another dir
  bis <- paste0(name, rand_name())
  fun(bis, pkg = pak, open = FALSE, dir = normalizePath(fp))
  expect_exists( normalizePath(fp) )
  ff <- list.files( normalizePath(fp), pattern = bis, full.names = TRUE)
  expect_equal(tools::file_ext(ff), ext)
  
  # Check that the extension is removed
  name <- rand_name()
  ter <- paste0(name, ".", ext)
  fun(ter, pkg = pkg, open = FALSE,)
  expect_exists(file.path("inst/app/www"))
  ff <- list.files("inst/app/www/", pattern = ter, full.names = TRUE)
  expect_equal(tools::file_ext(ff), ext)
  
  # Check content is not over-added
  l_ff <- length(readLines(ff))
  fun(name, pkg = pak, open = FALSE)
  expect_equal(l_ff, length(readLines(ff)))
  
  remove_files("inst/app/www", ext)
}

test_that("add_files", {
  
  with_dir(pkg, {
    expect_add_file(
      add_css_file, 
      ext = "css", 
      pak = pkg,
      fp = fp
    )
    expect_add_file(
      add_js_file, 
      ext = "js", 
      pak = pkg,
      fp = fp
    )
    expect_add_file(
      add_js_handler, 
      ext = "js", 
      pak = pkg,
      fp = fp
    )
    expect_add_file(
      add_js_binding, 
      ext = "js", 
      pak = pkg,
      fp = fp
    )
    
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
    
    # Check content is not over-added
    l_ui <- length(readLines(list.files("inst/app/", pattern = "ui", full.names = TRUE)))
    l_server <- length(readLines(list.files("inst/app/", pattern = "server", full.names = TRUE)))
    add_ui_server_files(pkg = pkg)
    expect_equal(
      l_ui, 
      length(readLines(list.files("inst/app/", pattern = "ui", full.names = TRUE)))
    )
    expect_equal(
      l_server, 
      length(readLines(list.files("inst/app/", pattern = "server", full.names = TRUE)))
    )
    
    add_ui_server_files(pkg = pkg)
    remove_file("inst/app/ui.R")
    remove_file("inst/app/server.R")
  })
})
