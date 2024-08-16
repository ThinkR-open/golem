test_that("add_resource_path", {
  expect_warning(
    add_resource_path(
      "",
      "",
      warn_empty = TRUE
    )
  )
  res <- add_resource_path(
    "xyz",
    directoryPath = golem_sys("utils"),
    warn_empty = TRUE
  )
  expect_equal(
    normalizePath(
      res$directoryPath,
      winslash = "/"
    ),
    normalizePath(
      golem_sys("utils"),
      winslash = "/"
    )
  )
})
