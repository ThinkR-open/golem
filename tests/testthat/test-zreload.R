context("tests reload")



test_that("test document_and_reload",{
  with_dir(pkg,{
    file.create("R/sum.R")
    cat(
    "#' @export
    sum_golem <- function(a,b){a + b}",file ="R/sum.R")
    document_and_reload()
    expect_equal(sum_golem(1,2),3)
  })
})

test_that("test detach_all_attached",{
  with_dir(pkg,{
  test <- detach_all_attached()
  ok <- all(purrr::map_lgl(test,~ is.null(.x)))
  testthat::expect_true(ok)
  })
})
