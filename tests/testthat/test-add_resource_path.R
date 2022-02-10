test_that("add_resource_path", {
  withr::with_dir(pkg, {
    expect_warning(
      add_resource_path("", "", warn_empty = TRUE)
    )
  })
})
