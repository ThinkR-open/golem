test_that("add_resource_path", {
  withr::with_dir(pkg, {
    expect_message(
      add_resource_path("", "", warn_empty = TRUE),  
      "Unable to add your directory because it is empty"
    )
  })
  
  
})

