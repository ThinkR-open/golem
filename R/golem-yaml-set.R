
#' Set things in golem config
#'
#' @param key,value entries in the yaml
#' @param path path to the config file
#' @param talkative Should things be printed?
#' @param config config context to write to
#'
#' @noRd
#'
# set_golem_things <- function(
# 	key,
# 	value,
# 	config_file,
# 	talkative = TRUE,
# 	config = "default"
# ) {
# 	amend_golem_config(
# 		key = key,
# 		value = value,
# 		config = config,
# 		pkg = config_file,
# 		talkative = talkative
# 	)

# 	invisible(path)
# }

#' @export
#' @rdname golem_opts
#' @importFrom fs path_abs
set_golem_wd <- function(
  golem_wd = golem::pkg_path(),
  pkg = golem::pkg_path(),
  talkative = TRUE
) {
  if (
    golem_wd == "golem::pkg_path()" |
      golem_wd == golem::pkg_path()
  ) {
    golem_yaml_path <- "golem::pkg_path()"
    attr(golem_yaml_path, "tag") <- "!expr"
  } else {
    golem_yaml_path <- path_abs(golem_wd)
  }

  amend_golem_config(
    key = "golem_wd",
    value = golem_yaml_path,
    config = "dev",
    pkg = pkg,
    talkative = talkative
  )

  invisible(path)
}

#' @export
#' @rdname golem_opts
#' @importFrom fs path_abs
set_golem_name <- function(
  name = golem::pkg_name(),
  pkg = golem::pkg_path(),
  talkative = TRUE
) {

  path <- path_abs(pkg)

  # Changing in YAML
  amend_golem_config(
    key = "golem_name",
    value = name,
    config = "default",
    pkg = pkg,
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
  pkg = golem::pkg_path(),
  talkative = TRUE
) {
  path <- path_abs(pkg)

  # Changing in YAML
  amend_golem_config(
    key = "golem_version",
    value = as.character(version),
    config = "default",
    pkg = pkg,
    talkative = talkative
  )

  desc <- desc::description$new(
    file = fs::path(
      path,
      "DESCRIPTION"
    )
  )
  desc$set_version(
    version = version
  )
  desc$write(
    file = "DESCRIPTION"
  )

  invisible(version)
}
