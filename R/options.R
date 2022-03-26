#' `{golem}` options
#'
#' Set and get a series of options to be used with `{golem}`.
#' These options are found inside the `golem-config.yml` file, found in most cases
#' inside the `inst` folder.
#'
#' @section Set Functions:
#' + `set_golem_options()` sets all the options, with the defaults from the functions below.
#' + `set_golem_wd()` defaults to `here::here()`, which is the package root when starting a golem.
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
#' @param path The path to set the golem working directory.
#'     Note that it will be passed to `normalizePath`.
#' @param talkative Should the messages be printed to the console?
#' @param name The name of the app
#' @param version The version of the app
#' @inheritParams config::get
#'
#' @rdname golem_opts
#'
#' @export
#' @importFrom attempt stop_if_not
#' @importFrom yaml read_yaml write_yaml
#' @importFrom usethis proj_set
#'
#' @return Used for side-effects for the setters, and values from the
#'     config in the getters.
set_golem_options <- function(
  golem_name = golem::pkg_name(),
  golem_version = golem::pkg_version(),
  golem_wd = golem::pkg_path(),
  app_prod = FALSE,
  talkative = TRUE
) {
  change_app_config_name(
    name = golem_name,
    path = golem_wd
  )

  cat_if_talk <- function(..., fun = cat_green_tick) {
    if (talkative) {
      fun(...)
    }
  }

  conf_path <- get_current_config(
    golem_wd,
    set_options = FALSE
  )

  stop_if(
    conf_path,
    is.null,
    "Unable to retrieve golem config file."
  )

  cat_if_talk(
    "Setting {golem} options in `golem-config.yml`",
    fun = cli::cat_rule
  )

  conf <- read_yaml(conf_path, eval.expr = TRUE)

  # Setting wd
  if (golem_wd == here::here()) {
    path <- "here::here()"
    attr(path, "tag") <- "!expr"
  } else {
    path <- golem_wd
  }

  cat_if_talk(
    sprintf(
      "Setting `golem_wd` to %s",
      path
    )
  )
  cat_if_talk(
    "You can change golem working directory with set_golem_wd('path/to/wd')",
    fun = cat_line
  )

  conf$dev$golem_wd <- path

  # Setting name of the golem
  cat_if_talk(
    sprintf(
      "Setting `golem_name` to %s",
      golem_name
    )
  )
  conf$default$golem_name <- golem_name

  # Setting golem_version
  cat_if_talk(
    sprintf(
      "Setting `golem_version` to %s",
      golem_version
    )
  )
  conf$default$golem_version <- as.character(golem_version)

  # Setting app_prod
  cat_if_talk(
    sprintf(
      "Setting `app_prod` to %s",
      app_prod
    )
  )
  conf$default$app_prod <- app_prod

  # Export
  write_yaml(
    conf,
    conf_path
  )

  cat_if_talk(
    "Setting {usethis} project as `golem_wd`",
    fun = cli::cat_rule
  )
  proj_set(golem_wd)
}

#' @importFrom yaml read_yaml write_yaml
set_golem_things <- function(
  key,
  value,
  path,
  talkative,
  config = "default"
) {
  conf_path <- get_current_config(path, set_options = FALSE)
  stop_if(
    conf_path,
    is.null,
    "Unable to retrieve golem config file."
  )
  cat_if_talk <- function(..., fun = cat_green_tick) {
    if (talkative) {
      fun(...)
    }
  }

  cat_if_talk(
    sprintf(
      "Setting `%s` to %s",
      key,
      value
    )
  )

  conf <- read_yaml(conf_path, eval.expr = TRUE)
  conf[[config]][[key]] <- value
  write_yaml(
    conf,
    conf_path
  )

  invisible(path)
}

#' @export
#' @rdname golem_opts
#' @importFrom fs path_abs
set_golem_wd <- function(
  path = golem::pkg_path(),
  talkative = TRUE
) {
  path <- path_abs(path)
  # Setting wd

  if (path == here::here()) {
    path <- "here::here()"
    attr(path, "tag") <- "!expr"
  }

  set_golem_things(
    "golem_wd",
    path,
    path,
    talkative = talkative,
    config = "dev"
  )

  invisible(path)
}

#' @export
#' @rdname golem_opts
#' @importFrom fs path_abs
set_golem_name <- function(
  name = golem::pkg_name(),
  path = golem::pkg_path(),
  talkative = TRUE
) {
  path <- path_abs(path)
  # Changing in YAML
  set_golem_things(
    "golem_name",
    name,
    path,
    talkative = talkative
  )
  # Changing in app-config.R
  change_app_config_name(
    name = name,
    path = path
  )

  # Changing in DESCRIPTION
  desc <- desc::description$new(
    file = fs::path(
      path,
      "DESCRIPTION"
    )
  )
  desc$set(
    Package = name
  )
  desc$write(
    file = "DESCRIPTION"
  )

  invisible(name)
}

#' @export
#' @rdname golem_opts
#' @importFrom fs path_abs
set_golem_version <- function(
  version = golem::pkg_version(),
  path = golem::pkg_path(),
  talkative = TRUE
) {
  path <- path_abs(path)
  set_golem_things(
    "golem_version",
    as.character(version),
    path,
    talkative = talkative
  )
  desc <- desc::description$new(file = fs::path(path, "DESCRIPTION"))
  desc$set_version(
    version = version
  )
  desc$write(
    file = "DESCRIPTION"
  )

  invisible(version)
}

#' @importFrom config get
get_golem_things <- function(
  value,
  config = Sys.getenv("R_CONFIG_ACTIVE", "default"),
  use_parent = TRUE,
  path
) {
  conf_path <- get_current_config(path, set_options = TRUE)
  stop_if(
    conf_path,
    is.null,
    "Unable to retrieve golem config file."
  )
  config::get(
    value = value,
    config = config,
    file = conf_path,
    use_parent = TRUE
  )
}


#' @export
#' @rdname golem_opts
get_golem_wd <- function(
  use_parent = TRUE,
  path = golem::pkg_path()
) {
  get_golem_things(
    value = "golem_wd",
    config = "dev",
    use_parent = use_parent,
    path = path
  )
}

#' @export
#' @rdname golem_opts
get_golem_name <- function(
  config = Sys.getenv("R_CONFIG_ACTIVE", "default"),
  use_parent = TRUE,
  path = golem::pkg_path()
) {
  nm <- get_golem_things(
    value = "golem_name",
    config = config,
    use_parent = use_parent,
    path = path
  )
  if (is.null(nm)) {
    nm <- golem::pkg_name()
  }
  nm
}

#' @export
#' @rdname golem_opts
get_golem_version <- function(
  config = Sys.getenv("R_CONFIG_ACTIVE", "default"),
  use_parent = TRUE,
  path = golem::pkg_path()
) {
  get_golem_things(
    value = "golem_version",
    config = config,
    use_parent = use_parent,
    path = path
  )
}
