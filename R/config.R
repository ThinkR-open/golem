# This file contains everything related to the
# manipulation of the golem-config file

# {golem} no longer tries to do some magic to
# guess where the config file is.
# It's either inst/golem-config.yml or
# GOLEM_CONFIG_PATH env var

#' @importFrom attempt attempt is_try_error
guess_where_config <- function(
  path = golem::pkg_path(),
  file = "inst/golem-config.yml"
) {
  # Case one: Env var is set, and if the file does not exist hard stop
  if (Sys.getenv("GOLEM_CONFIG_PATH") != "") {
    path_to_config <- fs_path_abs(
      Sys.getenv(
        "GOLEM_CONFIG_PATH"
      )
    )
    if (!fs_file_exists(path_to_config)) {
      msg_err <- paste(
        "`GOLEM_CONFIG_PATH` is set, but we were unable to locate",
        "a config file using this environment variable.\n",
        "Check for typos and set the environment variable to a valid path."
      )
      stop(msg_err)
    }
    return(path_to_config)
  }

  # Case two: Env var not set, we default to the
  # standard path
  path_to_config <- fs_path(
    path,
    file
  )

  if (!fs_file_exists(path_to_config)) {
    msg_err <- paste0(
      "Unable to locate a config file from the default location.",
      "Please restore this file or use the 'GOLEM_CONFIG_PATH' environment variable to
      set a custom path to the config file.\n",
      "The default path is: ",
      fs_path_abs(path_to_config)
    )
    stop(msg_err)
  }

  return(path_to_config)
}
#' Return path to the `{golem}` config-file
#'
#' This function tries to find the current config file, being
#' either inst/golem-config.yml or the GOLEM_CONFIG_PATH env var
#'
#' In most cases this function simply returns the path to the default
#' golem-config file located under "inst/golem-config.yml". That config comes
#' in `yml`-format, see the [Engineering Production-Grade Shiny Apps](https://engineering-shiny.org/golem.html?q=config#golem-config)
#' for further details on its format and how to set options therein.
#'
#' Advanced app developers may benefit from having an additional user
#' config-file. This is achieved with setting the GOLEM_CONFIG_PATH env var.
#'
#'
#'
#' @param path character string giving the path to start looking for the config;
#'    the usual value is the `{golem}`-package top-level directory but a user
#'    supplied config is now supported (see __Details__ for how to use this
#'    feature).
#'
#' @export
#' @return character string giving the path to the `{golem}` config-file
get_current_config <- function(path = getwd()) {
  # We check whether we can guess where the config file is
  path_conf <- guess_where_config(path)

  # 2025-06-05
  # There used to be a copy skeleton mechanism but I feel like
  # we should not support this
  return(
    path_conf
  )
}


ask_golem_creation_upon_config <- function(pth) {
  msg <- paste0(
    "The %s file doesn't exist.",
    "\nIt's possible that you might not be in a {golem} based project.\n",
    "Do you want to create the {golem} files?"
  )
  yesno(sprintf(msg, basename(pth)))
}

# This function changes the name of the
# package in app_config when you need to
# set the {golem} name
change_app_config_name <- function(
  name,
  golem_wd = get_golem_wd(),
  path
) {
  signal_arg_is_deprecated(
    path,
    fun = as.character(sys.call()[[1]])
  )
  pth <- fs_path(golem_wd, "R", "app_config.R")
  app_config <- readLines(pth)

  where_system.file <- grep("system.file", app_config)

  app_config[
    where_system.file
  ] <- sprintf(
    '  system.file(..., package = "%s")',
    name
  )
  write(app_config, pth)
}
