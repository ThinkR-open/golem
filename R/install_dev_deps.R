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
#' + {desc}
#' + {pkgbuild}
#' + {processx}
#' + {rsconnect}
#' + {testthat}
#' + {rstudioapi}
#'
#' @param force_install If force_install is installed,
#'  then the user is not interactively asked
#'  to install them.
#' @param ... further arguments passed to the install function.
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   install_dev_deps()
#' }
install_dev_deps <- function(
  force_install = FALSE,
  ...
) {
  if (!force_install) {
    if (!interactive()) {
      # In non interactive mode with force_install turned to FALSE,
      # The default will be rlang::check_installed. This function
      # will stop in non-interactive mode so we throw a warning message.
      warning("`install_dev_deps()` will not install dev dependencies in non-interactive mode if `force_install` is not set to `TRUE`.")
    }
    # Case 1, which will be the standard case, the user
    # runs this function in interactive mode, with force_install
    # turned to FALSE. We then use rlang::check_installed() as
    # an installation function, as it will ask the user if they
    # want to install, which is what they want
    f <- rlang::check_installed
  } else {
    # Case 2, the user runs this function with force_install to FALSE
    # At that point, the user probably has pak installed
    # If yes, the installation function
    # will be pak::pkg_install, otherwise
    # it is install.packages
    if (rlang::is_installed("pak")) {
      # We manage the install with {pak}
      f <- getFromNamespace("pkg_install", "pak")
    } else {
      f <- utils::install.packages
    }
  }

  for (
    pak in dev_deps
  ) {
    if (!rlang::is_installed(pak)) {
      f(pak, ...)
    }
  }
}

dev_deps <- unique(
  c(
    "attachment",
    "cli",
    "crayon",
    "desc",
    "devtools",
    "dockerfiler",
    "fs",
    "here",
    "pkgbuild",
    "pkgload",
    "processx",
    "roxygen2",
    "renv",
    "rsconnect",
    "rstudioapi",
    "testthat",
    "usethis"
  )
)

check_dev_deps_are_installed <- function() {
  are_installed <- sapply(
    dev_deps,
    FUN = rlang::is_installed
  )
  if (!all(are_installed)) {
    message(
      "We noticed that some dev dependencies are not installed.\n",
      "You can install them with `golem::install_dev_deps()`."
    )
  }
}
