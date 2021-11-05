
test_that("desc works", {
  testthat::skip_if_not_installed("desc")
  with_dir(pkg, {
    output <- capture_output(
      fill_desc(
        fakename,
        "newtitle",
        "Newdescription.",
        "firstname",
        "lastname",
        "name@test.com",
        "http://repo_url.com"
      )
    )
    add_desc <- c(
      fakename,
      "newtitle",
      "Newdescription.",
      "firstname",
      "lastname",
      "name@test.com",
      "http://repo_url.com"
    )
    desc <- readLines("DESCRIPTION")

    expect_true(
      all(
        as.logical(lapply(add_desc, function(x) {
          any(grepl(x, desc))
        }))
      )
    )

    expect_true(
      stringr::str_detect(output, "DESCRIPTION file modified")
    )
  })
})
