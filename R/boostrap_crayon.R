# All the fns here check that {cli} is installed
# before doing anything.
check_crayon_installed <- function(reason = "to have attractive command line interfaces with {golem}.\nYou can install all {golem} dev dependencies with `golem::install_dev_deps()`.") {
  rlang::check_installed(
    "crayon",
    reason = reason
  )
}


#  from usethis https://github.com/r-lib/usethis/
crayon_darkgrey <- function(x) {
  check_crayon_installed()
  x <- crayon::make_style("darkgrey")(x)
}
