context("test-desc")

test_that("desc works", {
  tpdir <- tempdir()
  descr <- file.path(tpdir, "DESCRIPTION")
  file.copy(overwrite = TRUE,
    system.file("shinyexample/DESCRIPTION", package = "golem"), 
    descr
  )
  fill_desc(
    "pkg_name", 
    "pkg_title", 
    "Package Description.",
    "author_first_name", 
    "author_last_name", 
    "author_email", 
    "http://repo_url.com",
    pkg = dirname(descr)
  )
})
