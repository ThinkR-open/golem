# All the fns here check that {roxygen2} is installed
# before doing anything.
check_roxygen2_installed <- function() {
  rlang::check_installed(
    "roxygen2",
    reason = "to document the package."
  )
}

roxygen2_roxygenise <- function(
  package.dir = ".",
  roclets = NULL,
  load_code = NULL,
  clean = FALSE
) {
  check_roxygen2_installed()
  roxygen2::roxygenise(
    package.dir = package.dir,
    roclets = roclets,
    load_code = load_code,
    clean = clean
  )
}
