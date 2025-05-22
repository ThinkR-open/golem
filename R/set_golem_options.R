#' `{golem}` options
#'
#' Set and get a series of options to be used with `{golem}`.
#' These options are found inside the `golem-config.yml` file, found in most cases
#' inside the `inst` folder.
#'
#' @section Set Functions:
#' + `set_golem_options()` sets all the options, with the defaults from the functions below.
#' + `set_golem_wd()` defaults to `golem::golem_wd()`, which is the package root when starting a golem.
#' + `set_golem_name()` defaults `golem::pkg_name()`
#' + `set_golem_version()` defaults `golem::pkg_version()`
#'
#' @section Get Functions:
#' Reads the information from `golem-config.yml`
#' + `get_golem_wd()`
#' + `get_golem_name()`
#' + `get_golem_version()`
#'
#' @param golem_name Name of the current golem.
#' @param golem_version Version of the current golem.
#' @param golem_wd Working directory of the current golem package.
#' @param app_prod Is the `{golem}` in prod mode?
#' @param pkg The path to set the golem working directory.
#'     Note that it will be passed to `normalizePath`.
#' @param talkative Should the messages be printed to the console?
#' @param name The name of the app
#' @param version The version of the app
#' @param config_file path to the `{golem}` config file
#' @param old_name The old name of the app, used when changing the name
#' @inheritParams config::get
#'
#' @rdname golem_opts
#'
#' @export
#' @importFrom attempt stop_if_not
#'
#' @return Used for side-effects for the setters, and values from the
#'     config in the getters.
set_golem_options <- function(
  golem_name = golem::pkg_name(),
  golem_version = golem::pkg_version(),
  golem_wd = golem::pkg_path(),
  app_prod = FALSE,
  talkative = TRUE,
  config_file = golem::get_current_config(golem_wd)
) {
  # TODO here we'll run the
  # golem_install_dev_pkg() function

  if (talkative) {
    cli_cat_rule(
      "Setting {golem} options in `golem-config.yml`"
    )
  }

  # Let's do this in the order of the
  # parameters
  # Setting name of the golem
  set_golem_name(
    name = golem_name,
    golem_wd = golem_wd,
    talkative = talkative
  )

  # Let's start with wd
  # Basically here the idea is to be able
  # to keep the wd as an expr if it is the
  # same as golem::pkg_path(), otherwise
  # we use the explicit path

  set_golem_wd(
    new_golem_wd = golem_wd,
    current_golem_wd = golem_wd,
    talkative = talkative
  )

  # Setting golem_version
  set_golem_version(
    version = golem_version,
    golem_wd = golem_wd,
    talkative = talkative
  )

  # Setting app_prod
  amend_golem_config(
    "app_prod",
    app_prod,
    golem_wd = golem_wd,
    talkative = talkative
  )

  # This part is for {usethis} and {here}
  if (talkative) {
    cli_cat_rule(
      "Setting {usethis} project as `golem_wd`"
    )
  }

  usethis_proj_set(golem_wd)
}
