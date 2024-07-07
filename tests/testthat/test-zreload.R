test_that("test document_and_reload", {
  res <- perform_inside_a_new_golem(function() {
    file.create("R/sum.R")
    cat(
      "#' @export
    sum_golem <- function(a,b){a + b}",
      file = "R/sum.R"
    )
    document_and_reload()
    sum_golem(1, 2)
  })
  testthat::expect_equal(
    res,
    3
  )
})
