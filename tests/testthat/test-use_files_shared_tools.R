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

test_that("check_directory_exists works as expected", {
  expect_error(
    check_directory_exists("inst/app/www")
  )
  expect_null(
    check_directory_exists(getwd())
  )
})

test_that("check_directory_exists works as expected", {
  expect_snapshot(
    error = TRUE,
    {
      check_directory_exists("inst/app/www")
    }
  )
  expect_error(
    check_directory_exists("inst/app/www")
  )
  expect_null(
    check_directory_exists(getwd())
  )
})

test_that("check_file_exists works as expected", {
  file <- tempfile(fileext = ".txt")
  file.create(file)
  expect_error(
    check_file_exists(file)
  )
  expect_null(
    check_file_exists(tempfile(fileext = ".txt"))
  )
  unlink(file)
})
