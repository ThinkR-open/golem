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
  if (Sys.getenv("GOLEM_CONFIG_PATH") == "") {
    path_to_config <- fs_path(
      path,
      file
    )
  } else {
    path_to_config <- Sys.getenv("GOLEM_CONFIG_PATH")
  }
  path_to_config <- fs_path_abs(path_to_config)
  if (!fs_file_exists(path_to_config)) {
    stop(
      "Unable to locate config file. Either use the default path at inst/golem-config.yml or set it with a GOLEM_CONFIG_PATH environment variable"
    )
  }
}
try_user_config_location <- function(pth) {
  # I. try to retrieve from possible user change in app_config.R
  user_location_default <- file.path(
    pth,
    "R/app_config.R"
  )
  if (
    isFALSE(
      fs_file_exists(user_location_default)
    )) {
    return(NULL)
  }

  # II. if successful, read file and find line where new config is located
  tmp_guess_text <- readLines(
    user_location_default
  )
  tmp_guess_lines <- guess_lines_to_config_file(tmp_guess_text)
  ## -> early return if malformation i.e. no lines found that match app_sys(...)
  if (is.null(tmp_guess_lines)) {
    return(NULL)
  }

  # III. Collapse character-text found into a single char from which to retrieve
  #      path! This is important if the path is a (complicated) multi-line path.
  tmp_guess_subtext <- paste0(tmp_guess_text[tmp_guess_lines], collapse = "")

  # IV. Identify quoted string that gives new config-path
  tmp_config_expr <- regexpr("\\((.|\n)*\\)$", tmp_guess_subtext)
  tmp_config_char <- regmatches(tmp_guess_subtext, tmp_config_expr)

  # V. Manually remove quotes/character-artefacts to form a proper path
  out_config_char <- regmatches(
    tmp_config_char,
    regexpr('\\".*\\"', tmp_config_char)
  )
  out_config_char <- substring(out_config_char, 2, nchar(out_config_char) - 1)

  # V. return full path to new config file including pkg-path and 'inst'
  return(fs_path(pth, "inst", out_config_char))
}
guess_lines_to_config_file <- function(guess_text) {
  # I. Check if the path is a one-liner i.e. try to match `app_sys(...)` string
  tmp_guess_lines <- which(grepl("app_sys\\((.|\n)*\\)$", guess_text))
  if (identical(integer(0), tmp_guess_lines)) {
    # II. If that is not the case, identify lines that contain the path info
    tmp_guess_multi_liner <- which(grepl("app_sys\\(", guess_text))
    if (identical(integer(0), tmp_guess_multi_liner)) {
      # Early return NULL if file does not contain the `app_sys()` command;
      # alternatively, there could be an error thrown here if `app_sys()` must
      # be present inside any `R/app_config.R`; think about this later
      return(NULL)
    }
    tmp_guess_lines <- tmp_guess_multi_liner
    tmp_check_lines <- seq(
      from = tmp_guess_lines + 1,
      to = length(guess_text)
    )
    # Find the closing brace `)` of app_sys(...) - identified code portion must
    # contain information on the path.
    tmp_end_line <- NULL
    for (i in tmp_check_lines) {
      if (grepl(".*\\)", guess_text[i])) {
        tmp_end_line <- i
        break
      }
    }
    # Return value is a sequence of line numbers where to elicit the config-path
    tmp_guess_lines <- seq(from = tmp_guess_lines, to = tmp_end_line)
  }
  return(tmp_guess_lines)
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

  # We default to inst/ if this doesn't exist
  if (is.null(path_conf)) {
    path_conf <- fs_path(
      path,
      "inst/golem-config.yml"
    )
  }

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
        golem::pkg_name(path = path)
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
