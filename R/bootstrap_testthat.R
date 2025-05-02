# All the fns here check that {usethis} is installed
# before doing anything.
check_testthat_installed <- function(
  reason = "for testing purposes."
) {
  rlang::check_installed(
    "testthat",
    version = "3.0.0",
    reason = reason
  )
}

testthat_expect_snapshot <- function(...) {
  check_testthat_installed()
  testthat::expect_snapshot(...)
}
