# All the fns here check that {cli} is installed
# before doing anything.
check_cli_installed <- function(reason = "to have attractive command line interfaces with {golem}.\nYou can install all {golem} dev dependencies with `golem::install_dev_deps()`.") {
  rlang::check_installed(
    "cli",
    version = "2.0.0",
    reason = reason
  )
}

cli_cat_bullet <- function(...) {
  check_cli_installed()
  do_if_unquiet({
    cli::cat_bullet(...)
  })
}


cli_cat_line <- function(...) {
  check_cli_installed()

  do_if_unquiet({
    cli::cat_line(...)
  })
}

cli_cat_rule <- function(...) {
  check_cli_installed()

  do_if_unquiet({
    cli::cat_rule(
      ...
    )
  })
}

cli_cli_alert_info <- function(...) {
  check_cli_installed()

  do_if_unquiet({
    cli::cli_alert_info(
      ...
    )
  })
}

cli_cli_abort <- function(message) {
  if (rlang::is_installed("cli")) {
    cli::cli_abort(message = message, call = NULL)
  } else {
    stop(message)
  }
}
