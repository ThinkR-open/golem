context("test-desc")

test_that("desc works", {
  with_dir(pkg,{
 output <-  capture_output(fill_desc(
    "pkgtest", 
    "newtitle", 
    "Newdescription.",
    "firstname", 
    "lastname", 
    "name@test.com", 
    "http://repo_url.com"
  ))
  add_desc <- c("pkgtest", "newtitle", "Newdescription.",
                "firstname", "lastname", "name@test.com", 
                "http://repo_url.com")
  desc <- readLines("DESCRIPTION")
  
  test <- all(purrr::map_lgl(add_desc,function(x){any(grepl(x,desc))}))
  expect_true(test)
  test <-
    stringr::str_detect(output, "DESCRIPTION file modified")
  expect_true(test)
  
  })
})
