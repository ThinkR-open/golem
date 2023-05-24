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
  # We'll try to guess where the path
  # to the golem-config file is

  # This one should be correct in 99% of the case
  # If we don't change the default values of the params.
  # => current directory /inst/golem-config.yml
  ret_path <- fs_path(
    path,
    file
  )
  if (fs_file_exists(ret_path)) {
    return(fs_path_abs(ret_path))
  }
# # Trying with "golem.config.path" option
  # custom_path <- getOption("golem.config.path")
  # if (
  #   !is.null(custom_path) &&
  #   file.exists(custom_path)
  #     ) {
  #   return(path_abs(custom_path))
  # }
  # Maybe for some reason we are in inst/
  ret_path <- "golem-config.yml"
  if (fs_file_exists(ret_path)) {
    return(fs_path_abs(ret_path))
  }

  # Trying with pkg_path
  ret_path <- attempt({
    fs_path(
      golem::pkg_path(),
      "inst/golem-config.yml"
    )
  })

  if (
    !is_try_error(ret_path) &
      fs_file_exists(ret_path)
  ) {
    return(
      fs_path_abs(ret_path)
    )
  }
  return(NULL)
}

#' Get the path to the current config File
#'
#' This function tries to guess where the golem-config file is located.
#' If it can't find it, this function asks the
#' user if they want to set the golem skeleton.
#'
#' @param path Path to start looking for the config
#'
#' @export
get_current_config <- function(path = getwd()) {
  # We check wether we can guess where the config file is
  path_conf <- guess_where_config(path)

  # We default to inst/ if this doesn't exist
  if (is.null(path_conf)) {
    path_conf <- fs_path(
      path,
      "inst/golem-config.yml"
    )
  }

  if (!fs_file_exists(path_conf)) {
    if (interactive()) {
      ask <- yesno(
        sprintf(
          "The %s file doesn't exist.\nIt's possible that you might not be in a {golem} based project.\n Do you want to create the {golem} files?",
          basename(path_conf)
        )
      )
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
        golem::pkg_name()
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

# This function changes the name of the
# package in app_config when you need to
# set the {golem} name
change_app_config_name <- function(
  name,
  path = get_golem_wd()
) {
  pth <- fs_path(path, "R", "app_config.R")
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
