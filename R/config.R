# This file contains everything related to the
# manipulation of the golem-config file

# We first need something to guess where the file
# is. 99.99% of the time it will be
# ./inst/golem-config.yml but if for some reason
# you're somewhere else, functions still need to
# work

#' @importFrom attempt attempt is_try_error
guess_where_config <- function(
  path = golem::pkg_path(),
  file = "inst/golem-config.yml"
) {
  # 1. DEV USER: envir var is set, and if the file does not exist hard stop
  if (Sys.getenv("GOLEM_CONFIG_PATH") != "") {
    path_to_config <- fs_path_abs(Sys.getenv("GOLEM_CONFIG_PATH"))
    if (!fs_file_exists(path_to_config)) {
      msg_err <- paste0(
        "Unable to locate a config file using the environment variable
        'GOLEM_CONFIG_PATH'. Check for typos in the (path to the) filename."
      )
      stop(msg_err)
    }
  } else if (Sys.getenv("GOLEM_CONFIG_PATH") == "") {
    path_to_config <- fs_path(
      path,
      file
    )
    # 2.A standard user: sets default path -> all is fine
    CHECK_DEFAULT_PATH <- grepl("*./inst/golem-config.yml$", path_to_config)
    if (isFALSE(CHECK_DEFAULT_PATH)) {
      # 2.B DEV USER: sets non-default path, if the file does not exist hard stop
      if (!fs_file_exists(path_to_config)) {
        msg_err <- paste0(
          "Unable to locate a config file from either the 'path' and 'file'",
          "arguments, or  the 'GOLEM_CONFIG_PATH' environment variable.",
          "Check for typos."
        )
        stop(msg_err)
      }
    }
  }
  return(path_to_config)
}
#' Return path to the `{golem}` config-file
#'
#' This function tries to find the path to the `{golem}` config-file currently
#' used. If the config-file is not found, the user is asked if they want to set parts
#' of the `{golem}` skeleton. This includes default versions of "R/app_config"
#' and "inst/golem-config.yml" (assuming that the user tries to convert the
#' directory to a `{golem}` based shiny App).
#'
#' In most cases this function simply returns the path to the default
#' golem-config file located under "inst/golem-config.yml". That config comes
#' in `yml`-format, see the [Engineering Production-Grade Shiny Apps](https://engineering-shiny.org/golem.html?q=config#golem-config)
#' for further details on its format and how to set options therein.
#'
#' Advanced app developers may benefit from having an additional user
#' config-file. This is achieved by copying the file to the new location and
#' setting a new path pointing to this file. The path is altered inside the
#' `app_sys()`-call of the file "R/app_config.R" to point to the (relative to
#' `inst/`) location of the user-config i.e. change
#'
#' ```
#' # Modify this if your config file is somewhere else
#' file = app_sys("golem-config.yml")
#' ```
#'
#' to
#' ```
#' # Modify this if your config file is somewhere else
#' file = app_sys("configs/user-golem-config.yml")
#' ```
#'
#' __NOTE__
#' + the path to the config is changed relative to __*inst/*__ from
#' __*inst/golem-config.yml*__ to __*inst/configs/user-golem-config.yml*__
#' + if both, the default config __*and*__ user config files exists (and the
#' path is set correctly for the latter), an error is thrown due to ambiguity:
#' in this case simply rename/delete the default config or change the entry in
#' "R/app_config.R" back to `app_sys("golem-config.yml")` to point to the
#' default location
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

  if (!fs_file_exists(path_conf)) {
    if (rlang_is_interactive()) {
      ask <- ask_golem_creation_upon_config(path_conf)
      # Return early if the user doesn't allow
      if (!ask) {
        return(NULL)
      }
      fs_file_copy(
        path = golem_sys("shinyexample/inst/golem-config.yml"),
        new_path = fs_path(
          path,
          "inst/golem-config.yml"
        )
      )
      fs_file_copy(
        path = golem_sys("shinyexample/R/app_config.R"),
        new_path = fs_path(
          path,
          "R/app_config.R"
        )
      )
      replace_word(
        fs_path(
          path,
          "R/app_config.R"
        ),
        "shinyexample",
        golem::pkg_name(
          golem_wd = path
        )
      )
      # TODO This should also create the dev folder
    } else {
      stop(
        sprintf(
          "The %s file doesn't exist.",
          basename(path_conf)
        )
      )
    }
  }

  return(
    invisible(path_conf)
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
