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
#'
#' @return Used for side-effects
install_dev_deps <- function(
    force_install = FALSE,
    ...) {
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
    # Case 2, the user runs this function with force_install to TRUE
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

#' Install a single dev-dep
#'
#' Work the same way as [install_dev_deps()] when choosing installation
#'   function.
#'
#' @param dev_dep a sing character giving the dependency to install
#' @inheritParams install_dev_deps
install_single_dev_dep <- function(
  dev_dep = NULL,
  force_install = FALSE,
  ...) {
    if (missing(dev_dep)) stop("Must provide arg to 'dev_dep'")
    if (!is.character(dev_dep)) stop("Arg. 'dev_dep' must be character.")

    # placeholder for 'temp_case'
    tc <- character(0)
    # go through cases as the install_dev_deps() function:
    # case C0: force_install is FALSE and R is in non-interactive mode
    if (isFALSE(force_install) && isFALSE(interactive())) tc <- "C0"
    # case C1: force_install is FALSE and R is in interactive mode
    if (isFALSE(force_install) && isTRUE(interactive())) tc <- "C1"
    # case C2: force_install is TRUE and we have 'pak'
    if (isTRUE(force_install) && isTRUE(rlang::is_installed("pak"))) tc <- "C2"
    # case C3: force_install is TRUE and we do not have 'pak'
    if (isTRUE(force_install) && isFALSE(rlang::is_installed("pak"))) tc <- "C3"

    f <- switch(
      tc,
      C0 = "`install_dev_deps()` will not install dev dependencies in non-interactive mode if `force_install` is not set to `TRUE`.",
      C1 = rlang::check_installed,
      C2 = getFromNamespace("pkg_install", "pak"),
      C3 = utils::install.packages
    )
    if (is.character(f)) {
      warning(f)
    } else {
      f(dev_dep)
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
