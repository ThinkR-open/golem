
test_that("desc works", {
  with_dir(pkg, {
    withr::with_options(
      c("golem.quiet" =  FALSE),{
        output <- capture_output(
          fill_desc(
            pkg_name = fakename,
            pkg_title = "newtitle",
            pkg_description = "Newdescription.",
            author_first_name = "firstname",
            author_last_name = "lastname",
            author_email = "name@test.com",
            repo_url = "http://repo_url.com",
            pkg_version = "0.0.0.9000"
          )
      )
    })
    add_desc <- c(
      fakename,
      "newtitle",
      "Newdescription.",
      "firstname",
      "lastname",
      "name@test.com",
      "http://repo_url.com",
      "0.0.0.9000"
    )
    desc <- readLines("DESCRIPTION")

    expect_true(
      all(
        as.logical(lapply(
          add_desc,
          function(x) {
            any(grepl(x, desc))
          }
        ))
      )
    )

    expect_true(
      stringr::str_detect(output, "DESCRIPTION file modified")
    )
  })
})
