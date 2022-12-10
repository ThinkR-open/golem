test_that("test maintenance_page", {
  html <- maintenance_page()
  expect_true(inherits(html, c("html_document", "shiny.tag.list", "list")))
})
