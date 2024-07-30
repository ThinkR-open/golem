test_that("Check module_template output", {
  tmp <- tempdir()

  unlink(file.path(tmp, "test.R"))

  module_template(
    name = "test",
    path = file.path(tmp, "test.R"),
    export = TRUE
  )

  file_content <- readLines(file.path(tmp, "test.R"))

  tags <- c(
    "@export",
    "@shinyModule",
    "@rdname mod_test"
  )

  expect_true(
    sapply(
      tags,
      \(x) any(grepl(x, file_content))
    ) |>
      all()
  )

  unlink(file.path(tmp, "test.R"))

  module_template(
    name = "test",
    path = file.path(tmp, "test.R"),
    export = FALSE
  )

  file_content <- readLines(file.path(tmp, "test.R"))

  tags <- c(
    "@noRd",
    "@shinyModule"
  )

  expect_true(
    sapply(
      tags,
      \(x) any(grepl(x, file_content))
    ) |>
      all()
  )
})
