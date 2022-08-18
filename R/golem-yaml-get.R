
#' @importFrom config get
get_golem_things <- function(
  value,
  config = Sys.getenv(
    "GOLEM_CONFIG_ACTIVE",
    Sys.getenv(
      "R_CONFIG_ACTIVE",
      "default"
    )
  ),
  use_parent = TRUE,
  path
) {
  conf_path <- get_current_config(
    path
  )
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
#' @importFrom fs path_abs
#' @rdname golem_opts
get_golem_wd <- function(
  use_parent = TRUE,
  pkg = golem::pkg_path()
) {
  path <- path_abs(pkg)

  pth <- get_golem_things(
    value = "golem_wd",
    config = "dev",
    use_parent = use_parent,
    path = path
  )
  if (is.null(pth)) {
    pth <- golem::pkg_path()
  }
  return(pth)
}

#' @export
#' @importFrom fs path_abs
#' @rdname golem_opts
get_golem_name <- function(
  config = Sys.getenv(
    "GOLEM_CONFIG_ACTIVE",
    Sys.getenv(
      "R_CONFIG_ACTIVE",
      "default"
    )
  ),
  use_parent = TRUE,
  pkg = golem::pkg_path()
) {
  path <- path_abs(pkg)
  nm <- get_golem_things(
    value = "golem_name",
    config = config,
    use_parent = use_parent,
    path = path
  )
  if (is.null(nm)) {
    nm <- golem::pkg_name()
  }
  return(nm)
}

#' @export
#' @importFrom fs path_abs
#' @rdname golem_opts
get_golem_version <- function(
  config = Sys.getenv(
    "GOLEM_CONFIG_ACTIVE",
    Sys.getenv(
      "R_CONFIG_ACTIVE",
      "default"
    )
  ),
  use_parent = TRUE,
  pkg = golem::pkg_path()
) {
  path <- path_abs(pkg)
  vers <- get_golem_things(
    value = "golem_version",
    config = config,
    use_parent = use_parent,
    path = path
  )
  if (is.null(vers)) {
    vers <- golem::pkg_version()
  }
  return(vers)
}
