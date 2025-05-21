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
  golem_wd,
  fall_back_fun = list,
  path
) {
  signal_arg_is_deprecated(
    path,
    fun = as.character(sys.call()[[1]])
  )
  conf_path <- get_current_config(
    golem_wd
  )
  stop_if(
    conf_path,
    is.null,
    "Unable to retrieve golem config file."
  )
  res <- config::get(
    value = value,
    config = config,
    file = conf_path,
    use_parent = TRUE
  )
  if (is.null(res)) {
    res <- fall_back_fun()
  }
  return(res)
}

#' @export
#' @rdname golem_opts
get_golem_wd <- function(
  use_parent = TRUE,
  golem_wd = golem::pkg_path(),
  pkg
) {
  signal_arg_is_deprecated(
    pkg,
    fun = as.character(sys.call()[[1]]),
    first_arg = "pkg"
  )

  get_golem_things(
    value = "golem_wd",
    config = "dev",
    use_parent = use_parent,
    golem_wd = fs_path_abs(golem_wd),
    fall_back_fun = golem::pkg_path
  )
}

#' @export
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
  golem_wd = golem::pkg_path(),
  pkg
) {
  signal_arg_is_deprecated(
    pkg,
    fun = as.character(sys.call()[[1]]),
    first_arg = "pkg"
  )
  get_golem_things(
    value = "golem_name",
    config = config,
    use_parent = use_parent,
    golem_wd = fs_path_abs(golem_wd),
    fall_back_fun = golem::pkg_name
  )
}

#' @export
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
  golem_wd = golem::pkg_path(),
  pkg
) {
  signal_arg_is_deprecated(
    pkg,
    fun = as.character(sys.call()[[1]]),
    first_arg = "pkg"
  )
  get_golem_things(
    value = "golem_version",
    config = config,
    use_parent = use_parent,
    golem_wd = fs_path_abs(golem_wd),
    fall_back_fun = golem::pkg_version
  )
}
