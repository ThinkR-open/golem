create_temp_rproj <- function() {
  temp_file <- tempfile(pattern = "test", fileext = ".Rproj")
  yaml::write_yaml(list(PackageRoxygenize = NULL), temp_file)
  return(temp_file)
}


test_that(
  "enable_roxygenize function updates the .Rproj file correctly"
, {
  # Create a temporary .Rproj file
  temp_rproj <- create_temp_rproj()

  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      enable_roxygenize(path = temp_rproj)
    }
  )

  updated_content <- yaml::read_yaml(temp_rproj)

  expect_equal(
    updated_content[["PackageRoxygenize"]],
    "rd,collate,namespace"
  )

  unlink(temp_rproj)
})

test_that("enable_roxygenize function prints correct messages", {
  temp_rproj <- create_temp_rproj()

  output <- capture.output(enable_roxygenize(path = temp_rproj))

  expect_true(any(grepl("Reading", output)))
  expect_true(any(grepl("Enable roxygen2", output)))
  expect_true(any(grepl("Done", output)))

  unlink(temp_rproj)
})
