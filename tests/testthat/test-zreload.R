## fake package
fakename <- paste0(sample(letters, 10, TRUE), collapse = "")
tpdir <- tempdir()

if (!dir.exists(file.path(tpdir, fakename))) {
  create_golem(file.path(tpdir, fakename), open = FALSE)
}
pkg_reload <- file.path(tpdir, fakename)

test_that("test document_and_reload", {
  with_dir(pkg_reload, {
    file.create("R/sum.R")
    cat(
      "#' @export
    sum_golem <- function(a,b){a + b}",
      file = "R/sum.R"
    )
    document_and_reload(pkg = ".")
    testthat::expect_equal(sum_golem(1, 2), 3)
  })
})

test_that("test detach_all_attached", {
  with_dir(pkg_reload, {
    test <- detach_all_attached()
    testthat::expect_true(test)
  })
})
