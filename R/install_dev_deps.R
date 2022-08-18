#' Install {golem} dev dependencies
#'
#' This function will run rlang::check_installed() on:
#' + {usethis}
#' + {pkgload}
#' + {dockerfiler}
#' + {devtools}
#' + {roxygen2}
#' + {attachment}
#' + {rstudioapi}
#' + {here}
#' + {fs}
#'
#' @param force_install If force_install is installed,
#'  then the user is not interactively asked
#'  to install them.
#'
#' @export
#'
#' @example
#' if (interactive()){
#'   install_dev_deps()
#' }
install_dev_deps <- function(force_install = FALSE) {
  # If the install is forced, the installation function
  # will be pak::pkg_install if pak is installed, otherwise
  # it is install.packages

  if (!force_install) {
    rlang::check_installed("pak")
  }

  # At that point, the user probably has pak installed
  if (rlang::is_installed("pak")) {
    f <- pak::pkg_install
  } else {
    f <- utils::install.packages
  }
  for (
    pak in c(
      "usethis",
      "pkgload",
      "dockerfiler",
      "devtools",
      "roxygen2",
      "attachment",
      "rstudioapi",
      "here",
      "fs",
      "desc"
    )
  ) {
    f(pak)
  }
}
