context("test-desc")

test_that("desc works", {
  tpdir <- tempdir()
  file.copy(
    system.file("shinyexample/DESCRIPTION", package = "shinytemplate"), 
    file.path(tpdir, "DESCRIPTION")
  )
  fill_desc(
    "pkg_name", 
    "pkg_title", 
    "Package Description.",
    "author_first_name", 
    "author_last_name", 
    "author_email", 
    "http://repo_url.com",
    pkg = file.path(tpdir, "DESCRIPTION")
  )
})
