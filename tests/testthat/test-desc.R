
test_that("desc works", {
  testthat::skip_if_not_installed("desc")
  with_dir(pkg, {
    withr::with_options(
      c("golem.quiet" = FALSE),
      {
        output <- capture_output(
          fill_desc(
            pkg_name = fakename,
            pkg_title = "newtitle",
            pkg_description = "Newdescription.",
            authors = person(
              given = "firstname",
              family = "lastname",
              email = "name@test.com"
            ),
            repo_url = "http://repo_url.com",
            pkg_version = "0.0.0.9000"
          )
        )
      }
    )
    add_desc <- c(
      fakename,
      "newtitle",
      "Newdescription.",
      "person('firstname', 'lastname', , 'name@test.com')",
      "http://repo_url.com",
      "0.0.0.9000"
    )
    desc <- readLines("DESCRIPTION")

    expect_true(
      all(
        as.logical(lapply(
          add_desc[-4],
          function(x) {
            any(grepl(x, desc))
          }
        ))
      )
    )
    # add additional test, as authors = person(...) requires parsing test
    tmp_test_add_desc <- eval(parse(text = add_desc[4]))
    tmp_test_desc <- eval(parse(text = desc[[5]]))
    expect_identical(
      tmp_test_add_desc,
      tmp_test_desc)

    expect_true(
      stringr::str_detect(output, "DESCRIPTION file modified")
    )
  })
})
