test_that("build_name works as expected", {
  expect_equal(
    build_name(
      "example.txt",
      "http://example.com/file.txt"
    ),
    "example"
  )

  expect_equal(
    build_name(NULL, "http://example.com/file.txt"),
    "file"
  )

  expect_equal(
    build_name(url = "http://example.com/file.txt"),
    "file"
  )

  expect_equal(
    build_name("example", "http://example.com/file.txt"),
    "example"
  )

  expect_error(
    build_name(
      c("name1", "name2"),
      "http://example.com/file.txt"
    )
  )
})

test_that("check_url_has_the_correct_extension(url, where) works", {
  testthat::expect_snapshot(error = TRUE, {
    check_url_has_the_correct_extension(
      "https://www.google.com",
      "js"
    )
  })
  expect_error({
    check_url_has_the_correct_extension(
      "https://www.google.com",
      "js"
    )
  })
  testthat::expect_null(
    check_url_has_the_correct_extension(
      "https://www.google.com/test.js",
      "js"
    )
  )
})


test_that("download_external(url, where) works", {
  testthat::expect_snapshot({
    testthat::with_mocked_bindings(
      utils_download_file = function(url, where) {
        print(url)
        print(where)
      },
      {
        download_external(
          "https://www.google.com",
          "inst/app/www/google.html"
        )
      }
    )
  })
})
