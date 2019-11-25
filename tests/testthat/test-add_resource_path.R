context("test-add_resource_path function")

test_that("add_resource_path", {
  
  expect_message(add_resource_path("", "", warn_empty = TRUE),  
                "Unable to add your directory because it is empty")
  
  expect_message(add_resource_path("golem", "R", warn_empty = FALSE),  
                 paste("Resource path added to ", prefix, "/", directory_path))
  
})