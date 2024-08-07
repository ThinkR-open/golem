test_that("detach_all_attached works", {
  testthat::with_mocked_bindings(
    .package = "base",
    detach = function(...){
      return(TRUE)
    },{
      res <- detach_all_attached()
    }
  )
  expect_true(res)
})

test_that(
  "check_name_consistency works",
  {
    dummy_golem <- create_dummy_golem()
    res <- check_name_consistency(dummy_golem)
    expect_true(res)
    silent_desc <- desc::desc_set(
      "Package",
      "pif",
      file = file.path(dummy_golem, "DESCRIPTION")
    )
    expect_error(check_name_consistency(dummy_golem))
    unlink(
      dummy_golem,
      recursive = TRUE,
      force = TRUE
    )
  }
)

test_that("test document_and_reload", {
  res <- perform_inside_a_new_golem(function() {
    file.create("R/sum.R")
    cat(
      "#' @export
    sum_golem <- function(a,b){a + b}",
      file = "R/sum.R"
    )
    golem::document_and_reload()
    sum_golem(1, 2)
  })
  testthat::expect_equal(
    res,
    3
  )
  testthat::with_mocked_bindings(
    roxygen2_roxygenise = function(...){
      return(TRUE)
    },
    pkgload_load_all = function(...){
      return(TRUE)
    },{
      dummy_golem <- create_dummy_golem()
      expect_null(
        document_and_reload(
          dummy_golem
        )
      )
    }
  )
})
